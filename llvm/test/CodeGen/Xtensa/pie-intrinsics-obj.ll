; The assemble/disassemble round trip for the PIE intrinsic path: llc emits an
; object directly (no textual assembly in between), and the disassembler must
; give back the same ee.* mnemonics with the same q registers. This is what
; proves the MC encoder/decoder agree for the encodings the intrinsic layer
; selects, not only for the hand-written assembly in test/MC/Xtensa.
;
; RUN: llc -mtriple=xtensa -mcpu=esp32s3 -filetype=obj < %s -o %t.o
; RUN: llvm-objdump -d --mcpu=esp32s3 %t.o | FileCheck %s
;
; Offsets here are deliberately multiples of 16 that are not multiples of 256:
; mainline's decodeOffset_*Operand at this LLVM base
; (llvm/lib/Target/Xtensa/Disassembler/XtensaDisassembler.cpp) only shifts the
; encoded field when its low bits are non-zero, so an offset_256_16 field of 16
; (byte offset 256) decodes as 16 and a negative one trips an assertion. That is
; a pre-existing MC bug, reproducible with llvm-mc alone and independent of the
; intrinsics; it is not worked around here beyond staying out of its way.

declare void @llvm.xtensa.ee.andq(i32, i32, i32)
declare void @llvm.xtensa.ee.vld.128.ip(i32, i32, i32)
declare void @llvm.xtensa.ee.vst.128.ip(i32, i32, i32)
declare void @llvm.xtensa.ee.cmul.s16(i32, i32, i32, i32)
declare void @llvm.xtensa.ee.vmulas.s16.accx.ld.ip.qup(i32, i32, i32, i32, i32, i32, i32)
declare void @llvm.xtensa.ee.fft.r2bf.s16(i32, i32, i32, i32, i32)
declare void @llvm.xtensa.ee.movi.32.q(i32, i32, i32)
declare void @llvm.xtensa.mv.qr(i32, i32)
declare void @llvm.xtensa.wur.sar.byte(i32)
declare i32 @llvm.xtensa.rur.accx.0()

; CHECK-LABEL: <round_trip>:
; CHECK: ee.andq q7, q0, q1
; CHECK: ee.vld.128.ip q3, a{{[0-9]+}}, 16
; CHECK: ee.vst.128.ip q5, a{{[0-9]+}}, 32
; CHECK: ee.cmul.s16 q2, q3, q4, 1
; CHECK: ee.vmulas.s16.accx.ld.ip.qup q0, a{{[0-9]+}}, 16, q1, q2, q3, q4
; CHECK: ee.fft.r2bf.s16 q7, q6, q5, q4, 1
; CHECK: ee.movi.32.q q1, a{{[0-9]+}}, 3
; CHECK: mv.qr q6, q7
; The user-register writes come back in the generic spelling: llc emits the
; WUR_SAR_BYTE instruction (printed "wur.sar_byte a2") and the disassembler
; decodes those three bytes to the generic WUR, which prints the register name as
; an operand. Byte-identical either way -- llvm-mc gives [0x20,0x0d,0xf3] for
; both spellings -- so this is a printing choice, not a round-trip failure.
; Reads happen to decode to the specialized RUR_ACCX_0 instead.
; CHECK: wur a{{[0-9]+}}, sar_byte
; CHECK: rur.accx_0 a{{[0-9]+}}
define i32 @round_trip(i32 %as) {
  call void @llvm.xtensa.ee.andq(i32 7, i32 0, i32 1)
  call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 16)
  call void @llvm.xtensa.ee.vst.128.ip(i32 5, i32 %as, i32 32)
  call void @llvm.xtensa.ee.cmul.s16(i32 2, i32 3, i32 4, i32 1)
  call void @llvm.xtensa.ee.vmulas.s16.accx.ld.ip.qup(i32 0, i32 %as, i32 16, i32 1, i32 2, i32 3, i32 4)
  call void @llvm.xtensa.ee.fft.r2bf.s16(i32 7, i32 6, i32 5, i32 4, i32 1)
  call void @llvm.xtensa.ee.movi.32.q(i32 1, i32 %as, i32 3)
  call void @llvm.xtensa.mv.qr(i32 6, i32 7)
  call void @llvm.xtensa.wur.sar.byte(i32 %as)
  %r = call i32 @llvm.xtensa.rur.accx.0()
  ret i32 %r
}
