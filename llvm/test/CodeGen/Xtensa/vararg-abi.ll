; RUN: llc -mtriple=xtensa -O2 < %s | FileCheck %s
; The second line is not a duplicate: the esp32s3 configuration is windowed and has an
; FPU, so f32 is a legal type there and the float case below goes down a different path.
; RUN: llc -mtriple=xtensa -mcpu=esp32s3 -O2 < %s | FileCheck %s --check-prefix=S3

; The decisive addresses of the Xtensa varargs ABI, checked one instruction at a time.
; vararg.ll dumps whole functions and so re-checks the scheduler on every change; this
; file asserts only what the ABI fixes; the va_list state machine and nothing else.
;
; The reference is GCC (xtensa_va_start / xtensa_gimplify_va_arg_expr in
; gcc/config/xtensa/xtensa.cc), because newlib's printf is GCC-compiled: a va_list this
; backend builds is walked by GCC-compiled code and vice versa. The layout, for a callee
; whose fixed arguments occupy ArgWords words:
;
;   va_reg  points at the first of the six words a2..a7 would occupy, so that
;           va_reg[ArgWords] is the first variadic word -- NOT at the first word the
;           prologue actually saved.
;   va_stk  is biased by 32 so that index 32 is the first variadic word on the stack,
;           and is 16-byte aligned so that aligning va_ndx aligns the address.
;   va_ndx  starts at ArgWords * 4, or at 32 + (ArgWords - 6) * 4 when the fixed
;           arguments already filled the six registers.
;
; Cross-checked against xtensa-esp32s3-elf-gcc 15.2.0 (crosstool-NG esp-15.2.0_20251204)
; on the equivalent C: for `int f(int n, ...)` GCC emits va_reg = sp+16 while saving a3 at
; sp+20, va_stk = argp-32 and va_ndx = 4.

declare void @llvm.va_start(ptr)
declare void @llvm.va_end(ptr)
declare void @llvm.va_copy(ptr, ptr)

; One fixed word: a3..a7 are saved, and va_reg is biased one word below a3's slot, which
; is where a2 would have been.
define i32 @va_reg_base_1(i32 %n, ...) nounwind {
; CHECK-LABEL: va_reg_base_1:
; CHECK:         s32i a3, a1, [[SAVE:[0-9]+]]
; CHECK:         addi a[[BASE:[0-9]+]], a1, [[SAVE]]
; CHECK-NEXT:    addi a{{[0-9]+}}, a[[BASE]], -4
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  %v = va_arg ptr %ap, i32
  call void @llvm.va_end(ptr %ap)
  ret i32 %v
}

; Four fixed words: the bias is four words, so the six-word view of the save area still
; starts at a2.
define i32 @va_reg_base_4(i32 %a1, i32 %a2, i32 %a3, i32 %a4, ...) nounwind {
; CHECK-LABEL: va_reg_base_4:
; CHECK:         s32i a6, a1, [[SAVE:[0-9]+]]
; CHECK:         addi a[[BASE:[0-9]+]], a1, [[SAVE]]
; CHECK-NEXT:    addi a{{[0-9]+}}, a[[BASE]], -16
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  %v = va_arg ptr %ap, i32
  call void @llvm.va_end(ptr %ap)
  ret i32 %v
}

; One va_arg site walking the register area, the crossing and the stack. The crossing sets
; va_ndx to the constant 32 + 4 and is decided by the index *before* the argument
; (`bge 24, orig`), not after it: adding 32 + 4 to the running index instead, for every
; stack-resident argument rather than only for the one that crosses, is what spaced them
; 40 bytes apart.
define i32 @va_stack_stride(i32 %n, ...) nounwind {
; CHECK-LABEL: va_stack_stride:
; CHECK:         movi a[[END:[0-9]+]], 24
; CHECK:         movi a[[CROSS:[0-9]+]], 36
; CHECK:         addi a[[NDX:[0-9]+]], a[[ORIG:[0-9]+]], 4
; CHECK:         blt a[[END]], a[[NDX]], .LBB
; CHECK:         bge a[[END]], a[[ORIG]], .LBB
; CHECK:         or a{{[0-9]+}}, a[[CROSS]], a[[CROSS]]
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %inext, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %accnext, %loop ]
  %v = va_arg ptr %ap, i32
  %accnext = add i32 %acc, %v
  %inext = add i32 %i, 1
  %done = icmp eq i32 %inext, %n
  br i1 %done, label %exit, label %loop
exit:
  call void @llvm.va_end(ptr %ap)
  ret i32 %accnext
}

; Eight fixed words: the six registers are full before the variadic part starts, so no
; register is saved and every variadic word is on the stack. va_ndx starts at
; 32 + (the first variadic word's offset from the 16-byte-aligned argument area), which is
; what keeps va_stk 16-byte aligned; GCC spells the same value (ArgWords + 2) * 4 = 40.
define i32 @va_fixed8_stack(i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, i32 %a8, ...) nounwind {
; CHECK-LABEL: va_fixed8_stack:
; CHECK-NOT:     s32i a{{[2-7]}}, a1,
; CHECK:         movi a[[MASK:[0-9]+]], 12
; CHECK:         addi a[[ARGP:[0-9]+]], a1, [[#%u,ARGOFF:]]
; CHECK-NEXT:    and a[[LOW:[0-9]+]], a[[ARGP]], a[[MASK]]
; CHECK-NEXT:    addi a{{[0-9]+}}, a[[LOW]], 36
; CHECK:         or a[[ADV:[0-9]+]], a[[LOW]], a{{[0-9]+}}
; CHECK-NEXT:    sub a[[STK:[0-9]+]], a[[ARGP]], a[[ADV]]
; CHECK-NEXT:    s32i a[[STK]], a1, 0
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  %v0 = va_arg ptr %ap, i32
  %v1 = va_arg ptr %ap, i32
  call void @llvm.va_end(ptr %ap)
  %r = add i32 %v0, %v1
  ret i32 %r
}

; One fixed word, then an i64: the caller puts it in a4:a5 because the first half has ABI
; alignment 8, so va_ndx has to be aligned from 4 up to 8 before the argument is taken --
; the index of the first half is therefore 8 + 4 and the address va_reg + 8. Type
; legalization has split the va_arg into two i32 ones by the time the target sees it, so
; the alignment can only come from the node, not from its value type.
define i64 @va_i64_odd(i32 %n, ...) nounwind {
; CHECK-LABEL: va_i64_odd:
; CHECK:         movi a{{[0-9]+}}, 12
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  %v = va_arg ptr %ap, i64
  call void @llvm.va_end(ptr %ap)
  ret i64 %v
}

; Five i32 then an i64 with one fixed word: va_ndx reaches 24, the i64 does not fit in the
; register area and is never split, so the crossing moves the whole of it to the first
; stack word (index 32, address va_stk + 32 == argp). The align-up of va_ndx is the
; decisive part; if its spelling changes, check that the i64 is still read from argp and
; argp + 4, which is where GCC reads it.
define i64 @va_i64_straddle(i32 %n, ...) nounwind {
; CHECK-LABEL: va_i64_straddle:
; CHECK:         addi a[[UP:[0-9]+]], a{{[0-9]+}}, 7
; CHECK-NEXT:    movi a[[NEG:[0-9]+]], -8
; CHECK-NEXT:    and a{{[0-9]+}}, a[[UP]], a[[NEG]]
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  %v0 = va_arg ptr %ap, i32
  %v1 = va_arg ptr %ap, i32
  %v2 = va_arg ptr %ap, i32
  %v3 = va_arg ptr %ap, i32
  %v4 = va_arg ptr %ap, i32
  %q = va_arg ptr %ap, i64
  call void @llvm.va_end(ptr %ap)
  ret i64 %q
}

; Seven fixed words, one of them already on the stack: the first variadic word is at
; argp + 4 (va_ndx 36), and an i64 must skip it and land at argp + 8 (va_ndx aligned up to
; 40). 39 and 56 are (36 + 7) and the mask -8 narrowed to the bits va_ndx can have; GCC
; reads the same i64 at argp + 8.
define i64 @va_fixed7_i64(i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, ...) nounwind {
; CHECK-LABEL: va_fixed7_i64:
; CHECK:         addi a[[UP:[0-9]+]], a{{[0-9]+}}, 39
; CHECK-NEXT:    movi a[[MASK:[0-9]+]], 56
; CHECK-NEXT:    and a{{[0-9]+}}, a[[UP]], a[[MASK]]
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  %v = va_arg ptr %ap, i64
  call void @llvm.va_end(ptr %ap)
  ret i64 %v
}

; A variadic argument whose value type is not an integer. va_ndx arithmetic is i32 whatever
; the argument's type is; taking the type from the VAARG node's result instead made this
; build an f32 ADD out of i32 operands, and llc asserted. The index is still 4 + 4 and the
; word read is still va_reg + 4. Only the esp32s3 run reaches that path: without an FPU
; f32 is softened to i32 before the target sees the node, so the S3 checks are the ones
; that matter here.
define float @va_f32(i32 %n, ...) nounwind {
; CHECK-LABEL: va_f32:
; CHECK:         movi a{{[0-9]+}}, 8
; CHECK:         l32i a2,
; S3-LABEL: va_f32:
; S3:            movi a{{[0-9]+}}, 8
; S3:            l32i a2,
entry:
  %ap = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  %v = va_arg ptr %ap, float
  call void @llvm.va_end(ptr %ap)
  ret float %v
}

; va_copy duplicates all three words, so the copy walks the same arguments; the original
; and the copy must be initialised from the same va_ndx.
define i32 @va_copy_words(i32 %n, ...) nounwind {
; CHECK-LABEL: va_copy_words:
; CHECK:         add a[[ADDR:[0-9]+]], a{{[0-9]+}}, a{{[0-9]+}}
; CHECK-NEXT:    addi a[[ADDR]], a[[ADDR]], -4
; CHECK-NEXT:    l32i a{{[0-9]+}}, a[[ADDR]], 0
; CHECK:         l32i a{{[0-9]+}}, a[[ADDR]], 0
entry:
  %ap = alloca [12 x i8], align 4
  %bp = alloca [12 x i8], align 4
  call void @llvm.va_start(ptr %ap)
  call void @llvm.va_copy(ptr %bp, ptr %ap)
  %v0 = va_arg ptr %ap, i32
  %w0 = va_arg ptr %bp, i32
  call void @llvm.va_end(ptr %ap)
  call void @llvm.va_end(ptr %bp)
  %r = add i32 %v0, %w0
  ret i32 %r
}
