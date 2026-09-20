; The PIE intrinsics are gated on the esp32s3ops subtarget feature, so a CPU
; without the PIE unit must refuse the intrinsic instead of emitting an
; instruction it cannot execute. Positive and negative halves of one control
; pair: the same IR, three -mcpu values.
;
; The gate lives in two different places in XtensaS3DSPInstrPseudos.td -- the
; Predicates wrapper around the 214 Pseudo records, and the same wrapper around
; the 38 rur/wur `def : Pat` records -- so both places need a case here. They are
; in three split-file parts because llc aborts at the first intrinsic it cannot
; select: one unselectable intrinsic per module is all a run can prove.
;
; RUN: rm -rf %t && split-file %s %t
;
; RUN: llc -mtriple=xtensa -mcpu=esp32s3 -verify-machineinstrs < %t/pseudo.ll | FileCheck %s --check-prefix=PSEUDO-S3
; RUN: not --crash llc -mtriple=xtensa -mcpu=esp32 < %t/pseudo.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=PSEUDO-NOPIE
; RUN: not --crash llc -mtriple=xtensa < %t/pseudo.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=PSEUDO-NOPIE
;
; RUN: llc -mtriple=xtensa -mcpu=esp32s3 -verify-machineinstrs < %t/rur.ll | FileCheck %s --check-prefix=RUR-S3
; RUN: not --crash llc -mtriple=xtensa -mcpu=esp32 < %t/rur.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=RUR-NOPIE
; RUN: not --crash llc -mtriple=xtensa < %t/rur.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=RUR-NOPIE
;
; RUN: llc -mtriple=xtensa -mcpu=esp32s3 -verify-machineinstrs < %t/wur.ll | FileCheck %s --check-prefix=WUR-S3
; RUN: not --crash llc -mtriple=xtensa -mcpu=esp32 < %t/wur.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=WUR-NOPIE
; RUN: not --crash llc -mtriple=xtensa < %t/wur.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=WUR-NOPIE

;--- pseudo.ll
; An intrinsic that goes through a Pseudo record and the custom inserter.
declare void @llvm.xtensa.ee.andq(i32, i32, i32)

; PSEUDO-S3-LABEL: pie_pseudo:
; PSEUDO-S3: ee.andq q1, q2, q3
; PSEUDO-NOPIE: LLVM ERROR: Cannot select: intrinsic %llvm.xtensa.ee.andq
define void @pie_pseudo() {
  call void @llvm.xtensa.ee.andq(i32 1, i32 2, i32 3)
  ret void
}

;--- rur.ll
; A user-register read: no pseudo, no inserter, selected by a `def : Pat`.
declare i32 @llvm.xtensa.rur.accx.0()

; RUR-S3-LABEL: pie_rur:
; RUR-S3: rur.accx_0 a2
; RUR-NOPIE: LLVM ERROR: Cannot select: intrinsic %llvm.xtensa.rur.accx.0
define i32 @pie_rur() {
  %r = call i32 @llvm.xtensa.rur.accx.0()
  ret i32 %r
}

;--- wur.ll
; A user-register write: the other `def : Pat` shape, with an AR operand.
declare void @llvm.xtensa.wur.sar.byte(i32)

; WUR-S3-LABEL: pie_wur:
; WUR-S3: wur.sar_byte a2
; WUR-NOPIE: LLVM ERROR: Cannot select: intrinsic %llvm.xtensa.wur.sar.byte
define void @pie_wur(i32 %v) {
  call void @llvm.xtensa.wur.sar.byte(i32 %v)
  ret void
}
