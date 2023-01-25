org 0x7c00
jmp 0x0000: main

string times 51 db 0    ;reservando espaço na memoria 
N times 9 db 0

main:

xor ax, ax ;inicializaçao padrao
mov ds, ax

call setVideoMode 

mov bl, 15 ;parametro

mov di, N ;di= destino, N vai ficar sendo "Armazenado" em di
call gets ;lemos o numero em formato de string

mov si, N ;faz ponteiro da stack apontar para number[0]
call stoi ;passamos essa string pra inteiro (N é lido como string)

mov bl, 15 ;resetando parametro
call stringVerify

.done:
    jmp $

setVideoMode: ;setando modo de video
	mov ah, 0
	mov al, 12h
	int 10h
	ret

;Biblioteca padrao de funçoes dada na monitoria
getchar: 
mov ah, 0
int 16h
ret

putchar: 
	mov ah, 0xe
	int 10h
	ret

delchar: 
	mov al, 8
	call putchar
	mov al, ' '
	call putchar
	mov al, 8
	call putchar
	ret

endl: 
	mov al, 0x0a
	call putchar
	mov al, 0x0d
	call putchar
	ret

gets: 
  	xor cx, cx 
	.loop1:
		call getchar 
		cmp al, 0x08 
		je .backspace
		cmp al, 0x0d
		je .done
		cmp cl, 50
		je .loop1

		stosb
		inc cl
		call putchar

		jmp .loop1
		.backspace: 
			cmp cl, 0
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

stoi:
	xor cx, cx
	xor ax, ax

	.loop1:
		push ax
		lodsb
		mov cl, al
		pop ax
		cmp cl, 0
		je .endloop1

		sub cl, 48
		mov bx, 10
		mul bx
		add ax, cx
		jmp .loop1

	.endloop1:
		ret
    ; Fim da biblioteca padrao

stringVerify: ;função para ler e verificar a string
	push ax
	.loop1:
		pop ax
		cmp al, 0
		je .done

		dec ax
		push ax
		xor ax, ax

		mov di, string  ; string vai ser "armazenada" em di
		call gets       ; lendo a string

		mov edx, 0     
		mov si, string  ; passando string pra pilha(fazendo stack pointer apontar pra ela)
		call checkString

		mov al, 'S'

		cmp edx, 0      ; edx é meio que uma flag, se for 0 printamos 'S' se nao for printamos 'N'
		je .print

		mov al, 'N'

	.print:             ;printa oq está em al
		call putchar
		call endl
		jmp .loop1

	.done:
		ret

checkString: ; verifica se para cada caractere aberto, há um correspondente fechando

	mov di, si ; para comparar strings, precisamos fazer isso
	xor cx, cx

	.loop1:
		lodsb      ; carregando um byte da string q ta na pilha para al
		cmp al, 0  ; verificando se é endstring
		je .done

		cmp al, '{' ;se for caractere de abrir, adiciona na pilha
		je .stackPush
		cmp al, '['
		je .stackPush
		cmp al, '('
		je .stackPush

		cmp al, '}' ;se for caractere de fechar, compara com o topo da pilha e ve se é seu correspondente
		je .valid1
		cmp al, ']'
		je .valid2
		cmp al, ')'
		je .valid3

        ; dessa forma ele vai adicionando na pilha sequencialmente e comparando os que abriram primeiro x os que fecharam primeiro

		jmp .failed ; se chegar aqui, a string é invalida

	.stackPush: ;adiciona na pilha
		inc cl    ;cl é a quantidade de elementos que tao na pilha(caracteres que abrem)
		push ax
		jmp .loop1

	.valid1:
		cmp cl, 0 ; se cl for 0 , a pilha está vazia, logo n tem ninguem abrindo para esse caractere
		je .failed
		pop dx      
		dec cl         ;decrementamos cl, e fazemos o novo topo ser oq estava embaixo do atual topo
		cmp dl, '{'
		je .remove  ; se for equal, tiramos esse caractere da pilha
		jmp .failed ; senao a string ja é invalida e podemos printar 'N'

	.valid2:
		cmp cl, 0 ; se cl for 0 , a pilha está vazia, logo n tem ninguem abrindo para esse caractere
		je .failed 
		pop dx     
		dec cl         ;decrementamos cl, e fazemos o novo topo ser oq estava embaixo do atual topo
		cmp dl, '['
		je .remove
		jmp .failed

	.valid3:
		cmp cl, 0  ; se cl for 0 , a pilha está vazia, logo n tem ninguem abrindo para esse caractere
		je .failed
		pop dx     ;decrementamos cl, e fazemos o novo topo ser oq estava embaixo do atual topo
		dec cl
		cmp dl, '('
		je .remove
		jmp .failed

	.remove: ;encontrando seu par, removemos o caractere da pilha
		mov edx, 0 ;setando flag para 0 (Sim é valida)
		jmp .loop1

	.failed: ;se nao for o par, a string ja nao é mais valida
		mov edx, 1 ;setando flag para 1 (Nao é valida)
		jmp .done

	.done:
		cmp cl, 0
		je .exit ; n ha ninguem na pilha

		pop dx  ; se tiver alguem, tiramos e saimos da funçao
		dec cl

		jmp .done

	.exit:
		ret

times 510-($-$$) db 0
dw 0xaa55
