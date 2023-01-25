org 0x7c00
jmp 0x0000:start

;alocando imagem na memoria
image db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 3, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 1, 3, 9, 9, 8, 1, 9, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 9, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 8, 8, 9, 15, 15, 15, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 15, 15, 9, 9, 3, 8, 0, 0, 0, 0, 8, 8, 8, 8, 8, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 


 start:
    xor ax, ax  ;zerando registradores importantes que serao usados
	mov cx, ax
	mov dx, ax
    mov ds, ax
    mov es, ax  

    call setVGAmode ; chamando funçao pra setar modo VGA

    mov si,image   ; passando para stack os pixels da imagem formatados

	;obs : cx e dx sao aonde a imagem vai ser printada, sendo sua linha e sua coluna respectivamente

    for1:
  		cmp dx, 16    				; comparando se estou no limite 16x16 para coluna
  		je flag1
  		mov cx, 0

  		for2:
  			cmp cx, 16              ; comparando se estou no limite 16x16 para linha
  			je flag2

			mov ah,0ch              ; setando modo pra printar pixel
			lodsb                   ; carregando 1 byte da string em Si (string da imagem) para al,o qual é o parametro da cor do pixel
			int 10h				

  			inc cx 				   ; indo para prox linha enquanto cx != 16
  			jmp for2
  		flag2:
  		inc dx		                    			
  		jmp for1

  	flag1:
      jmp end

	setVGAmode:
	mov ah, 0 ;setando os parametros para videomode/VGA do int 10h : ah = 0 && al = 13h
	mov al, 13h 
	int 10h
	ret

end:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55