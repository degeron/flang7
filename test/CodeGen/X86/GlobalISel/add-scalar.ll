; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-linux-gnu -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=X64
; RUN: llc -mtriple=i386-linux-gnu   -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=X32

define i64 @test_add_i64(i64 %arg1, i64 %arg2) {
; X64-LABEL: test_add_i64:
; X64:       # %bb.0:
; X64-NEXT:    leaq (%rsi,%rdi), %rax
; X64-NEXT:    retq
;
; X32-LABEL: test_add_i64:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    adcl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    retl
  %ret = add i64 %arg1, %arg2
  ret i64 %ret
}

define i32 @test_add_i32(i32 %arg1, i32 %arg2) {
; X64-LABEL: test_add_i32:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-NEXT:    leal (%rsi,%rdi), %eax
; X64-NEXT:    retq
;
; X32-LABEL: test_add_i32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
  %ret = add i32 %arg1, %arg2
  ret i32 %ret
}

define i16 @test_add_i16(i16 %arg1, i16 %arg2) {
; X64-LABEL: test_add_i16:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-NEXT:    leal (%rsi,%rdi), %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X32-LABEL: test_add_i16:
; X32:       # %bb.0:
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    addw {{[0-9]+}}(%esp), %ax
; X32-NEXT:    retl
  %ret = add i16 %arg1, %arg2
  ret i16 %ret
}

define i8 @test_add_i8(i8 %arg1, i8 %arg2) {
; X64-LABEL: test_add_i8:
; X64:       # %bb.0:
; X64-NEXT:    addb %dil, %sil
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    retq
;
; X32-LABEL: test_add_i8:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    addb {{[0-9]+}}(%esp), %al
; X32-NEXT:    retl
  %ret = add i8 %arg1, %arg2
  ret i8 %ret
}

define i32 @test_add_i1(i32 %arg1, i32 %arg2) {
; X64-LABEL: test_add_i1:
; X64:       # %bb.0:
; X64-NEXT:    cmpl %esi, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    addb %al, %al
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    andl $1, %eax
; X64-NEXT:    retq
;
; X32-LABEL: test_add_i1:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    cmpl %eax, {{[0-9]+}}(%esp)
; X32-NEXT:    sete %al
; X32-NEXT:    addb %al, %al
; X32-NEXT:    movzbl %al, %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    retl
  %c = icmp eq i32 %arg1, %arg2
  %x = add i1 %c , %c
  %ret = zext i1 %x to i32
  ret i32 %ret
}
