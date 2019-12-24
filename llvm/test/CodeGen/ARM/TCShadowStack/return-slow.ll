; RUN: llc -mtriple=thumbv8m.main %s -o - | FileCheck %s

declare void @ext_func()

define {i32, i32, i32, i32} @main() shadowcallstack {
; CHECK-LABEL:  .Ltmp0:
; CHECK-NEXT:     pop     {r4, r5}
; CHECK-NEXT:     bl      ext_func
; CHECK-NEXT:     movs    r0, #0
; CHECK-NEXT:     movs    r1, #0
; CHECK-NEXT:     movs    r2, #0
; CHECK-NEXT:     movs    r3, #0
; CHECK-NEXT:     pop.w   {r7, lr}
; CHECK-NEXT:     ldr.w   pc, .Ltmp2
; CHECK-NEXT:     .p2align        2
; CHECK-LABEL:  .Ltmp2:
; CHECK-NEXT:     .long   __TCPrivateShadowAssertReturn
        call void @ext_func()
        ret {i32, i32, i32, i32} zeroinitializer
}
