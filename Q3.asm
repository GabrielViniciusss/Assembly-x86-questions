org 0x7c00
jmp 0x0000:main

data:
string: times 100 db 0 ; reservando memoria para string

main:

    xor ax, ax ;inicializaçao padrao
    mov ds, ax
    
    ;bl sera uma variavel auxiliar
    mov bl, 0
    
    ;lendo a string   
    mov di, string       
    call gets
  
    ;printando a string
    mov si, string
    call printstring

    putchar:              ; "Funçao" padrao para printar um caractere na tela dada na monitoria
    mov ah, 0x0e
    int 10h
    ret
   
    getchar:              ; "Funçao" padrao para receber um caractere do teclado dada na monitoria
        mov ah, 0x00
        int 16h
        ret
    
    delchar:
        mov al, 0x08                    
        call putchar

        mov al, ' '       ; "Funçao" padrao para deletar um caractere lido dada na monitoria
        call putchar

        mov al, 0x08                   
        call putchar

        ret
    
    endl:             ; "Funçao" padrao para printar uma quebra de linha dada na monitoria
        mov al, 0x0a                    
        call putchar
        mov al, 0x0d                    
        call putchar

        ret
    
    printstring:                ; "Funçao" padrao para printar uma string armazenada na stack dada na monitoria            

        .loop:

            lodsb                   
            cmp al, 0            ; lodsb carrega um byte da stack (1 caractere no caso) para al

            je .endloop          ; se nao tiver nada, acaba o loop
            call invertCase      ; chamando funçao para mudar de maiscula para minuscula e vice-versa
            
            jmp .loop     

        .endloop:
        ret

    gets:                            ; "funçao" padrao q le a string dada na monitoria
        xor cx, cx                    
        .loop1:
            call getchar             
            cmp al, 0x08             ; 0x08 = backspace   
            je .backspace
            cmp al, 0x0d             ; 0x0d = termino da string
            je .done
            cmp cl, 50               ; limite de caracteres: 50
            je .loop1
        
            stosb                    ; guarda al no endereço SI("coloca" na stack)
            inc cl                   ; indo pegar o prox caractere
            call putchar
        
            jmp .loop1

            .backspace:
                cmp cl, 0           
                je .loop1            ;tratando o ' '
                dec di
                dec cl
                mov byte[di], 0
                call delchar

            jmp .loop1

        .done:
        mov al, 0
        stosb                        ; acabamos a leitura
        call endl
        ret

    invertCase:   
        ;bl ja começa com 0, logo o 1 caractere vai ficar maisculo (Assumindo que o input vai ser sempre lowercase, como está nos casos teste da questao)
        cmp bl, 0
        je uppercase
        jmp lowercase
    
        lowercase:
            cmp al, 32              ;verificar se é ' '
            je space       
            jmp printlowercase
                
        printlowercase:     
                call putchar 
                mov bl, 0       ;muda bl pra 0 para imprimir a prox maiuscula
                ret
        ret
    
        uppercase:
            cmp al, 32              ;verifica se é ' '
            je space
            jmp printuppercase
                
            printuppercase:
                sub al, 32       ; o caractere maisculo vai ser dado por ele - 32 (tabela ascii)
                call putchar
                mov bl, 1       ;muda bl pra 1 para imprimir a prox minuscula
                ret
        ret

        space:                 ;Se for espaço, printa o espaço
            call putchar 
            ret
    
    ret

jmp $
times 510-($-$$) db 0       
dw 0xaa55           
                



