#include <errno.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>
#include <exception>
#include "POSIXPrivate.h"
#include "WAVM/Inline/Assert.h"
#include "WAVM/Inline/BasicTypes.h"
#include "WAVM/Inline/Errors.h"
#include "WAVM/Platform/Intrinsic.h"
#include "WAVM/Platform/Memory.h"
#include "WAVM/Platform/Mutex.h"

#ifdef WAVM_HAS_TRACY
#include <tracy/Tracy.hpp>
#endif

#ifdef __APPLE__
#define MAP_ANONYMOUS MAP_ANON
#endif

using namespace WAVM;
using namespace WAVM::Platform;

static Uptr internalGetPreferredVirtualPageSizeLog2()
{
	U32 preferredVirtualPageSize = sysconf(_SC_PAGESIZE);
	// Verify our assumption that the virtual page size is a power of two.
	WAVM_ASSERT(!(preferredVirtualPageSize & (preferredVirtualPageSize - 1)));
	return floorLogTwo(preferredVirtualPageSize);
}
Uptr Platform::getBytesPerPageLog2()
{
	static Uptr preferredVirtualPageSizeLog2 = internalGetPreferredVirtualPageSizeLog2();
	return preferredVirtualPageSizeLog2;
}

static U32 memoryAccessAsPOSIXFlag(MemoryAccess access)
{
	switch(access)
	{
	default:
	case MemoryAccess::none: return PROT_NONE;
	case MemoryAccess::readOnly: return PROT_READ;
	case MemoryAccess::readWrite: return PROT_READ | PROT_WRITE;
	case MemoryAccess::readExecute: return PROT_READ | PROT_EXEC;
	case MemoryAccess::readWriteExecute: return PROT_EXEC | PROT_READ | PROT_WRITE;
	}
}

static bool isPageAligned(U8* address)
{
	const Uptr addressBits = reinterpret_cast<Uptr>(address);
	return (addressBits & (getBytesPerPage() - 1)) == 0;
}

std::unique_ptr<MemoryOverrideHook> memoryOverrideHook = nullptr;

void Platform::installMemoryOverrideHook(std::unique_ptr<MemoryOverrideHook> hook)
{
	if(memoryOverrideHook)
	{
		fprintf(stderr, "Trying to double-register memory override hook\n");
		dumpErrorCallStack(0);
		std::terminate();
	}
	memoryOverrideHook = std::move(hook);
}

U8* Platform::allocateVirtualPages(Uptr numPages)
{
	if(memoryOverrideHook) { return memoryOverrideHook->allocateVirtualPages(numPages); }
	Uptr numBytes = numPages << getBytesPerPageLog2();
	void* result = mmap(nullptr, numBytes, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if(result == MAP_FAILED)
	{
		if(errno != ENOMEM)
		{
			fprintf(stderr,
					"mmap(0, %" WAVM_PRIuPTR
					", PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0) failed! errno=%s\n",
					numBytes,
					strerror(errno));
			dumpErrorCallStack(0);
		}
		return nullptr;
	}
	madvise(result, numBytes, MADV_HUGEPAGE);
#ifdef WAVM_HAS_TRACY
	TracyAllocNS(result, numBytes, 6, "WAVM");
#endif
	return (U8*)result;
}

U8* Platform::allocateAlignedVirtualPages(Uptr numPages,
										  Uptr alignmentLog2,
										  U8*& outUnalignedBaseAddress)
{
	if(memoryOverrideHook)
	{
		return memoryOverrideHook->allocateAlignedVirtualPages(
			numPages, alignmentLog2, outUnalignedBaseAddress);
	}
	const Uptr pageSizeLog2 = getBytesPerPageLog2();
	const Uptr numBytes = numPages << pageSizeLog2;
	if(alignmentLog2 > pageSizeLog2)
	{
		// Call mmap with enough padding added to the size to align the allocation within the
		// unaligned mapping.
		const Uptr alignmentBytes = 1ull << alignmentLog2;
		U8* unalignedBaseAddress = (U8*)mmap(
			nullptr, numBytes + alignmentBytes, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
		if(unalignedBaseAddress == MAP_FAILED)
		{
			if(errno != ENOMEM)
			{
				fprintf(stderr,
						"mmap(0, %" WAVM_PRIuPTR
						", PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0) failed! errno=%s\n",
						numBytes + alignmentBytes,
						strerror(errno));
				dumpErrorCallStack(0);
			}
			return nullptr;
		}

		const Uptr address = reinterpret_cast<Uptr>(unalignedBaseAddress);
		const Uptr alignedAddress = (address + alignmentBytes - 1) & ~(alignmentBytes - 1);
		U8* result = reinterpret_cast<U8*>(alignedAddress);

		// Unmap the start and end of the unaligned mapping, leaving the aligned mapping in the
		// middle.
		const Uptr numHeadPaddingBytes = alignedAddress - address;
		if(numHeadPaddingBytes > 0)
		{
			WAVM_ERROR_UNLESS(!munmap(unalignedBaseAddress, numHeadPaddingBytes));
		}

		const Uptr numTailPaddingBytes = alignmentBytes - (alignedAddress - address);
		if(numTailPaddingBytes > 0)
		{
			WAVM_ERROR_UNLESS(!munmap(result + (numPages << pageSizeLog2), numTailPaddingBytes));
		}

		outUnalignedBaseAddress = result;
		madvise(result, numBytes, MADV_HUGEPAGE);
#ifdef WAVM_HAS_TRACY
		TracyAllocNS(result, numBytes, 6, "WAVM");
#endif
		return result;
	}
	else
	{
		outUnalignedBaseAddress = allocateVirtualPages(numPages);
		return outUnalignedBaseAddress;
	}
}

bool Platform::commitVirtualPages(U8* baseVirtualAddress, Uptr numPages, MemoryAccess access)
{
	WAVM_ERROR_UNLESS(isPageAligned(baseVirtualAddress));
	if(memoryOverrideHook)
	{
		return memoryOverrideHook->commitVirtualPages(baseVirtualAddress, numPages, access);
	}
	int result = mprotect(
		baseVirtualAddress, numPages << getBytesPerPageLog2(), memoryAccessAsPOSIXFlag(access));
	if(result != 0)
	{
		fprintf(stderr,
				"mprotect(0x%" WAVM_PRIxPTR ", %" WAVM_PRIuPTR ", %u) failed: %s\n",
				reinterpret_cast<Uptr>(baseVirtualAddress),
				numPages << getBytesPerPageLog2(),
				memoryAccessAsPOSIXFlag(access),
				strerror(errno));
		dumpErrorCallStack(0);
	}
	return result == 0;
}

bool Platform::setVirtualPageAccess(U8* baseVirtualAddress, Uptr numPages, MemoryAccess access)
{
	WAVM_ERROR_UNLESS(isPageAligned(baseVirtualAddress));
	if(memoryOverrideHook)
	{
		return memoryOverrideHook->setVirtualPageAccess(baseVirtualAddress, numPages, access);
	}
	int result = mprotect(
		baseVirtualAddress, numPages << getBytesPerPageLog2(), memoryAccessAsPOSIXFlag(access));
	if(result != 0)
	{
		fprintf(stderr,
				"mprotect(0x%" WAVM_PRIxPTR ", %" WAVM_PRIuPTR ", %u) failed: %s\n",
				reinterpret_cast<Uptr>(baseVirtualAddress),
				numPages << getBytesPerPageLog2(),
				memoryAccessAsPOSIXFlag(access),
				strerror(errno));
		dumpErrorCallStack(0);
	}
	return result == 0;
}

void Platform::decommitVirtualPages(U8* baseVirtualAddress, Uptr numPages)
{
	WAVM_ERROR_UNLESS(isPageAligned(baseVirtualAddress));
	if(memoryOverrideHook)
	{
		return memoryOverrideHook->decommitVirtualPages(baseVirtualAddress, numPages);
	}
	auto numBytes = numPages << getBytesPerPageLog2();
	if(madvise(baseVirtualAddress, numBytes, MADV_DONTNEED) < 0)
	{
		Errors::fatalf("madvise(0x%" WAVM_PRIxPTR ", %" WAVM_PRIuPTR ", MADV_DONTNEED) failed: %s",
					   reinterpret_cast<Uptr>(baseVirtualAddress),
					   numBytes,
					   strerror(errno));
	}
	int result = mprotect(baseVirtualAddress, numBytes, PROT_NONE);
	if(result != 0)
	{
		fprintf(stderr,
				"mprotect(0x%" WAVM_PRIxPTR ", %" WAVM_PRIuPTR ", PROT_NONE) failed: %s\n",
				reinterpret_cast<Uptr>(baseVirtualAddress),
				numPages << getBytesPerPageLog2(),
				strerror(errno));
		dumpErrorCallStack(0);
	}
}

void Platform::freeVirtualPages(U8* baseVirtualAddress, Uptr numPages)
{
	WAVM_ERROR_UNLESS(isPageAligned(baseVirtualAddress));
	if(memoryOverrideHook)
	{
		return memoryOverrideHook->freeVirtualPages(baseVirtualAddress, numPages);
	}
	if(munmap(baseVirtualAddress, numPages << getBytesPerPageLog2()))
	{
		Errors::fatalf("munmap(0x%" WAVM_PRIxPTR ", %u) failed: %s",
					   reinterpret_cast<Uptr>(baseVirtualAddress),
					   numPages << getBytesPerPageLog2(),
					   strerror(errno));
	}
#ifdef WAVM_HAS_TRACY
	TracyFreeNS(baseVirtualAddress, 6, "WAVM");
#endif
}

void Platform::freeAlignedVirtualPages(U8* unalignedBaseAddress, Uptr numPages, Uptr alignmentLog2)
{
	WAVM_ERROR_UNLESS(isPageAligned(unalignedBaseAddress));
	if(memoryOverrideHook)
	{
		return memoryOverrideHook->freeAlignedVirtualPages(
			unalignedBaseAddress, numPages, alignmentLog2);
	}
	if(munmap(unalignedBaseAddress, numPages << getBytesPerPageLog2()))
	{
		Errors::fatalf("munmap(0x%" WAVM_PRIxPTR ", %u) failed: %s",
					   reinterpret_cast<Uptr>(unalignedBaseAddress),
					   numPages << getBytesPerPageLog2(),
					   strerror(errno));
	}
#ifdef WAVM_HAS_TRACY
	TracyFreeNS(unalignedBaseAddress, 6, "WAVM");
#endif
}

Uptr Platform::getPeakMemoryUsageBytes()
{
	struct rusage ru;
	WAVM_ERROR_UNLESS(!getrusage(RUSAGE_SELF, &ru));
#ifdef __APPLE__
	// POSIX and even the Mac OS X docs say this is in KB, but it's actually in bytes.
	return Uptr(ru.ru_maxrss);
#else
	return Uptr(ru.ru_maxrss) * 1024;
#endif
}
