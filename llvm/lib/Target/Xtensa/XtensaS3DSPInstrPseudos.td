//===- XtensaS3DSPInstrPseudos.td - ESP32-S3 PIE intrinsics -*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// The llvm.xtensa.ee.* / llvm.xtensa.{r,w}ur.* / llvm.xtensa.mv.qr intrinsic
// layer for the ESP32-S3 PIE (Extended Instructions) unit, on top of the
// instruction encodings in XtensaS3DSPInstrInfo.td.
//
// The q-register operands of these intrinsics are immediates, not values: the
// caller names q0..q7 by number, a pseudo carries the number through ISel, and
// XtensaTargetLowering::EmitDSPInstrWithCustomInserter rewrites it to the
// physical register. There is deliberately no SSA value, no liveness and no
// allocation for the Q registers; the caller owns them.
//
// This layer lives in its own file, and not interleaved into
// XtensaS3DSPInstrInfo.td the way Espressif's fork has it, because that file is
// machine-generated from the ISA description and gets regenerated upstream:
// keeping it byte-identical to upstream's copy is what makes a rebase of this
// layer a no-op instead of 252 conflicts.
//
//===----------------------------------------------------------------------===//

// Every instruction reached from here is Requires<[HasESP32S3Ops]>; without the
// predicate on the pseudo too, ISel would happily select an intrinsic call for
// a CPU that has no PIE unit and the custom inserter would then emit an
// instruction the target cannot execute. Espressif's fork has no predicate here.
let Predicates = [HasESP32S3Ops] in {

let usesCustomInserter = 1 in {

def EE_ANDQ_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_andq_p, $qa, $qx, $qy",
			[(int_xtensa_ee_andq timm:$qa, timm:$qx, timm:$qy)]>;

def EE_BITREV_P : Pseudo<(outs), (ins imm8:$qa, AR:$ax),
				"!xtensa_ee_bitrev_p, $qa, $ax",
			[(int_xtensa_ee_bitrev timm:$qa, AR:$ax)]>;

def EE_CMUL_S16_P : Pseudo<(outs), (ins imm8:$qz, imm8:$qx, imm8:$qy, select_4:$sel4),
				"!xtensa_ee_cmul_s16_p, $qz, $qx, $qy, $sel4",
			[(int_xtensa_ee_cmul_s16 timm:$qz, timm:$qx, timm:$qy, timm:$sel4)]>;

def EE_CMUL_S16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy, select_4:$sel4),
				"!xtensa_ee_cmul_s16_ld_incp_p, $qu, $as, $qz, $qx, $qy, $sel4",
			[(int_xtensa_ee_cmul_s16_ld_incp timm:$qu, AR:$as, timm:$qz, timm:$qx, timm:$qy, timm:$sel4)]>;

def EE_CMUL_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy, select_4:$sel4),
				"!xtensa_ee_cmul_s16_st_incp_p, $qv, $as, $qz, $qx, $qy, $sel4",
			[(int_xtensa_ee_cmul_s16_st_incp timm:$qv, AR:$as, timm:$qz, timm:$qx, timm:$qy, timm:$sel4)]>;

def EE_FFT_AMS_S16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qz1, imm8:$qx, imm8:$qy, imm8:$qm, select_2:$sel2),
				"!xtensa_ee_fft_ams_s16_ld_incp_p, $qu, $as, $qz, $qz1, $qx, $qy, $qm, $sel2",
			[(int_xtensa_ee_fft_ams_s16_ld_incp timm:$qu, AR:$as, timm:$qz, timm:$qz1, timm:$qx, timm:$qy, timm:$qm, timm:$sel2)]>;

def EE_FFT_AMS_S16_LD_INCP_UAUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qz1, imm8:$qx, imm8:$qy, imm8:$qm, select_2:$sel2),
				"!xtensa_ee_fft_ams_s16_ld_incp_uaup_p, $qu, $as, $qz, $qz1, $qx, $qy, $qm, $sel2",
			[(int_xtensa_ee_fft_ams_s16_ld_incp_uaup timm:$qu, AR:$as, timm:$qz, timm:$qz1, timm:$qx, timm:$qy, timm:$qm, timm:$sel2)]>;

def EE_FFT_AMS_S16_LD_R32_DECP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qz1, imm8:$qx, imm8:$qy, imm8:$qm, select_2:$sel2),
				"!xtensa_ee_fft_ams_s16_ld_r32_decp_p, $qu, $as, $qz, $qz1, $qx, $qy, $qm, $sel2",
			[(int_xtensa_ee_fft_ams_s16_ld_r32_decp timm:$qu, AR:$as, timm:$qz, timm:$qz1, timm:$qx, timm:$qy, timm:$qm, timm:$sel2)]>;

def EE_FFT_AMS_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, imm8:$qz1, AR:$as0, AR:$as, imm8:$qx, imm8:$qy, imm8:$qm, select_2:$sel2),
				"!xtensa_ee_fft_ams_s16_st_incp_p, $qv, $qz1, $as0, $as, $qx, $qy, $qm, $sel2",
			[(int_xtensa_ee_fft_ams_s16_st_incp timm:$qv, timm:$qz1, AR:$as0, AR:$as, timm:$qx, timm:$qy, timm:$qm, timm:$sel2)]>;

def EE_FFT_CMUL_S16_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qz, imm8:$qx, imm8:$qy, select_8:$sel8),
				"!xtensa_ee_fft_cmul_s16_ld_xp_p, $qu, $as, $ad, $qz, $qx, $qy, $sel8",
			[(int_xtensa_ee_fft_cmul_s16_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qz, timm:$qx, timm:$qy, timm:$sel8)]>;

def EE_FFT_CMUL_S16_ST_XP_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy, imm8:$qv, AR:$as, AR:$ad, select_8:$sel8, select_4:$upd4, select_4:$sar4),
				"!xtensa_ee_fft_cmul_s16_st_xp_p, $qx, $qy, $qv, $as, $ad, $sel8, $upd4, $sar4",
			[(int_xtensa_ee_fft_cmul_s16_st_xp timm:$qx, timm:$qy, timm:$qv, AR:$as, AR:$ad, timm:$sel8, timm:$upd4, timm:$sar4)]>;

def EE_FFT_R2BF_S16_P : Pseudo<(outs), (ins imm8:$qa0, imm8:$qa1, imm8:$qx, imm8:$qy, select_2:$sel2),
				"!xtensa_ee_fft_r2bf_s16_p, $qa0, $qa1, $qx, $qy, $sel2",
			[(int_xtensa_ee_fft_r2bf_s16 timm:$qa0, timm:$qa1, timm:$qx, timm:$qy, timm:$sel2)]>;

def EE_FFT_R2BF_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qa0, imm8:$qx, imm8:$qy, AR:$as, select_4:$sar4),
				"!xtensa_ee_fft_r2bf_s16_st_incp_p, $qa0, $qx, $qy, $as, $sar4",
			[(int_xtensa_ee_fft_r2bf_s16_st_incp timm:$qa0, timm:$qx, timm:$qy, AR:$as, timm:$sar4)]>;

def EE_FFT_VST_R32_DECP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, select_2:$sar2),
				"!xtensa_ee_fft_vst_r32_decp_p, $qv, $as, $sar2",
			[(int_xtensa_ee_fft_vst_r32_decp timm:$qv, AR:$as, timm:$sar2)]>;

def EE_LDF_128_IP_P : Pseudo<(outs), (ins FPR:$fu3, FPR:$fu2, FPR:$fu1, FPR:$fu0, AR:$as, offset_16_16:$imm16f),
				"!xtensa_ee_ldf_128_ip_p, $fu3, $fu2, $fu1, $fu0, $as, $imm16f",
			[(int_xtensa_ee_ldf_128_ip FPR:$fu3, FPR:$fu2, FPR:$fu1, FPR:$fu0, AR:$as, timm:$imm16f)]>;

def EE_LDF_128_XP_P : Pseudo<(outs), (ins FPR:$fu3, FPR:$fu2, FPR:$fu1, FPR:$fu0, AR:$as, AR:$ad),
				"!xtensa_ee_ldf_128_xp_p, $fu3, $fu2, $fu1, $fu0, $as, $ad",
			[(int_xtensa_ee_ldf_128_xp FPR:$fu3, FPR:$fu2, FPR:$fu1, FPR:$fu0, AR:$as, AR:$ad)]>;

def EE_LDF_64_IP_P : Pseudo<(outs), (ins FPR:$fu1, FPR:$fu0, AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_ldf_64_ip_p, $fu1, $fu0, $as, $imm8",
			[(int_xtensa_ee_ldf_64_ip FPR:$fu1, FPR:$fu0, AR:$as, timm:$imm8)]>;

def EE_LDF_64_XP_P : Pseudo<(outs), (ins FPR:$fu1, FPR:$fu0, AR:$as, AR:$ad),
				"!xtensa_ee_ldf_64_xp_p, $fu1, $fu0, $as, $ad",
			[(int_xtensa_ee_ldf_64_xp FPR:$fu1, FPR:$fu0, AR:$as, AR:$ad)]>;

def EE_LDQA_S16_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ldqa_s16_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_ldqa_s16_128_ip AR:$as, timm:$imm16)]>;

def EE_LDQA_S16_128_XP_P : Pseudo<(outs), (ins AR:$as, AR:$ad),
				"!xtensa_ee_ldqa_s16_128_xp_p, $as, $ad",
			[(int_xtensa_ee_ldqa_s16_128_xp AR:$as, AR:$ad)]>;

def EE_LDQA_S8_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ldqa_s8_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_ldqa_s8_128_ip AR:$as, timm:$imm16)]>;

def EE_LDQA_S8_128_XP_P : Pseudo<(outs), (ins AR:$as, AR:$ad),
				"!xtensa_ee_ldqa_s8_128_xp_p, $as, $ad",
			[(int_xtensa_ee_ldqa_s8_128_xp AR:$as, AR:$ad)]>;

def EE_LDQA_U16_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ldqa_u16_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_ldqa_u16_128_ip AR:$as, timm:$imm16)]>;

def EE_LDQA_U16_128_XP_P : Pseudo<(outs), (ins AR:$as, AR:$ad),
				"!xtensa_ee_ldqa_u16_128_xp_p, $as, $ad",
			[(int_xtensa_ee_ldqa_u16_128_xp AR:$as, AR:$ad)]>;

def EE_LDQA_U8_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ldqa_u8_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_ldqa_u8_128_ip AR:$as, timm:$imm16)]>;

def EE_LDQA_U8_128_XP_P : Pseudo<(outs), (ins AR:$as, AR:$ad),
				"!xtensa_ee_ldqa_u8_128_xp_p, $as, $ad",
			[(int_xtensa_ee_ldqa_u8_128_xp AR:$as, AR:$ad)]>;

def EE_LDXQ_32_P : Pseudo<(outs), (ins imm8:$qu, imm8:$qs, AR:$as, select_4:$sel4, select_8:$sel8),
				"!xtensa_ee_ldxq_32_p, $qu, $qs, $as, $sel4, $sel8",
			[(int_xtensa_ee_ldxq_32 timm:$qu, timm:$qs, AR:$as, timm:$sel4, timm:$sel8)]>;

def EE_LD_128_USAR_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ld_128_usar_ip_p, $qu, $as, $imm16",
			[(int_xtensa_ee_ld_128_usar_ip timm:$qu, AR:$as, timm:$imm16)]>;

def EE_LD_128_USAR_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad),
				"!xtensa_ee_ld_128_usar_xp_p, $qu, $as, $ad",
			[(int_xtensa_ee_ld_128_usar_xp timm:$qu, AR:$as, AR:$ad)]>;

def EE_LD_ACCX_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_ld_accx_ip_p, $as, $imm8",
			[(int_xtensa_ee_ld_accx_ip AR:$as, timm:$imm8)]>;

def EE_LD_QACC_H_H_32_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_4:$imm4),
				"!xtensa_ee_ld_qacc_h_h_32_ip_p, $as, $imm4",
			[(int_xtensa_ee_ld_qacc_h_h_32_ip AR:$as, timm:$imm4)]>;

def EE_LD_QACC_H_L_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ld_qacc_h_l_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_ld_qacc_h_l_128_ip AR:$as, timm:$imm16)]>;

def EE_LD_QACC_L_H_32_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_4:$imm4),
				"!xtensa_ee_ld_qacc_l_h_32_ip_p, $as, $imm4",
			[(int_xtensa_ee_ld_qacc_l_h_32_ip AR:$as, timm:$imm4)]>;

def EE_LD_QACC_L_L_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ld_qacc_l_l_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_ld_qacc_l_l_128_ip AR:$as, timm:$imm16)]>;

def EE_LD_UA_STATE_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_ld_ua_state_ip_p, $as, $imm16",
			[(int_xtensa_ee_ld_ua_state_ip AR:$as, timm:$imm16)]>;

def EE_MOVI_32_A_P : Pseudo<(outs), (ins imm8:$qs, AR:$au, select_4:$sel4),
				"!xtensa_ee_movi_32_a_p, $qs, $au, $sel4",
			[(int_xtensa_ee_movi_32_a timm:$qs, AR:$au, timm:$sel4)]>;

def EE_MOVI_32_Q_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, select_4:$sel4),
				"!xtensa_ee_movi_32_q_p, $qu, $as, $sel4",
			[(int_xtensa_ee_movi_32_q timm:$qu, AR:$as, timm:$sel4)]>;

def EE_MOV_S16_QACC_P : Pseudo<(outs), (ins imm8:$qs),
				"!xtensa_ee_mov_s16_qacc_p, $qs",
			[(int_xtensa_ee_mov_s16_qacc timm:$qs)]>;

def EE_MOV_S8_QACC_P : Pseudo<(outs), (ins imm8:$qs),
				"!xtensa_ee_mov_s8_qacc_p, $qs",
			[(int_xtensa_ee_mov_s8_qacc timm:$qs)]>;

def EE_MOV_U16_QACC_P : Pseudo<(outs), (ins imm8:$qs),
				"!xtensa_ee_mov_u16_qacc_p, $qs",
			[(int_xtensa_ee_mov_u16_qacc timm:$qs)]>;

def EE_MOV_U8_QACC_P : Pseudo<(outs), (ins imm8:$qs),
				"!xtensa_ee_mov_u8_qacc_p, $qs",
			[(int_xtensa_ee_mov_u8_qacc timm:$qs)]>;

def EE_NOTQ_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx),
				"!xtensa_ee_notq_p, $qa, $qx",
			[(int_xtensa_ee_notq timm:$qa, timm:$qx)]>;

def EE_ORQ_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_orq_p, $qa, $qx, $qy",
			[(int_xtensa_ee_orq timm:$qa, timm:$qx, timm:$qy)]>;

def EE_SLCI_2Q_P : Pseudo<(outs), (ins imm8:$qs1, imm8:$qs0, select_16:$sar16),
				"!xtensa_ee_slci_2q_p, $qs1, $qs0, $sar16",
			[(int_xtensa_ee_slci_2q timm:$qs1, timm:$qs0, timm:$sar16)]>;

def EE_SLCXXP_2Q_P : Pseudo<(outs), (ins imm8:$qs1, imm8:$qs0, AR:$as, AR:$ad),
				"!xtensa_ee_slcxxp_2q_p, $qs1, $qs0, $as, $ad",
			[(int_xtensa_ee_slcxxp_2q timm:$qs1, timm:$qs0, AR:$as, AR:$ad)]>;

def EE_SRCI_2Q_P : Pseudo<(outs), (ins imm8:$qs1, imm8:$qs0, select_16:$sar16),
				"!xtensa_ee_srci_2q_p, $qs1, $qs0, $sar16",
			[(int_xtensa_ee_srci_2q timm:$qs1, timm:$qs0, timm:$sar16)]>;

def EE_SRCMB_S16_QACC_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, select_2:$sel2),
				"!xtensa_ee_srcmb_s16_qacc_p, $qu, $as, $sel2",
			[(int_xtensa_ee_srcmb_s16_qacc timm:$qu, AR:$as, timm:$sel2)]>;

def EE_SRCMB_S8_QACC_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, select_2:$sel2),
				"!xtensa_ee_srcmb_s8_qacc_p, $qu, $as, $sel2",
			[(int_xtensa_ee_srcmb_s8_qacc timm:$qu, AR:$as, timm:$sel2)]>;

def EE_SRCQ_128_ST_INCP_P : Pseudo<(outs), (ins imm8:$qs0, imm8:$qs1, AR:$as),
				"!xtensa_ee_srcq_128_st_incp_p, $qs0, $qs1, $as",
			[(int_xtensa_ee_srcq_128_st_incp timm:$qs0, timm:$qs1, AR:$as)]>;

def EE_SRCXXP_2Q_P : Pseudo<(outs), (ins imm8:$qs1, imm8:$qs0, AR:$as, AR:$ad),
				"!xtensa_ee_srcxxp_2q_p, $qs1, $qs0, $as, $ad",
			[(int_xtensa_ee_srcxxp_2q timm:$qs1, timm:$qs0, AR:$as, AR:$ad)]>;

def EE_SRC_Q_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_src_q_p, $qa, $qs0, $qs1",
			[(int_xtensa_ee_src_q timm:$qa, timm:$qs0, timm:$qs1)]>;

def EE_SRC_Q_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_256_16:$imm16, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_src_q_ld_ip_p, $qu, $as, $imm16, $qs0, $qs1",
			[(int_xtensa_ee_src_q_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qs0, timm:$qs1)]>;

def EE_SRC_Q_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_src_q_ld_xp_p, $qu, $as, $ad, $qs0, $qs1",
			[(int_xtensa_ee_src_q_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qs0, timm:$qs1)]>;

def EE_SRC_Q_QUP_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_src_q_qup_p, $qa, $qs0, $qs1",
			[(int_xtensa_ee_src_q_qup timm:$qa, timm:$qs0, timm:$qs1)]>;

def EE_SRS_ACCX_P : Pseudo<(outs), (ins AR:$au, AR:$as, select_2:$sel2),
				"!xtensa_ee_srs_accx_p, $au, $as, $sel2",
			[(int_xtensa_ee_srs_accx AR:$au, AR:$as, timm:$sel2)]>;

def EE_STF_128_IP_P : Pseudo<(outs), (ins FPR:$fv3, FPR:$fv2, FPR:$fv1, FPR:$fv0, AR:$as, offset_16_16:$imm16f),
				"!xtensa_ee_stf_128_ip_p, $fv3, $fv2, $fv1, $fv0, $as, $imm16f",
			[(int_xtensa_ee_stf_128_ip FPR:$fv3, FPR:$fv2, FPR:$fv1, FPR:$fv0, AR:$as, timm:$imm16f)]>;

def EE_STF_128_XP_P : Pseudo<(outs), (ins FPR:$fv3, FPR:$fv2, FPR:$fv1, FPR:$fv0, AR:$as, AR:$ad),
				"!xtensa_ee_stf_128_xp_p, $fv3, $fv2, $fv1, $fv0, $as, $ad",
			[(int_xtensa_ee_stf_128_xp FPR:$fv3, FPR:$fv2, FPR:$fv1, FPR:$fv0, AR:$as, AR:$ad)]>;

def EE_STF_64_IP_P : Pseudo<(outs), (ins FPR:$fv1, FPR:$fv0, AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_stf_64_ip_p, $fv1, $fv0, $as, $imm8",
			[(int_xtensa_ee_stf_64_ip FPR:$fv1, FPR:$fv0, AR:$as, timm:$imm8)]>;

def EE_STF_64_XP_P : Pseudo<(outs), (ins FPR:$fv1, FPR:$fv0, AR:$as, AR:$ad),
				"!xtensa_ee_stf_64_xp_p, $fv1, $fv0, $as, $ad",
			[(int_xtensa_ee_stf_64_xp FPR:$fv1, FPR:$fv0, AR:$as, AR:$ad)]>;

def EE_STXQ_32_P : Pseudo<(outs), (ins imm8:$qv, imm8:$qs, AR:$as, select_4:$sel4, select_8:$sel8),
				"!xtensa_ee_stxq_32_p, $qv, $qs, $as, $sel4, $sel8",
			[(int_xtensa_ee_stxq_32 timm:$qv, timm:$qs, AR:$as, timm:$sel4, timm:$sel8)]>;

def EE_ST_ACCX_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_st_accx_ip_p, $as, $imm8",
			[(int_xtensa_ee_st_accx_ip AR:$as, timm:$imm8)]>;

def EE_ST_QACC_H_H_32_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_4:$imm4),
				"!xtensa_ee_st_qacc_h_h_32_ip_p, $as, $imm4",
			[(int_xtensa_ee_st_qacc_h_h_32_ip AR:$as, timm:$imm4)]>;

def EE_ST_QACC_H_L_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_st_qacc_h_l_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_st_qacc_h_l_128_ip AR:$as, timm:$imm16)]>;

def EE_ST_QACC_L_H_32_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_4:$imm4),
				"!xtensa_ee_st_qacc_l_h_32_ip_p, $as, $imm4",
			[(int_xtensa_ee_st_qacc_l_h_32_ip AR:$as, timm:$imm4)]>;

def EE_ST_QACC_L_L_128_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_st_qacc_l_l_128_ip_p, $as, $imm16",
			[(int_xtensa_ee_st_qacc_l_l_128_ip AR:$as, timm:$imm16)]>;

def EE_ST_UA_STATE_IP_P : Pseudo<(outs), (ins AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_st_ua_state_ip_p, $as, $imm16",
			[(int_xtensa_ee_st_ua_state_ip AR:$as, timm:$imm16)]>;

def EE_VADDS_S16_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s16_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s16 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s16_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s16_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s16_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s16_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s32_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s32 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S32_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s32_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s32_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S32_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s32_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s32_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S8_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s8_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s8 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S8_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s8_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s8_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VADDS_S8_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vadds_s8_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vadds_s8_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_EQ_S16_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_eq_s16_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_eq_s16 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_EQ_S32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_eq_s32_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_eq_s32 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_EQ_S8_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_eq_s8_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_eq_s8 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_GT_S16_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_gt_s16_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_gt_s16 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_GT_S32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_gt_s32_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_gt_s32 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_GT_S8_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_gt_s8_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_gt_s8 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_LT_S16_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_lt_s16_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_lt_s16 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_LT_S32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_lt_s32_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_lt_s32 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VCMP_LT_S8_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vcmp_lt_s8_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vcmp_lt_s8 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VLDBC_16_P : Pseudo<(outs), (ins imm8:$qu, AR:$as),
				"!xtensa_ee_vldbc_16_p, $qu, $as",
			[(int_xtensa_ee_vldbc_16 timm:$qu, AR:$as)]>;

def EE_VLDBC_16_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_128_2:$imm2),
				"!xtensa_ee_vldbc_16_ip_p, $qu, $as, $imm2",
			[(int_xtensa_ee_vldbc_16_ip timm:$qu, AR:$as, timm:$imm2)]>;

def EE_VLDBC_16_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad),
				"!xtensa_ee_vldbc_16_xp_p, $qu, $as, $ad",
			[(int_xtensa_ee_vldbc_16_xp timm:$qu, AR:$as, AR:$ad)]>;

def EE_VLDBC_32_P : Pseudo<(outs), (ins imm8:$qu, AR:$as),
				"!xtensa_ee_vldbc_32_p, $qu, $as",
			[(int_xtensa_ee_vldbc_32 timm:$qu, AR:$as)]>;

def EE_VLDBC_32_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_256_4:$imm4),
				"!xtensa_ee_vldbc_32_ip_p, $qu, $as, $imm4",
			[(int_xtensa_ee_vldbc_32_ip timm:$qu, AR:$as, timm:$imm4)]>;

def EE_VLDBC_32_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad),
				"!xtensa_ee_vldbc_32_xp_p, $qu, $as, $ad",
			[(int_xtensa_ee_vldbc_32_xp timm:$qu, AR:$as, AR:$ad)]>;

def EE_VLDBC_8_P : Pseudo<(outs), (ins imm8:$qu, AR:$as),
				"!xtensa_ee_vldbc_8_p, $qu, $as",
			[(int_xtensa_ee_vldbc_8 timm:$qu, AR:$as)]>;

def EE_VLDBC_8_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_128_1:$imm1),
				"!xtensa_ee_vldbc_8_ip_p, $qu, $as, $imm1",
			[(int_xtensa_ee_vldbc_8_ip timm:$qu, AR:$as, timm:$imm1)]>;

def EE_VLDBC_8_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad),
				"!xtensa_ee_vldbc_8_xp_p, $qu, $as, $ad",
			[(int_xtensa_ee_vldbc_8_xp timm:$qu, AR:$as, AR:$ad)]>;

def EE_VLDHBC_16_INCP_P : Pseudo<(outs), (ins imm8:$qu, imm8:$qu1, AR:$as),
				"!xtensa_ee_vldhbc_16_incp_p, $qu, $qu1, $as",
			[(int_xtensa_ee_vldhbc_16_incp timm:$qu, timm:$qu1, AR:$as)]>;

def EE_VLD_128_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_vld_128_ip_p, $qu, $as, $imm16",
			[(int_xtensa_ee_vld_128_ip timm:$qu, AR:$as, timm:$imm16)]>;

def EE_VLD_128_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad),
				"!xtensa_ee_vld_128_xp_p, $qu, $as, $ad",
			[(int_xtensa_ee_vld_128_xp timm:$qu, AR:$as, AR:$ad)]>;

def EE_VLD_H_64_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_vld_h_64_ip_p, $qu, $as, $imm8",
			[(int_xtensa_ee_vld_h_64_ip timm:$qu, AR:$as, timm:$imm8)]>;

def EE_VLD_H_64_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad),
				"!xtensa_ee_vld_h_64_xp_p, $qu, $as, $ad",
			[(int_xtensa_ee_vld_h_64_xp timm:$qu, AR:$as, AR:$ad)]>;

def EE_VLD_L_64_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_vld_l_64_ip_p, $qu, $as, $imm8",
			[(int_xtensa_ee_vld_l_64_ip timm:$qu, AR:$as, timm:$imm8)]>;

def EE_VLD_L_64_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad),
				"!xtensa_ee_vld_l_64_xp_p, $qu, $as, $ad",
			[(int_xtensa_ee_vld_l_64_xp timm:$qu, AR:$as, AR:$ad)]>;

def EE_VMAX_S16_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s16_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s16 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s16_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s16_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s16_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s16_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s32_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s32 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S32_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s32_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s32_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S32_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s32_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s32_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S8_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s8_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s8 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S8_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s8_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s8_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMAX_S8_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmax_s8_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmax_s8_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S16_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s16_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s16 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s16_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s16_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s16_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s16_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s32_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s32 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S32_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s32_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s32_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S32_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s32_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s32_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S8_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s8_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s8 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S8_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s8_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s8_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMIN_S8_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmin_s8_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vmin_s8_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_ACCX_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s16_accx_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_s16_accx timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_ACCX_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s16_accx_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_s16_accx_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_ACCX_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s16_accx_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s16_accx_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S16_ACCX_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s16_accx_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_s16_accx_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_ACCX_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s16_accx_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s16_accx_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S16_QACC_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s16_qacc_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_s16_qacc timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_QACC_LDBC_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s16_qacc_ldbc_incp_p, $qu, $as, $qx, $qy",
			[(int_xtensa_ee_vmulas_s16_qacc_ldbc_incp timm:$qu, AR:$as, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_QACC_LDBC_INCP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s16_qacc_ldbc_incp_qup_p, $qu, $as, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s16_qacc_ldbc_incp_qup timm:$qu, AR:$as, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S16_QACC_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s16_qacc_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_s16_qacc_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_QACC_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s16_qacc_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s16_qacc_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S16_QACC_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s16_qacc_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_s16_qacc_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S16_QACC_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s16_qacc_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s16_qacc_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S8_ACCX_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s8_accx_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_s8_accx timm:$qx, timm:$qy)]>;

def EE_VMULAS_S8_ACCX_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s8_accx_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_s8_accx_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S8_ACCX_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s8_accx_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s8_accx_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S8_ACCX_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s8_accx_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_s8_accx_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S8_ACCX_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s8_accx_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s8_accx_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S8_QACC_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s8_qacc_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_s8_qacc timm:$qx, timm:$qy)]>;

def EE_VMULAS_S8_QACC_LDBC_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s8_qacc_ldbc_incp_p, $qu, $as, $qx, $qy",
			[(int_xtensa_ee_vmulas_s8_qacc_ldbc_incp timm:$qu, AR:$as, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S8_QACC_LDBC_INCP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s8_qacc_ldbc_incp_qup_p, $qu, $as, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s8_qacc_ldbc_incp_qup timm:$qu, AR:$as, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S8_QACC_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s8_qacc_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_s8_qacc_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S8_QACC_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s8_qacc_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s8_qacc_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_S8_QACC_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_s8_qacc_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_s8_qacc_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_S8_QACC_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_s8_qacc_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_s8_qacc_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U16_ACCX_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u16_accx_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_u16_accx timm:$qx, timm:$qy)]>;

def EE_VMULAS_U16_ACCX_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u16_accx_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_u16_accx_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U16_ACCX_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u16_accx_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u16_accx_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U16_ACCX_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u16_accx_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_u16_accx_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U16_ACCX_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u16_accx_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u16_accx_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U16_QACC_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u16_qacc_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_u16_qacc timm:$qx, timm:$qy)]>;

def EE_VMULAS_U16_QACC_LDBC_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u16_qacc_ldbc_incp_p, $qu, $as, $qx, $qy",
			[(int_xtensa_ee_vmulas_u16_qacc_ldbc_incp timm:$qu, AR:$as, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U16_QACC_LDBC_INCP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u16_qacc_ldbc_incp_qup_p, $qu, $as, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u16_qacc_ldbc_incp_qup timm:$qu, AR:$as, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U16_QACC_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u16_qacc_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_u16_qacc_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U16_QACC_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u16_qacc_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u16_qacc_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U16_QACC_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u16_qacc_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_u16_qacc_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U16_QACC_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u16_qacc_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u16_qacc_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U8_ACCX_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u8_accx_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_u8_accx timm:$qx, timm:$qy)]>;

def EE_VMULAS_U8_ACCX_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u8_accx_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_u8_accx_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U8_ACCX_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u8_accx_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u8_accx_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U8_ACCX_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u8_accx_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_u8_accx_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U8_ACCX_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u8_accx_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u8_accx_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U8_QACC_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u8_qacc_p, $qx, $qy",
			[(int_xtensa_ee_vmulas_u8_qacc timm:$qx, timm:$qy)]>;

def EE_VMULAS_U8_QACC_LDBC_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u8_qacc_ldbc_incp_p, $qu, $as, $qx, $qy",
			[(int_xtensa_ee_vmulas_u8_qacc_ldbc_incp timm:$qu, AR:$as, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U8_QACC_LDBC_INCP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u8_qacc_ldbc_incp_qup_p, $qu, $as, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u8_qacc_ldbc_incp_qup timm:$qu, AR:$as, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U8_QACC_LD_IP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u8_qacc_ld_ip_p, $qu, $as, $imm16, $qx, $qy",
			[(int_xtensa_ee_vmulas_u8_qacc_ld_ip timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U8_QACC_LD_IP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, offset_64_16:$imm16, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u8_qacc_ld_ip_qup_p, $qu, $as, $imm16, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u8_qacc_ld_ip_qup timm:$qu, AR:$as, timm:$imm16, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMULAS_U8_QACC_LD_XP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmulas_u8_qacc_ld_xp_p, $qu, $as, $ad, $qx, $qy",
			[(int_xtensa_ee_vmulas_u8_qacc_ld_xp timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy)]>;

def EE_VMULAS_U8_QACC_LD_XP_QUP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, AR:$ad, imm8:$qx, imm8:$qy, imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vmulas_u8_qacc_ld_xp_qup_p, $qu, $as, $ad, $qx, $qy, $qs0, $qs1",
			[(int_xtensa_ee_vmulas_u8_qacc_ld_xp_qup timm:$qu, AR:$as, AR:$ad, timm:$qx, timm:$qy, timm:$qs0, timm:$qs1)]>;

def EE_VMUL_S16_P : Pseudo<(outs), (ins imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_s16_p, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_s16 timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_S16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_s16_ld_incp_p, $qu, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_s16_ld_incp timm:$qu, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_s16_st_incp_p, $qv, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_s16_st_incp timm:$qv, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_S8_P : Pseudo<(outs), (ins imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_s8_p, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_s8 timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_S8_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_s8_ld_incp_p, $qu, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_s8_ld_incp timm:$qu, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_S8_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_s8_st_incp_p, $qv, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_s8_st_incp timm:$qv, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_U16_P : Pseudo<(outs), (ins imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_u16_p, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_u16 timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_U16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_u16_ld_incp_p, $qu, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_u16_ld_incp timm:$qu, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_U16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_u16_st_incp_p, $qv, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_u16_st_incp timm:$qv, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_U8_P : Pseudo<(outs), (ins imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_u8_p, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_u8 timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_U8_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_u8_ld_incp_p, $qu, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_u8_ld_incp timm:$qu, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VMUL_U8_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qz, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vmul_u8_st_incp_p, $qv, $as, $qz, $qx, $qy",
			[(int_xtensa_ee_vmul_u8_st_incp timm:$qv, AR:$as, timm:$qz, timm:$qx, timm:$qy)]>;

def EE_VPRELU_S16_P : Pseudo<(outs), (ins imm8:$qz, imm8:$qx, imm8:$qy, AR:$ay),
				"!xtensa_ee_vprelu_s16_p, $qz, $qx, $qy, $ay",
			[(int_xtensa_ee_vprelu_s16 timm:$qz, timm:$qx, timm:$qy, AR:$ay)]>;

def EE_VPRELU_S8_P : Pseudo<(outs), (ins imm8:$qz, imm8:$qx, imm8:$qy, AR:$ay),
				"!xtensa_ee_vprelu_s8_p, $qz, $qx, $qy, $ay",
			[(int_xtensa_ee_vprelu_s8 timm:$qz, timm:$qx, timm:$qy, AR:$ay)]>;

def EE_VRELU_S16_P : Pseudo<(outs), (ins imm8:$qs, AR:$ax, AR:$ay),
				"!xtensa_ee_vrelu_s16_p, $qs, $ax, $ay",
			[(int_xtensa_ee_vrelu_s16 timm:$qs, AR:$ax, AR:$ay)]>;

def EE_VRELU_S8_P : Pseudo<(outs), (ins imm8:$qs, AR:$ax, AR:$ay),
				"!xtensa_ee_vrelu_s8_p, $qs, $ax, $ay",
			[(int_xtensa_ee_vrelu_s8 timm:$qs, AR:$ax, AR:$ay)]>;

def EE_VSL_32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qs),
				"!xtensa_ee_vsl_32_p, $qa, $qs",
			[(int_xtensa_ee_vsl_32 timm:$qa, timm:$qs)]>;

def EE_VSMULAS_S16_QACC_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy, select_8:$sel8),
				"!xtensa_ee_vsmulas_s16_qacc_p, $qx, $qy, $sel8",
			[(int_xtensa_ee_vsmulas_s16_qacc timm:$qx, timm:$qy, timm:$sel8)]>;

def EE_VSMULAS_S16_QACC_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy, select_8:$sel8),
				"!xtensa_ee_vsmulas_s16_qacc_ld_incp_p, $qu, $as, $qx, $qy, $sel8",
			[(int_xtensa_ee_vsmulas_s16_qacc_ld_incp timm:$qu, AR:$as, timm:$qx, timm:$qy, timm:$sel8)]>;

def EE_VSMULAS_S8_QACC_P : Pseudo<(outs), (ins imm8:$qx, imm8:$qy, select_16:$sel16),
				"!xtensa_ee_vsmulas_s8_qacc_p, $qx, $qy, $sel16",
			[(int_xtensa_ee_vsmulas_s8_qacc timm:$qx, timm:$qy, timm:$sel16)]>;

def EE_VSMULAS_S8_QACC_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qx, imm8:$qy, select_16:$sel16),
				"!xtensa_ee_vsmulas_s8_qacc_ld_incp_p, $qu, $as, $qx, $qy, $sel16",
			[(int_xtensa_ee_vsmulas_s8_qacc_ld_incp timm:$qu, AR:$as, timm:$qx, timm:$qy, timm:$sel16)]>;

def EE_VSR_32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qs),
				"!xtensa_ee_vsr_32_p, $qa, $qs",
			[(int_xtensa_ee_vsr_32 timm:$qa, timm:$qs)]>;

def EE_VST_128_IP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, offset_256_16:$imm16),
				"!xtensa_ee_vst_128_ip_p, $qv, $as, $imm16",
			[(int_xtensa_ee_vst_128_ip timm:$qv, AR:$as, timm:$imm16)]>;

def EE_VST_128_XP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, AR:$ad),
				"!xtensa_ee_vst_128_xp_p, $qv, $as, $ad",
			[(int_xtensa_ee_vst_128_xp timm:$qv, AR:$as, AR:$ad)]>;

def EE_VST_H_64_IP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_vst_h_64_ip_p, $qv, $as, $imm8",
			[(int_xtensa_ee_vst_h_64_ip timm:$qv, AR:$as, timm:$imm8)]>;

def EE_VST_H_64_XP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, AR:$ad),
				"!xtensa_ee_vst_h_64_xp_p, $qv, $as, $ad",
			[(int_xtensa_ee_vst_h_64_xp timm:$qv, AR:$as, AR:$ad)]>;

def EE_VST_L_64_IP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, offset_256_8:$imm8),
				"!xtensa_ee_vst_l_64_ip_p, $qv, $as, $imm8",
			[(int_xtensa_ee_vst_l_64_ip timm:$qv, AR:$as, timm:$imm8)]>;

def EE_VST_L_64_XP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, AR:$ad),
				"!xtensa_ee_vst_l_64_xp_p, $qv, $as, $ad",
			[(int_xtensa_ee_vst_l_64_xp timm:$qv, AR:$as, AR:$ad)]>;

def EE_VSUBS_S16_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s16_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s16 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S16_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s16_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s16_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S16_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s16_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s16_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S32_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s32_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s32 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S32_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s32_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s32_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S32_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s32_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s32_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S8_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s8_p, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s8 timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S8_LD_INCP_P : Pseudo<(outs), (ins imm8:$qu, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s8_ld_incp_p, $qu, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s8_ld_incp timm:$qu, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VSUBS_S8_ST_INCP_P : Pseudo<(outs), (ins imm8:$qv, AR:$as, imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_vsubs_s8_st_incp_p, $qv, $as, $qa, $qx, $qy",
			[(int_xtensa_ee_vsubs_s8_st_incp timm:$qv, AR:$as, timm:$qa, timm:$qx, timm:$qy)]>;

def EE_VUNZIP_16_P : Pseudo<(outs), (ins imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vunzip_16_p, $qs0, $qs1",
			[(int_xtensa_ee_vunzip_16 timm:$qs0, timm:$qs1)]>;

def EE_VUNZIP_32_P : Pseudo<(outs), (ins imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vunzip_32_p, $qs0, $qs1",
			[(int_xtensa_ee_vunzip_32 timm:$qs0, timm:$qs1)]>;

def EE_VUNZIP_8_P : Pseudo<(outs), (ins imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vunzip_8_p, $qs0, $qs1",
			[(int_xtensa_ee_vunzip_8 timm:$qs0, timm:$qs1)]>;

def EE_VZIP_16_P : Pseudo<(outs), (ins imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vzip_16_p, $qs0, $qs1",
			[(int_xtensa_ee_vzip_16 timm:$qs0, timm:$qs1)]>;

def EE_VZIP_32_P : Pseudo<(outs), (ins imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vzip_32_p, $qs0, $qs1",
			[(int_xtensa_ee_vzip_32 timm:$qs0, timm:$qs1)]>;

def EE_VZIP_8_P : Pseudo<(outs), (ins imm8:$qs0, imm8:$qs1),
				"!xtensa_ee_vzip_8_p, $qs0, $qs1",
			[(int_xtensa_ee_vzip_8 timm:$qs0, timm:$qs1)]>;

def EE_XORQ_P : Pseudo<(outs), (ins imm8:$qa, imm8:$qx, imm8:$qy),
				"!xtensa_ee_xorq_p, $qa, $qx, $qy",
			[(int_xtensa_ee_xorq timm:$qa, timm:$qx, timm:$qy)]>;

def EE_ZERO_ACCX_P : Pseudo<(outs), (ins),
				"!xtensa_ee_zero_accx_p",
			[(int_xtensa_ee_zero_accx)]>;

def EE_ZERO_Q_P : Pseudo<(outs), (ins imm8:$qa),
				"!xtensa_ee_zero_q_p, $qa",
			[(int_xtensa_ee_zero_q timm:$qa)]>;

def EE_ZERO_QACC_P : Pseudo<(outs), (ins),
				"!xtensa_ee_zero_qacc_p",
			[(int_xtensa_ee_zero_qacc)]>;

def mv_QR_P : Pseudo<(outs), (ins imm8:$a, imm8:$b),
				"!xtensa_mv_qr_p, $a, $b",
			[(int_xtensa_mv_qr timm:$a, timm:$b)]>;

} // usesCustomInserter

// The user-register accessors need no pseudo: they take and return ordinary AR
// values, so the intrinsic selects straight onto the RUR/WUR encodings.
def : Pat<(i32 (int_xtensa_rur_accx_0)), (RUR_ACCX_0)>;
def : Pat<(i32 (int_xtensa_rur_accx_1)), (RUR_ACCX_1)>;
def : Pat<(i32 (int_xtensa_rur_fft_bit_width)), (RUR_FFT_BIT_WIDTH)>;
def : Pat<(i32 (int_xtensa_rur_gpio_out)), (RUR_GPIO_OUT)>;
def : Pat<(i32 (int_xtensa_rur_qacc_h_0)), (RUR_QACC_H_0)>;
def : Pat<(i32 (int_xtensa_rur_qacc_h_1)), (RUR_QACC_H_1)>;
def : Pat<(i32 (int_xtensa_rur_qacc_h_2)), (RUR_QACC_H_2)>;
def : Pat<(i32 (int_xtensa_rur_qacc_h_3)), (RUR_QACC_H_3)>;
def : Pat<(i32 (int_xtensa_rur_qacc_h_4)), (RUR_QACC_H_4)>;
def : Pat<(i32 (int_xtensa_rur_qacc_l_0)), (RUR_QACC_L_0)>;
def : Pat<(i32 (int_xtensa_rur_qacc_l_1)), (RUR_QACC_L_1)>;
def : Pat<(i32 (int_xtensa_rur_qacc_l_2)), (RUR_QACC_L_2)>;
def : Pat<(i32 (int_xtensa_rur_qacc_l_3)), (RUR_QACC_L_3)>;
def : Pat<(i32 (int_xtensa_rur_qacc_l_4)), (RUR_QACC_L_4)>;
def : Pat<(i32 (int_xtensa_rur_sar_byte)), (RUR_SAR_BYTE)>;
def : Pat<(i32 (int_xtensa_rur_ua_state_0)), (RUR_UA_STATE_0)>;
def : Pat<(i32 (int_xtensa_rur_ua_state_1)), (RUR_UA_STATE_1)>;
def : Pat<(i32 (int_xtensa_rur_ua_state_2)), (RUR_UA_STATE_2)>;
def : Pat<(i32 (int_xtensa_rur_ua_state_3)), (RUR_UA_STATE_3)>;

def : Pat<(int_xtensa_wur_accx_0 AR:$art), (WUR_ACCX_0 AR:$art)>;
def : Pat<(int_xtensa_wur_accx_1 AR:$art), (WUR_ACCX_1 AR:$art)>;
def : Pat<(int_xtensa_wur_fft_bit_width AR:$art), (WUR_FFT_BIT_WIDTH AR:$art)>;
def : Pat<(int_xtensa_wur_gpio_out AR:$art), (WUR_GPIO_OUT AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_h_0 AR:$art), (WUR_QACC_H_0 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_h_1 AR:$art), (WUR_QACC_H_1 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_h_2 AR:$art), (WUR_QACC_H_2 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_h_3 AR:$art), (WUR_QACC_H_3 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_h_4 AR:$art), (WUR_QACC_H_4 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_l_0 AR:$art), (WUR_QACC_L_0 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_l_1 AR:$art), (WUR_QACC_L_1 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_l_2 AR:$art), (WUR_QACC_L_2 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_l_3 AR:$art), (WUR_QACC_L_3 AR:$art)>;
def : Pat<(int_xtensa_wur_qacc_l_4 AR:$art), (WUR_QACC_L_4 AR:$art)>;
def : Pat<(int_xtensa_wur_sar_byte AR:$art), (WUR_SAR_BYTE AR:$art)>;
def : Pat<(int_xtensa_wur_ua_state_0 AR:$art), (WUR_UA_STATE_0 AR:$art)>;
def : Pat<(int_xtensa_wur_ua_state_1 AR:$art), (WUR_UA_STATE_1 AR:$art)>;
def : Pat<(int_xtensa_wur_ua_state_2 AR:$art), (WUR_UA_STATE_2 AR:$art)>;
def : Pat<(int_xtensa_wur_ua_state_3 AR:$art), (WUR_UA_STATE_3 AR:$art)>;

} // Predicates = [HasESP32S3Ops]
