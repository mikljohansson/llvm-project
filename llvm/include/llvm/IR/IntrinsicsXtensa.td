//===- IntrinsicsXtensa.td - Defines Xtensa intrinsics ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the Xtensa-specific intrinsics.
//
//===----------------------------------------------------------------------===//

let TargetPrefix = "xtensa" in {  // All intrinsics start with "llvm.xtensa.".

include "llvm/IR/IntrinsicsXtensaESP32S3.td"

}
