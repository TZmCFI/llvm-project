; RUN: llc -mtriple=thumbv8m.main %s -o - | FileCheck %s

declare void @ext_func()

define void @main(i32 %x) shadowcallstack {
; CHECK:        @ %without_tailcall
; CHECK-NEXT:     @APP
; CHECK-NEXT:     @NO_APP
; CHECK-NEXT:     pop.w   {r4, lr}
; CHECK-NEXT:     ldr.w   pc, .Ltmp2
; CHECK-NEXT:     .p2align        2
; CHECK-LABEL:  .Ltmp2:
; CHECK-NEXT:     .long   __TCPrivateShadowAssertReturn
; CHECK-NEXT:     bx      lr

; CHECK:        @ %with_tailcall
; CHECK-NEXT:     pop.w   {r4, lr}
; CHECK-NEXT:     adr.w   r12, .Ltmp3
; CHECK-NEXT:     ldr.w   pc, .Ltmp4
; CHECK-NEXT:     .p2align        2
; CHECK-LABEL:  .Ltmp4:
; CHECK-NEXT:     .long   __TCPrivateShadowAssert
; CHECK-LABEL:  .Ltmp3:
; CHECK-NEXT:     b       ext_func

start:
  call void @ext_func()
  %eq = icmp eq i32 %x, 2
  br i1 %eq, label %without_tailcall, label %with_tailcall

without_tailcall:
  call void asm sideeffect "", "~{lr},~{dirflag},~{fpsr},~{flags}"()
  br label %end

with_tailcall:
  tail call void @ext_func()
  br label %end

end:
  ret void
}