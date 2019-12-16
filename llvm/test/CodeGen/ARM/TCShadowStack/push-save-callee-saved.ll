; RUN: llc -mtriple=thumbv8m.main %s -o - | FileCheck %s

declare void @ext_func()

define void @main() shadowcallstack {
; CHECK-LABEL:  main:
; CHECK:          @ %bb.0:
; CHECK-NEXT:     push    {r4, lr}
; CHECK-NEXT:     str     r5, [sp, #-4]!
; CHECK-NEXT:     adr.w   r12, .Ltmp0
; CHECK-NEXT:     ldr.w   pc, .Ltmp1
; CHECK-NEXT:     .p2align        2
; CHECK-LABEL:  .Ltmp1:
; CHECK-NEXT:     .long   __TCPrivateShadowPush
; CHECK-LABEL:  .Ltmp0:
; CHECK-NEXT:     ldr     r5, [sp], #4
; CHECK-NEXT:     @APP
        ; `r5` lives, so must be saved before calling `__TCPrivateShadowPush`.
        tail call void asm sideeffect "", "~{lr},~{r4},~{dirflag},~{fpsr},~{flags}"()
        ret void
}
