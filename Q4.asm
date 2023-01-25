org 0x7c00
jmp 0x0000:main

string: times 20 db 0 ; reservando memoria para string
main:

    xor ax, ax ;inicializaçao padrao
    xor bx,bx
    xor cx,cx
    xor dx,dx

    mov di,string
    call gets

    mov si, string ; valor inteiro da string(valor vezes 100 pois ignorei a virgula) está em al
    call stoi

    call verifyMoney

    verifyMoney:
        mov cx,ax
        xor ax,ax

        loop1:
            cmp cx,10000
            jae _loop1
            call print
            jmp loop2
        
            _loop1:
                sub cx,10000
                inc ax
                jmp loop1

        loop2: ; mesma logica
            cmp cx,5000
            jae _loop2
            call print
            jmp loop3

            _loop2:
            sub cx,5000
            inc ax
            jmp loop2

        loop3: ; mesma logica
            cmp cx,2000
            jae _loop3
            call print
            jmp loop4

            _loop3:
            sub cx,2000
            inc ax
            jmp loop3

        loop4: ; mesma logica
            cmp cx,1000
            jae _loop4
            call print
            jmp loop5

            _loop4:
            sub cx,1000
            inc ax
            jmp loop4
  
        loop5: ; mesma logica
            cmp cx,500
            jae _loop5
            call print
            jmp loop6
            
            _loop5:
            sub cx,500
            inc ax
            jmp loop5

        loop6: ; mesma logica
            cmp cx,250
            jae _loop6
            call print
            jmp loop7

            _loop6:
            sub cx,250
            inc ax
            jmp loop6

        loop7: ; mesma logica
            cmp cx,100
            jae _loop7
            call print
            jmp loop8

            _loop7:
            sub cx,100
            inc ax
            jmp loop7

        loop8: ; mesma logica
            cmp cx,50
            jae _loop8
            call print
            jmp loop9

            _loop8:
            sub cx,50
            inc ax
            jmp loop8
      
        loop9: ; mesma logica
            cmp cx,25
            jae _loop9
            call print
            jmp loop10

            _loop9:
            sub cx,25
            inc ax
            jmp loop9
      
        loop10: ; mesma logica
            cmp cx,10
            jae _loop10
            call print
            jmp loop11

            _loop10:
            sub cx,10
            inc ax
            jmp loop10

        loop11:
            cmp cx,5
            jae _loop11
            call print
            jmp loop12

            _loop11:
            sub cx,5
            inc ax
            jmp loop11

        loop12:
            cmp cx,1
            jae _loop12
            call print
            call end

            _loop12:
            sub cx,1
            inc ax
            jmp loop12

print:
    mov di,string
    call tostring
    mov si,string
    call prints
    xor ax,ax

;biblioteca padrao
putchar:
  mov ah, 0x0e
  int 10h
  ret
  
getchar:
  mov ah, 0x00
  int 16h
  ret
  
delchar:
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret
  
endl:
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret


prints:             ; mov si, string
  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret
  
reverse:              ; mov si, string
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:             ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:             ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret
  
tostring:              ; mov ax, int / mov di, string
  push di
  .loop1:
    cmp ax, 0
    je .endloop1
    xor dx, dx
    mov bx, 10
    div bx            ; ax = 9999 -> ax = 999, dx = 9
    xchg ax, dx       ; swap ax, dx
    add ax, 48        ; 9 + '0' = '9'
    stosb
    xchg ax, dx
    jmp .loop1
  .endloop1:
  pop si
  cmp si, di
  jne .done
  mov al, 48
  stosb
  .done:
  mov al, 0
  stosb
  call reverse
  ret
  
gets:                 ; mov di, string
  xor cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 10        ; string limit checker
    je .loop1
    
    stosb
    inc cl
    call putchar
    
    jmp .loop1
    .backspace:
      cmp cl, 0       ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret
  
stoi:                ; mov si, string
  xor cx, cx
  xor ax, ax
  .for1:
    push ax
    lodsb
    mov cl, al
    cmp cl, ','
    je .virgula

    pop ax
    cmp cl, 0        ; check EOF(NULL)
    je .endloop1

    sub cl, 48       ; '9'-'0' = 9
    mov bx, 10
    mul bx           ; 999*10 = 9990
    add ax, cx       ; 9990+9 = 9999
    jmp .for1

  .virgula:
    pop ax
    jmp .for1

  .endloop1:
  ret

    end:
        jmp $
        times 510 - ($-$$) db 0
        dw 0xaa55