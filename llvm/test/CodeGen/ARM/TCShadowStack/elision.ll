; RUN: llc -mtriple=thumbv8m.main %s -o /dev/null

define void @main() shadowcallstack {
        ; instrumentation code is omitted because LR is not
        ; spilled to the stack

        ; CHECK-LABEL: main:
        ; CHECK:       @ %bb.0:
        ; CHECK-NEXT:    bx      lr
        ret void
}
