; RUN: llc -mtriple=thumbv8m.main %s -o - | FileCheck %s

declare void @ext_func()

define void @main(i32 %x) shadowcallstack {
; CHECK-LABEL:  main:
; CHECK:          @ %bb.0:
; CHECK:          cmp     r0, #1
; CHECK:          it      eq
; CHECK:          bxeq    lr
; CHECK:          adr.w   r12, .Ltmp0
; CHECK-NEXT:     ldr.w   pc, .Ltmp1
; CHECK-NEXT:     .p2align        2
; CHECK-LABEL:  .Ltmp1:
; CHECK-NEXT:     .long   __TCPrivateShadowPush
start:
  %eq = icmp eq i32 %x, 1
  br i1 %eq, label %early_return, label %body
  
early_return:
  ret void

body:
  call void @ext_func()
  ret void
}