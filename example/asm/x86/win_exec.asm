[ORG 0]
[BITS 32]

entry:
  ; store context
  push ebx                              ; store ebx
  cld                                   ; clear the direction flag

  ; calculate entry address
  call calc_entry_addr                  ; calculate the entry address
  flag_CEA:                             ; flag for calculate entry address

  ; call "kernel32.dll, WinExec"
  lea edx, [ebx+command]                ; lpCmdLine
  xor ecx, ecx                          ; clear ecx
  mov cl, [ebx+cmd_show]                ; set uCmdShow
  push ecx                              ; push uCmdShow
  push edx                              ; push lpCmdLine
  push 2                                ; set num arguments
  push 0x61DA2999                       ; set hash key
  push 0x0AE20914                       ; set function hash
  call api_call                         ; call api function

  ; restore context
  pop ebx                               ; restore ebx
  ret                                   ; return to the caller

; calculate shellcode entry address
calc_entry_addr:
  pop eax                               ; get return address
  lea ebx, [eax-flag_CEA]               ; calculate entry address
  push eax                              ; push return address
  ret                                   ; return to entry

hash_api:
  %include "src/x86/api_call.asm"

command:
  db "calc.exe", 0

cmd_show:
  db 1
