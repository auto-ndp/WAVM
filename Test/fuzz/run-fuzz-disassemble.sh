#!/bin/bash

set -e

BUILD_DIR=$(pwd)
WAVM_DIR=$(cd `dirname $0`/../.. && pwd)
SCRIPT_DIR=$WAVM_DIR/Test/fuzz

SECONDS_PER_JOB=3600

mkdir -p wasm-seed-corpus
mkdir -p translated-compile-model-corpus

$SCRIPT_DIR/run-fuzzer-and-reduce-corpus.sh disassemble \
	wasm-seed-corpus \
	translated-compile-model-corpus \
	-max_total_time=$SECONDS_PER_JOB \
	-max_len=5000
