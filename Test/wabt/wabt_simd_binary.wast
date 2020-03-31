;; Tests from wabt: https://github.com/WebAssembly/wabt/tree/master/test/interp
;; Distributed under the terms of the wabt license: https://github.com/WebAssembly/wabt/blob/master/LICENSE
;; Modified for compatibility with WAVM's interpretation of the proposed spec.

(module
  ;; i8x16 add
  (func (export "i8x16_add_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i8x16.add)
  (func (export "i8x16_add_1") (result v128)
    v128.const i32x4 0x00ff0001 0x04000002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0xfe000002 0x00000003 0x00000004
    i8x16.add)

  ;; i16x8 add
  (func (export "i16x8_add_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i16x8.add)
  (func (export "i16x8_add_1") (result v128)
    v128.const i32x4 0x00ffffff 0x0400ffff 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0xfe000002 0x00000003 0x00000004
    i16x8.add)

  ;; i32x4 add
  (func (export "i32x4_add_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i32x4.add)
  (func (export "i32x4_add_1") (result v128)
    v128.const i32x4 0xffffffff 0x0400ffff 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0xfe000002 0x00000003 0x00000004
    i32x4.add)

  ;; i64x2 add
  (func (export "i64x2_add_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i64x2.add)
  (func (export "i64x2_add_1") (result v128)
    v128.const i32x4 0x00000000 0x0400ffff 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0xfe000002 0x00000003 0x00000004
    i64x2.add)

  ;; i8x16 sub
  (func (export "i8x16_sub_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i8x16.sub)
  (func (export "i8x16_sub_1") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x00000004
    i8x16.sub)

  ;; i16x8 sub
  (func (export "i16x8_sub_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i16x8.sub)
  (func (export "i16x8_sub_1") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x00000004
    i16x8.sub)

  ;; i32x4 sub
  (func (export "i32x4_sub_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i32x4.sub)
  (func (export "i32x4_sub_1") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x00000004
    i32x4.sub)

  ;; i64x2 sub
  (func (export "i64x2_sub_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i64x2.sub)
  (func (export "i64x2_sub_1") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x00000004
    i64x2.sub)

  ;; i16x8 mul
  (func (export "i16x8_mul_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i16x8.mul)
  (func (export "i16x8_mul_1") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x00000004
    i16x8.mul)

  ;; i32x4 mul
  (func (export "i32x4_mul_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i32x4.mul)
  (func (export "i32x4_mul_1") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x00000004
    i32x4.mul)

  ;; i8x16 saturating add (signed and unsigned)
  (func (export "i8x16_add_saturate_signed_0") (result v128)
    v128.const i32x4 0x00000001 0x0000007f 0x00000003 0x00000080
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x000000ff
    i8x16.add_saturate_s)
  (func (export "i8x16_add_saturate_unsigned_0") (result v128)
    v128.const i32x4 0x00ff0001 0x04000002 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0xfe000002 0x00000003 0x00000004
    i8x16.add_saturate_u)

  ;; i16x8 saturating add (signed and unsigned)
  (func (export "i16x8_add_saturate_signed_0") (result v128)
    v128.const i32x4 0x00000001 0x00007fff 0x00000003 0x00008000
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x0000fffe
    i16x8.add_saturate_s)
  (func (export "i16x8_add_saturate_unsigned_0") (result v128)
    v128.const i32x4 0x00ffffff 0x0400ffff 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0xfe000002 0x00000003 0x00000004
    i16x8.add_saturate_u)

  ;; i8x16 saturating sub (signed and unsigned)
  (func (export "i8x16_sub_saturate_signed_0") (result v128)
    v128.const i32x4 0x00000001 0x0000007f 0x000000fe 0x00000080
    v128.const i32x4 0x00000001 0x000000fe 0x0000007f 0x000000ff
    i8x16.sub_saturate_s)
  (func (export "i8x16_sub_saturate_unsigned_0") (result v128)
    v128.const i32x4 0x00ff0001 0x0400007f 0x0000fffe 0x00000004
    v128.const i32x4 0x00020001 0xfe00fffe 0x0000007f 0x00000004
    i8x16.sub_saturate_u)

  ;; i16x8 saturating sub (signed and unsigned)
  (func (export "i16x8_sub_saturate_signed_0") (result v128)
    v128.const i32x4 0x00000001 0x00007fff 0x0000fffe 0x00008000
    v128.const i32x4 0x00000001 0x0000fffe 0x00007fff 0x0000fffe
    i16x8.sub_saturate_s)
  (func (export "i16x8_sub_saturate_unsigned_0") (result v128)
    v128.const i32x4 0x00ffffff 0x0400ffff 0x00000003 0x00000004
    v128.const i32x4 0x00020001 0xfe000002 0x00000003 0x00000004
    i16x8.sub_saturate_u)

  ;; v128 and
  (func (export "v128_and_0") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x44000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x55000004
    v128.and)

  ;; v128 or
  (func (export "v128_or_0") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x44000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x55000004
    v128.or)

  ;; v128 xor
  (func (export "v128_xor_0") (result v128)
    v128.const i32x4 0x00ff0001 0x00040002 0x44000003 0x00000004
    v128.const i32x4 0x00020001 0x00fe0002 0x00000003 0x55000004
    v128.xor)

  ;; f32x4 min
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN, 0x7fc00000 is a NaN.
  ;;  1234.5 = 0x449a5000,  1.0 = 0x3f800000
  ;; -1234.5 = 0xc49a5000, -1.0 = 0xbf800000
  ;; test is:   [-0.0, NaN,  1234.5, -1.0]
  ;;            [ 0.0, 1.0,  1234.5,  1.0]
  ;; expect is: [-0.0, NaN,  1234.5, -1.0]
  (func (export "f32x4_min_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x449a5000 0xbf800000
    v128.const i32x4 0x00000000 0x3f800000 0x449a5000 0x3f800000
    f32x4.min)

  ;; f64x2 min
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN, 0x7ff8000000000000 is a NaN.
  ;; 1234.5  = 0x40934a0000000000,  1.0 = 0x3ff0000000000000
  ;; -1234.5 = 0xc0934a0000000000, -1.0 = 0xbff0000000000000
  ;; tests are:   [ 0.0,     NaN]
  ;;              [-1234.5,  1.0]
  ;; expects are: [-1234.5,  NaN]
  (func (export "f64x2_min_0") (result v128)
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0xfff80000
    v128.const i32x4 0x00000000 0xc0934a00 0x00000000 0x3ff00000
    f64x2.min)

  ;; f32x4 max
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN, 0x7fc00000 is a NaN.
  ;;  1234.5 = 0x449a5000,  1.0 = 0x3f800000
  ;; -1234.5 = 0xc49a5000, -1.0 = 0xbf800000
  ;; test is:   [-0.0, NaN,  1234.5, -1.0]
  ;;            [ 0.0, 1.0,  1234.5,  1.0]
  ;; expect is: [ 0.0, NaN,  1234.5,  1.0]
  (func (export "f32x4_max_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x449a5000 0xbf800000
    v128.const i32x4 0x00000000 0x3f800000 0x449a5000 0x3f800000
    f32x4.max)

  ;; f64x2 max
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN, 0x7ff8000000000000 is a NaN.
  ;; 1234.5  = 0x40934a0000000000,  1.0 = 0x3ff0000000000000
  ;; -1234.5 = 0xc0934a0000000000, -1.0 = 0xbff0000000000000
  ;; tests are:   [ 0.0,     NaN]
  ;;              [-1234.5,  1.0]
  ;; expects are: [ 0.0,     NaN]
  (func (export "f64x2_max_0") (result v128)
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0xfff80000
    v128.const i32x4 0x00000000 0xc0934a00 0x00000000 0x3ff00000
    f64x2.max)

  ;; f32x4 add
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN
  ;;  1234.5 = 0x449a5000,  1.0 = 0x3f800000
  ;; -1234.5 = 0xc49a5000,  1.5 = 0x3fc00000
  ;;  1235.5 = 0x449a7000, -1233.0 = 0xc49a2000
  ;; test is:   [-0.0, NaN,  1234.5,  -1234.5]
  ;;            [ 0.0, 1.0,     1.0,      1.5]
  ;; expect is: [ 0.0, NaN,  1235.5,  -1233.0]
  (func (export "f32x4_add_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x449a5000 0xc49a5000
    v128.const i32x4 0x00000000 0x3f800000 0x3f800000 0x3fc00000
    f32x4.add)

  ;; f64x2 add
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN
  ;; -1233.0 = 0xc093440000000000,  1.0 = 0x3ff0000000000000
  ;; -1234.5 = 0xc0934a0000000000,  1.5 = 0x3ff8000000000000
  ;; tests are:   [    1.5,  NaN]
  ;;              [-1234.5,  1.0]
  ;; expects are: [-1233.0,  NaN]
  (func (export "f64x2_add_0") (result v128)
    v128.const i32x4 0x00000000 0x3ff80000 0x00000000 0xfff80000
    v128.const i32x4 0x00000000 0xc0934a00 0x00000000 0x3ff00000
    f64x2.add)

  ;; f32x4 sub
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN.
  ;;  1234.5 = 0x449a5000,  1.0 = 0x3f800000
  ;; -1234.5 = 0xc49a5000,  1.5 = 0x3fc00000
  ;;  1233.5 = 0x449a3000,  -1236.0 = 0xc49a8000
  ;; test is:   [-0.0, NaN,  1234.5,  -1234.5]
  ;;            [ 0.0, 1.0,     1.0,      1.5]
  ;; expect is: [-0.0, NaN,  1233.5,  -1236.0]
  (func (export "f32x4_sub_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x449a5000 0xc49a5000
    v128.const i32x4 0x00000000 0x3f800000 0x3f800000 0x3fc00000
    f32x4.sub)

  ;; f64x2 sub
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN.
  ;; 1236.0  = 0x4093500000000000,  1.0 = 0x3ff0000000000000
  ;; -1234.5 = 0xc0934a0000000000,  1.5 = 0x3ff8000000000000
  ;; tests are:   [    1.5,  NaN]
  ;;              [-1234.5,  1.0]
  ;; expects are: [ 1236.0,  NaN]
  (func (export "f64x2_sub_0") (result v128)
    v128.const i32x4 0x00000000 0x3ff80000 0x00000000 0xfff80000
    v128.const i32x4 0x00000000 0xc0934a00 0x00000000 0x3ff00000
    f64x2.sub)

  ;; f32x4 div
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN, 0x7fc00000 is a NaN.
  ;;   1.0 = 0x3f800000,  1.5 = 0x3fc00000
  ;;  -3.0 = 0xc0400000, -2.0 = 0xc0000000
  ;; test is:   [-0.0, NaN,  1.5,  -3.0]
  ;;            [ 0.0, 1.0,  1.0,   1.5]
  ;; expect is: [ NaN, NaN,  1.5,  -2.0]
  (func (export "f32x4_div_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x3fc00000 0xc0400000 
    v128.const i32x4 0x00000000 0x3f800000 0x3f800000 0x3fc00000
    f32x4.div)

  ;; f64x2 div
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN.
  ;; -3.0 = 0xc008000000000000,  1.0 = 0x3ff0000000000000
  ;; -2.0 = 0xc000000000000000,  1.5 = 0x3ff8000000000000
  ;; tests are:   [ 1.5,  -3.0]
  ;;              [ 1.0,   1.5]
  ;; expects are: [ 1.5,  -2.0]
  (func (export "f64x2_div_0") (result v128)
    v128.const i32x4 0x00000000 0x3ff80000 0x00000000 0xc0080000
    v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0x3ff80000
    f64x2.div)

  ;; f32x4 mul
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN.
  ;;   1.0 = 0x3f800000,  1.5 = 0x3fc00000
  ;;  -3.0 = 0xc0400000, -4.5 = 0xc0900000
  ;; test is:   [-0.0, NaN,  1.5,  -3.0]
  ;;            [ 0.0, 1.0,  1.0,   1.5]
  ;; expect is: [-0.0, NaN,  1.5,  -4.5]
  (func (export "f32x4_mul_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x3fc00000 0xc0400000
    v128.const i32x4 0x00000000 0x3f800000 0x3f800000 0x3fc00000
    f32x4.mul)

  ;; f64x2 mul
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN.
  ;; -3.0 = 0xc008000000000000,  1.0 = 0x3ff0000000000000
  ;; -4.5 = 0xc012000000000000,  1.5 = 0x3ff8000000000000
  ;; tests are:   [ 1.5,  -3.0]
  ;;              [ 1.0,   1.5]
  ;; expects are: [ 1.5,  -4.5]
  (func (export "f64x2_mul_0") (result v128)
    v128.const i32x4 0x00000000 0x3ff80000 0x00000000 0xc0080000
    v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0x3ff80000
    f64x2.mul)
)

(assert_return (invoke "i8x16_add_0") (v128.const i32x4 0x00000002 0x00000004 0x00000006 0x00000008))
(assert_return (invoke "i8x16_add_1") (v128.const i32x4 0x00010002 0x02000004 0x00000006 0x00000008))
(assert_return (invoke "i16x8_add_0") (v128.const i32x4 0x00000002 0x00000004 0x00000006 0x00000008))
(assert_return (invoke "i16x8_add_1") (v128.const i32x4 0x01010000 0x02000001 0x00000006 0x00000008))
(assert_return (invoke "i32x4_add_0") (v128.const i32x4 0x00000002 0x00000004 0x00000006 0x00000008))
(assert_return (invoke "i32x4_add_1") (v128.const i32x4 0x00020000 0x02010001 0x00000006 0x00000008))
(assert_return (invoke "i64x2_add_0") (v128.const i32x4 0x00000002 0x00000004 0x00000006 0x00000008))
(assert_return (invoke "i64x2_add_1") (v128.const i32x4 0x00020001 0x02010001 0x00000006 0x00000008))
(assert_return (invoke "i8x16_sub_0") (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000))
(assert_return (invoke "i8x16_sub_1") (v128.const i32x4 0x00fd0000 0x00060000 0x00000000 0x00000000))
(assert_return (invoke "i16x8_sub_0") (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000))
(assert_return (invoke "i16x8_sub_1") (v128.const i32x4 0x00fd0000 0xff060000 0x00000000 0x00000000))
(assert_return (invoke "i32x4_sub_0") (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000))
(assert_return (invoke "i32x4_sub_1") (v128.const i32x4 0x00fd0000 0xff060000 0x00000000 0x00000000))
(assert_return (invoke "i64x2_sub_0") (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000))
(assert_return (invoke "i64x2_sub_1") (v128.const i32x4 0x00fd0000 0xff060000 0x00000000 0x00000000))
(assert_return (invoke "i16x8_mul_0") (v128.const i32x4 0x00000001 0x00000004 0x00000009 0x00000010))
(assert_return (invoke "i16x8_mul_1") (v128.const i32x4 0x01fe0001 0x03f80004 0x00000009 0x00000010))
(assert_return (invoke "i32x4_mul_0") (v128.const i32x4 0x00000001 0x00000004 0x00000009 0x00000010))
(assert_return (invoke "i32x4_mul_1") (v128.const i32x4 0x01010001 0x02040004 0x00000009 0x00000010))
(assert_return (invoke "i8x16_add_saturate_signed_0") (v128.const i32x4 0x00000002 0x0000007f 0x00000006 0x00000080))
(assert_return (invoke "i8x16_add_saturate_unsigned_0") (v128.const i32x4 0x00ff0002 0xff000004 0x00000006 0x00000008))
(assert_return (invoke "i16x8_add_saturate_signed_0") (v128.const i32x4 0x00000002 0x00007fff 0x00000006 0x00008000))
(assert_return (invoke "i16x8_add_saturate_unsigned_0") (v128.const i32x4 0x0101ffff 0xffffffff 0x00000006 0x00000008))
(assert_return (invoke "i8x16_sub_saturate_signed_0") (v128.const i32x4 0x00000000 0x0000007f 0x00000080 0x00000081))
(assert_return (invoke "i8x16_sub_saturate_unsigned_0") (v128.const i32x4 0x00fd0000 0x00000000 0x0000ff7f 0x00000000))
(assert_return (invoke "i16x8_sub_saturate_signed_0") (v128.const i32x4 0x00000000 0x00007fff 0x00008000 0x00008002))
(assert_return (invoke "i16x8_sub_saturate_unsigned_0") (v128.const i32x4 0x00fdfffe 0x0000fffd 0x00000000 0x00000000))
(assert_return (invoke "v128_and_0") (v128.const i32x4 0x00020001 0x00040002 0x00000003 0x00000004))
(assert_return (invoke "v128_or_0") (v128.const i32x4 0x00ff0001 0x00fe0002 0x44000003 0x55000004))
(assert_return (invoke "v128_xor_0") (v128.const i32x4 0x00fd0000 0x00fa0000 0x44000000 0x55000000))
(assert_return (invoke "f32x4_min_0") (v128.const i32x4 0x80000000 0xffc00000 0x449a5000 0xbf800000))
(assert_return (invoke "f64x2_min_0") (v128.const i32x4 0x00000000 0xc0934a00 0x00000000 0xfff80000))
(assert_return (invoke "f32x4_max_0") (v128.const i32x4 0x00000000 0xffc00000 0x449a5000 0x3f800000))
(assert_return (invoke "f64x2_max_0") (v128.const i32x4 0x00000000 0x00000000 0x00000000 0xfff80000))
(assert_return (invoke "f32x4_add_0") (v128.const i32x4 0x00000000 0xffc00000 0x449a7000 0xc49a2000))
(assert_return (invoke "f64x2_add_0") (v128.const i32x4 0x00000000 0xc0934400 0x00000000 0xfff80000))
(assert_return (invoke "f32x4_sub_0") (v128.const i32x4 0x80000000 0xffc00000 0x449a3000 0xc49a8000))
(assert_return (invoke "f64x2_sub_0") (v128.const i32x4 0x00000000 0x40935000 0x00000000 0xfff80000))

;; These tests should accept any NaN, but there isn't a good way to match that in one vector element:
(assert_return (invoke "f32x4_div_0") (v128.const f32x4 nan:canonical nan:canonical 1.5 -2))
(assert_return (invoke "f32x4_mul_0") (v128.const f32x4 -0.0 nan:canonical 1.5 -4.5))
(assert_return (invoke "f64x2_div_0") (v128.const f32x4 0x00000000 1.9375 0x00000000 -2))
(assert_return (invoke "f64x2_mul_0") (v128.const f32x4 0x00000000 1.9375 0x00000000 -2.28125))