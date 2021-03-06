; RUN: llc -mtriple=thumbv8m.main %s -o - | FileCheck %s

declare void @ext_func()

define void @main() shadowcallstack {
; CHECK-LABEL:  main:
; CHECK:          @ %bb.0:
; CHECK-NEXT:     push    {r7, lr}
; CHECK-NEXT:     push    {r4, r5}
; CHECK-NEXT:     adr.w   r12, .Ltmp0
; CHECK-NEXT:     ldr.w   pc, .Ltmp1
; CHECK-NEXT:     .p2align        2
; CHECK-LABEL:  .Ltmp1:
; CHECK-NEXT:     .long   __TCPrivateShadowPush
; CHECK-LABEL:  .Ltmp0:
; CHECK-NEXT:     pop     {r4, r5}
; CHECK-NEXT:     bl      ext_func
; CHECK-NEXT:     pop.w   {r7, lr}
; CHECK-NEXT:     ldr.w   pc, .Ltmp2
; CHECK-NEXT:     .p2align        2
; CHECK-LABEL:  .Ltmp2:
; CHECK-NEXT:     .long   __TCPrivateShadowAssertReturnFast
        call void @ext_func()
        ret void
}
