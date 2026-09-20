; Checks that the llvm.xtensa.* intrinsic layer is registered in the IR: these
; names resolve to real intrinsic IDs with the signatures the ESP32-S3 PIE
; layer declares, and survive a parse/verify/print round-trip.
;
; The verifier, not the backend, is under test here, so this needs no target.
; The negative half (a non-constant operand where the declaration says ImmArg)
; is in pie-intrinsics-immarg.ll.
;
; RUN: opt -S -passes=verify < %s | FileCheck %s

; CHECK-LABEL: define void @shapes(
; CHECK: call void @llvm.xtensa.ee.andq(i32 7, i32 0, i32 1)
; CHECK: call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 16)
; CHECK: call void @llvm.xtensa.ee.cmul.s16(i32 2, i32 3, i32 4, i32 1)
; CHECK: call void @llvm.xtensa.ee.vmulas.s16.accx(i32 1, i32 2)
; CHECK: call void @llvm.xtensa.ee.zero.qacc()
; CHECK: call void @llvm.xtensa.ee.movi.32.q(i32 1, i32 %as, i32 3)
; CHECK: call void @llvm.xtensa.ee.ldf.128.ip(float %f, float %f, float %f, float %f, i32 %as, i32 16)
; CHECK: call void @llvm.xtensa.mv.qr(i32 6, i32 7)
; CHECK: call void @llvm.xtensa.wur.sar.byte(i32 %as)
; CHECK: %acc = call i32 @llvm.xtensa.rur.accx.0()
define void @shapes(i32 %as, float %f) {
  call void @llvm.xtensa.ee.andq(i32 7, i32 0, i32 1)
  call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 16)
  call void @llvm.xtensa.ee.cmul.s16(i32 2, i32 3, i32 4, i32 1)
  call void @llvm.xtensa.ee.vmulas.s16.accx(i32 1, i32 2)
  call void @llvm.xtensa.ee.zero.qacc()
  call void @llvm.xtensa.ee.movi.32.q(i32 1, i32 %as, i32 3)
  call void @llvm.xtensa.ee.ldf.128.ip(float %f, float %f, float %f, float %f, i32 %as, i32 16)
  call void @llvm.xtensa.mv.qr(i32 6, i32 7)
  call void @llvm.xtensa.wur.sar.byte(i32 %as)
  %acc = call i32 @llvm.xtensa.rur.accx.0()
  ret void
}

; The address register operand of a load/store intrinsic is a value, not an
; immediate, so a non-constant there stays legal. This is the positive control
; for pie-intrinsics-immarg.ll: it proves the verifier is not simply rejecting
; every non-constant argument of these intrinsics.
; CHECK-LABEL: define void @nonconstant_address_register(
; CHECK: call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 16)
define void @nonconstant_address_register(i32 %as) {
  call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 16)
  ret void
}
