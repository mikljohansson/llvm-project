; Checks the selection decision for one representative ESP32-S3 PIE intrinsic of
; every operand-shape class: which ee.* instruction is chosen, and which q
; register each immediate q number becomes. The full 252-intrinsic sweep (which
; only checks mnemonics) is in xtensa-s3-dsp.ll.
;
; Address registers are matched as a{{[0-9]+}} on purpose: which AR the allocator
; picks is not the decision under test, and pinning it would make this test fail
; on every unrelated register-allocation change upstream.
;
; RUN: llc -mtriple=xtensa -mcpu=esp32s3 -verify-machineinstrs < %s | FileCheck %s

declare void @llvm.xtensa.ee.andq(i32, i32, i32)
declare void @llvm.xtensa.ee.notq(i32, i32)
declare void @llvm.xtensa.ee.vld.128.ip(i32, i32, i32)
declare void @llvm.xtensa.ee.vst.128.ip(i32, i32, i32)
declare void @llvm.xtensa.ee.vld.128.xp(i32, i32, i32)
declare void @llvm.xtensa.ee.cmul.s16(i32, i32, i32, i32)
declare void @llvm.xtensa.ee.zero.qacc()
declare void @llvm.xtensa.ee.vmulas.s16.accx(i32, i32)
declare void @llvm.xtensa.ee.vmulas.s16.accx.ld.ip.qup(i32, i32, i32, i32, i32, i32, i32)
declare void @llvm.xtensa.ee.zero.accx()
declare void @llvm.xtensa.ee.ld.accx.ip(i32, i32)
declare void @llvm.xtensa.ee.srs.accx(i32, i32, i32)
declare void @llvm.xtensa.ee.slci.2q(i32, i32, i32)
declare void @llvm.xtensa.ee.vsl.32(i32, i32)
declare void @llvm.xtensa.ee.srcq.128.st.incp(i32, i32, i32)
declare void @llvm.xtensa.ee.fft.r2bf.s16(i32, i32, i32, i32, i32)
declare void @llvm.xtensa.ee.fft.vst.r32.decp(i32, i32, i32)
declare void @llvm.xtensa.ee.movi.32.a(i32, i32, i32)
declare void @llvm.xtensa.ee.movi.32.q(i32, i32, i32)
declare void @llvm.xtensa.ee.ldf.128.ip(float, float, float, float, i32, i32)
declare void @llvm.xtensa.mv.qr(i32, i32)
declare void @llvm.xtensa.wur.sar.byte(i32)
declare i32 @llvm.xtensa.rur.accx.0()

; q-q-q: the three immediates become the destination and the two sources, in
; that order. 7/0/1 rather than 0/1/2 so a lost or reordered operand shows up.
define void @q_q_q() {
; CHECK-LABEL: q_q_q:
; CHECK: ee.andq q7, q0, q1
; CHECK: ee.notq q2, q5
  call void @llvm.xtensa.ee.andq(i32 7, i32 0, i32 1)
  call void @llvm.xtensa.ee.notq(i32 2, i32 5)
  ret void
}

; q + address register + offset immediate (post-increment addressing). The
; offset is a multiple of 16 that is not a multiple of 256: mainline's
; disassembler mis-decodes offset_256_16 fields whose low nibble is zero, which
; pie-intrinsics-obj.ll has to round-trip through.
define void @q_ar_offset(i32 %as) {
; CHECK-LABEL: q_ar_offset:
; CHECK: ee.vld.128.ip q3, a{{[0-9]+}}, 16
; CHECK: ee.vst.128.ip q5, a{{[0-9]+}}, 32
  call void @llvm.xtensa.ee.vld.128.ip(i32 3, i32 %as, i32 16)
  call void @llvm.xtensa.ee.vst.128.ip(i32 5, i32 %as, i32 32)
  ret void
}

; q + two address registers (indexed post-increment): both AR operands are
; values, so both must survive as registers and neither may become an immediate.
define void @q_ar_ar(i32 %as, i32 %ad) {
; CHECK-LABEL: q_ar_ar:
; CHECK: ee.vld.128.xp q4, a{{[0-9]+}}, a{{[0-9]+}}
  call void @llvm.xtensa.ee.vld.128.xp(i32 4, i32 %as, i32 %ad)
  ret void
}

; q-q-q plus a select immediate: the select field must not be confused with a
; q number, so 1 is used where the q numbers are 2/3/4.
define void @q_q_q_select() {
; CHECK-LABEL: q_q_q_select:
; CHECK: ee.cmul.s16 q2, q3, q4, 1
  call void @llvm.xtensa.ee.cmul.s16(i32 2, i32 3, i32 4, i32 1)
  ret void
}

; QACC accumulator: no operands at all, then two q sources feeding the implicit
; accumulator, then the widest shape in the set -- q, AR, offset, q, q, q, q.
define void @qacc(i32 %as) {
; CHECK-LABEL: qacc:
; CHECK: ee.zero.qacc
; CHECK: ee.vmulas.s16.accx q1, q2
; CHECK: ee.vmulas.s16.accx.ld.ip.qup q0, a{{[0-9]+}}, 16, q1, q2, q3, q4
  call void @llvm.xtensa.ee.zero.qacc()
  call void @llvm.xtensa.ee.vmulas.s16.accx(i32 1, i32 2)
  call void @llvm.xtensa.ee.vmulas.s16.accx.ld.ip.qup(i32 0, i32 %as, i32 16, i32 1, i32 2, i32 3, i32 4)
  ret void
}

; ACCX accumulator: AR + offset, and the shift-and-store form whose first
; argument the custom inserter ignores -- it writes the AR result into a fresh
; dead virtual register instead (XtensaS3ISelLowering.cpp, EE_SRS_ACCX_P). That
; is the fork's contract for this intrinsic, so the check allows any AR there.
define void @accx(i32 %as) {
; CHECK-LABEL: accx:
; CHECK: ee.zero.accx
; CHECK: ee.ld.accx.ip a{{[0-9]+}}, 8
; CHECK: ee.srs.accx a{{[0-9]+}}, a{{[0-9]+}}, 1
  call void @llvm.xtensa.ee.zero.accx()
  call void @llvm.xtensa.ee.ld.accx.ip(i32 %as, i32 8)
  call void @llvm.xtensa.ee.srs.accx(i32 %as, i32 3, i32 1)
  ret void
}

; Shifts: the two-q form whose q operands are both read and written, the SAR
; shift, and the store-with-shift form.
define void @shifts(i32 %as) {
; CHECK-LABEL: shifts:
; CHECK: ee.slci.2q q1, q0, 3
; CHECK: ee.vsl.32 q2, q3
; CHECK: ee.srcq.128.st.incp q4, q5, a{{[0-9]+}}
  call void @llvm.xtensa.ee.slci.2q(i32 1, i32 0, i32 3)
  call void @llvm.xtensa.ee.vsl.32(i32 2, i32 3)
  call void @llvm.xtensa.ee.srcq.128.st.incp(i32 4, i32 5, i32 %as)
  ret void
}

; FFT: four q operands in descending order plus a select, and the FFT store.
define void @fft(i32 %as) {
; CHECK-LABEL: fft:
; CHECK: ee.fft.r2bf.s16 q7, q6, q5, q4, 1
; CHECK: ee.fft.vst.r32.decp q3, a{{[0-9]+}}, 0
  call void @llvm.xtensa.ee.fft.r2bf.s16(i32 7, i32 6, i32 5, i32 4, i32 1)
  call void @llvm.xtensa.ee.fft.vst.r32.decp(i32 3, i32 %as, i32 0)
  ret void
}

; 32-bit lane moves and the whole-register move. ee.movi.32.a extracts a lane
; into an AR the intrinsic then throws away (the inserter defines a fresh vreg),
; so only the q register and the lane select are the decision here.
define void @lane_moves(i32 %as) {
; CHECK-LABEL: lane_moves:
; CHECK: ee.movi.32.a q0, a{{[0-9]+}}, 2
; CHECK: ee.movi.32.q q1, a{{[0-9]+}}, 3
; CHECK: mv.qr q6, q7
  call void @llvm.xtensa.ee.movi.32.a(i32 0, i32 %as, i32 2)
  call void @llvm.xtensa.ee.movi.32.q(i32 1, i32 %as, i32 3)
  call void @llvm.xtensa.mv.qr(i32 6, i32 7)
  ret void
}

; The float quad load is the one shape whose vector operands are FR registers
; rather than immediate q numbers, so four f registers must appear.
define void @float_quad(i32 %as, float %f) {
; CHECK-LABEL: float_quad:
; CHECK: ee.ldf.128.ip f{{[0-9]+}}, f{{[0-9]+}}, f{{[0-9]+}}, f{{[0-9]+}}, a{{[0-9]+}}, 16
  call void @llvm.xtensa.ee.ldf.128.ip(float %f, float %f, float %f, float %f, i32 %as, i32 16)
  ret void
}

; The user registers need no pseudo and no custom inserter: they select straight
; onto RUR/WUR with ordinary AR operands, and rur does produce a usable value.
define i32 @user_registers(i32 %v) {
; CHECK-LABEL: user_registers:
; CHECK: wur.sar_byte a{{[0-9]+}}
; CHECK: rur.accx_0 [[R:a[0-9]+]]
; CHECK: addi{{(\.n)?}} {{a[0-9]+}}, [[R]], 1
  call void @llvm.xtensa.wur.sar.byte(i32 %v)
  %r = call i32 @llvm.xtensa.rur.accx.0()
  %s = add i32 %r, 1
  ret i32 %s
}
