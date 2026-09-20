; The ESP32-S3 PIE intrinsics take their q-register numbers and their select /
; offset fields as immediates, not as values (see XtensaS3DSPInstrPseudos.td).
; ImmArg on those operands is what keeps that design safe: a non-constant
; q-register number is a verifier error rather than something the custom
; inserter would read with MachineOperand::getImm() on a register operand.
;
; The positive control -- the same intrinsics accepted, and a non-constant in
; the operand that really is a value -- is in pie-intrinsics-verify.ll.
;
; RUN: not opt -passes=verify -disable-output < %s 2>&1 | FileCheck %s

; CHECK: immarg operand has non-immediate parameter
; CHECK-NEXT: i32 %q
; CHECK-NEXT: call void @llvm.xtensa.ee.andq(i32 %q, i32 0, i32 1)
define void @nonconstant_q(i32 %q) {
  call void @llvm.xtensa.ee.andq(i32 %q, i32 0, i32 1)
  ret void
}

; CHECK: immarg operand has non-immediate parameter
; CHECK-NEXT: i32 %sel
; CHECK-NEXT: call void @llvm.xtensa.ee.cmul.s16(i32 2, i32 3, i32 4, i32 %sel)
define void @nonconstant_select(i32 %sel) {
  call void @llvm.xtensa.ee.cmul.s16(i32 2, i32 3, i32 4, i32 %sel)
  ret void
}

; CHECK: immarg operand has non-immediate parameter
; CHECK-NEXT: i32 %off
; CHECK-NEXT: call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 %off)
define void @nonconstant_offset(i32 %as, i32 %off) {
  call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 %off)
  ret void
}
