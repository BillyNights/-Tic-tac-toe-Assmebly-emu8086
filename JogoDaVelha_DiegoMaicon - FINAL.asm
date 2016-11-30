; Tic-tac-toe assmebly
; For emu8086
; Made by Oz Elentok And Diego Maicon
data segment
	grid db 9 dup(0)
	player db 0
	win db 0
	temp db 0
	newGameQuest db "Deseja jogar novamente ? (y - yes, any key - no)$"
	welcome db "Jogo da Velha - By Diego Maicon and Oz Elentok$"
	separator db "---|---|---$"
	enterLoc db "Insira seu movimento por local(1-9)$"
	turnMessageX db "sua vez $ "
	tieMessage db "Um empate entre os dois jogadores!$"
	winMessage db "O jogador que venceu foi jogador $"
	inDigitError db "ERROR!, this place is taken$"
	inError db "ERROR!, input is not a digit$"   
	
	cor1 db "Escolha a cor (1-Verde,2-Azul,3-Rosa,4-Amarelo) = $"
    cor2 db "Escolha a cor (1-Verde,2-Azul,3-Rosa,4-Amarelo) = $" 
	
	nome1 db "Escolha Seu Nome Player 1 = $"  
	nome2 db "Escolha Seu Nome Player 2 = $" 
	
	simbolo1 db "Escolha simbolo $"  
	simbolo2 db "Escolha simbolo $" 
	
	
	; the maximum size of string
    strsize= 32

    ; Armazena nome dos jogadores    
    nick1   db  strsize dup (?)
    nick2   db  strsize dup (?)                              
                               
    endl    db  13, 10 , '$'

	newline db 0Dh,0Ah,'$'   
	
ends
stack segment
	dw 128 dup(0)
ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov es, ax
	
	newGame:
	call initiateGrid
	mov player, 10b; 2dec
	mov win, 0
	mov cx, 9
	gameAgain:
		call clearScreen
	
		
		;------------------------------------  
		                    ;Armazena Flag para pegar os parametros iniciais
	                        MOV al,[1120h]
		                    cmp al, 1h     
                            je continua
			                ; Inicia leitura dos parametros
			                            
			                    lea dx, welcome
		                        call printString 
		                        
		                        lea dx, newline   
		                        call printString   
		                            
			                    lea dx, nome1 
		                        call printString       
		                    
		                        ;chama função para ler nomes
		                        ; call getstr to read a string from keyboard 
		                        push cx   
                                mov  cx, strsize    
                                mov  dx, offset nick1
                                call getstr
                                pop  cx
                            
                                lea dx, newline
	                            call printString
		                    
		                        lea dx, simbolo1 
		                        call printString 
		                     
		                        ; imprime nome 2
                                mov     dx, offset nick1   
                                call printString
                             
		 
	                            MOV AH,1 ;funcao DOS para leitura de caracter
                                INT 21h ;caracter e' lido em AL
                                MOV [1100h],AL ;salvando-o em BL 
                                
                                lea dx, newline
	                            call printString 
	                            
	                            lea dx, cor1 
		                        call printString 
	                              
	                            ;Seleciona a cor de acordo com entrada  
	                            PUSH BX
	                            PUSH AX
	                                MOV BX,1200h
	                            
                                    mov ah, 01
	                                int 21h
	                                
	                                cmp al,31h
	                                je verde 
	                                  
	                                cmp al,32h
	                                je azul
	                                
	                                cmp al,33h
	                                je rosa 
	                                  
	                                cmp al,34h
	                                je amarelo               
	                                                 
	                                                 
	                    azul: 
	                          MOV [BX],01h 
	                          jmp c1
	                    
	                    verde: 
	                          MOV [BX],02h 
	                          jmp c1 
	                          
	                     rosa: 
	                          MOV [BX],0Dh 
	                          jmp c1
	                    
	                    amarelo: 
	                          MOV [BX],0eh 
	                          jmp c1                                 
	                                                 
                            c1:  
                                 POP AX      
	                            POP BX       
	                                         
	                            lea dx, newline                                               
	                            call printString    
	                            lea dx, newline
	                            call printString  
	                                      
	                   ;**********************************************************************
	                            ; Parametros do jogador 2 
	                            lea dx, nome2 
		                        call printString       
		                    
		                    
		                        ; Chama funcao que captura do teclado
		                        push cx    
                                mov  cx, strsize
                                mov     dx, offset nick2
                                call     getstr
	                            pop cx                
	                                            
	                            lea  dx, newline
	                            call printString                
	                                        
	                            lea  dx, simbolo2 
		                        call printString     
		                    
		                         ; imprime o nome 2
                                mov  dx, offset nick2
                                call printString
                            
		 
	                            MOV AH,1 ;funcao DOS para leitura de caracter
                                INT 21h ;caracter e' lido em AL
                                MOV [1102h],AL ;salvando-o em BL 
                                
                                
                                lea dx, newline
	                            call printString 
	                             
	                            lea dx, cor2 
		                        call printString 
		                                        
		                        ;seleciona cor
                                PUSH BX 
                                PUSH AX 
                               
                                MOV BX,1202h
	                            
	                            mov ah, 01
	                            int 21h
	                                          
	                                cmp al,31h
	                                je verde2 
	                                  
	                                cmp al,32h
	                                je azul2  
	                                
	                                cmp al,33h
	                                je rosa2 
	                                  
	                                cmp al,34h
	                                je amarelo2               
	                                                 
	                                                 
	                    azul2: 
	                          MOV [BX],01h 
	                          jmp c2
	                    
	                    verde2: 
	                          MOV [BX],02h 
	                          jmp c2 
	                          
	                          
	                     rosa2: 
	                          MOV [BX],0Dh 
	                          jmp c2
	                    
	                    amarelo2: 
	                          MOV [BX],0Eh 
	                          jmp c2                               
	                                                 
                            c2:                                                
                                    
                                        POP AX      
	                                    POP BX       
	                                   
	     
	                            mov [1120h],1h   
	                                          
		;-----------------------------------    
		
	;continua se os parametros ja estao pegos 	        
	continua:
		    lea dx, newline
	        call printString
		    lea dx, newline
	        call printString
		    lea dx, enterLoc
		    call printString
		    lea dx, newline
		    call printString
		    call printString
		    call printGrid
		    mov al, player
		    cmp al, 1  
		
		
		
	  je p2turn
			; Jogador anterior era 2
			                shr player, 1; 0010b --> 0001b; 
			                lea dx, newline
	                        call printString
			
			                ; print the read string
                            mov dx, offset nick1
                            call printString  
                            lea dx, turnMessageX 
			                call printString  
			                lea dx, newline 
			                call printString
			                jmp endPlayerSwitch
		p2turn:; Jogador anterior foi 1
			                shl player, 1; 0001b --> 0010b  
			                lea dx, newline
	                        call printString
                 		   ; print the read string
                            mov dx, offset nick2
                            call printString 
                            lea dx, turnMessageX
			                call printString  
			                lea dx, newline
			                call printString
			
		endPlayerSwitch:
		call getMove; Bx apontara para o postiton direito da placa no final de getMove
		mov dl, player
		cmp dl, 1
		jne p2move
		      mov dl, [1100h] ;simbolo escolhido
		jmp contMoves                   
		
		p2move:
		      mov dl, [1102h]  ;simbolo escolhido
		contMoves:
		mov [bx], dl
		cmp cx, 5 ; Sem necessidade de verificar antes do 5 turno
		jg noWinCheck
		call checkWin
		cmp win, 1
		je won
		noWinCheck:
		loop gameAgain
		
	;Tie, cx = 0 neste ponto e nenhum jogador ganhou
	 call clearScreen
	 lea dx, welcome
	 call printString
	 lea dx, newline
	 call printString
	 call printString
	 call printString
	 call printGrid
	 lea dx, tieMessage
	 call printString
	 lea dx, newline
	 call printString
	 jmp askForNewGame
	 
	won:; Jogador atual ganhou
	 call clearScreen
	 lea dx, welcome
	 call printString
	 lea dx, newline
	 call printString
	 call printString
	 call printString
	 call printGrid
	 lea dx, winMessage
	 call printString   
	 mov dl, player
	 cmp dl, 1      
	    ;imprime nome do campeao
	    je camp1  
	             push dx
	             mov  dx, offset nick2
                 call printString   
                 pop dx
                 jmp fim
	    
	    camp1: 
	           push dx
	           mov  dx, offset nick1
               call printString  
               pop dx
	           jmp fim  
	 
	 fim:lea dx, newline
	     call printString
	 
	askForNewGame:
	 lea dx, newGameQuest; Pedir outro jogo
	 call printString
	 lea dx, newline
	 call printString
	 call getChar
	 cmp al, 'y'; Reproduzir novamente se 'y' for pressionado;
	 jne sof
	 jmp newGame
	 
	sof:
	mov ax, 4c00h
	int 21h
	
;-------------------------------------------;
; Conjuntos ah = 01
; Char de entrada em al;
getChar:
	mov ah, 01
	int 21h
	ret            
	
  	
;-------------------------------------------;	
; Conjuntos ah = 02
; Saida char de dl
; Define ah para ultima saida de char
putChar:  
	mov ah, 02h
	int 21h
	ret       
	
	;colore o local onde vai ser impresso o numero no grid 
	;de acordo com quem esta jogando
	putCharColor: 
	         
	    mov al, player
		cmp al, 1 
		             
		je color1    
	       	 push ax
	         push bx    
	         push cx
		    
             mov bh, 0
             mov cx, 0001h 
             mov bl, [1200h]	;
             mov ah, 9h
             int 10h   
              
             pop cx
             pop bx
             pop ax
             ret
	    color1:     
	    
	         push ax
	         push bx    
	         push cx
	       
	         mov bh, 0
             mov cx, 0001h 
             mov bl, [1202h]	;
             mov ah, 9h
             int 10h
             
             pop cx
             pop bx
             pop ax
             ret
     
    
	
;-------------------------------------------;
; Conjuntos ah = 09
; Cadeia de saida de dx
; Conjuntos al = 24h
printString:
	mov ah, 09
	int 21h
	ret
;-------------------------------------------;
; Limpa a tela
; Ah = 0 no final
clearScreen:
	mov ah, 0fh
	int 10h
	mov ah, 6
	int 10h
	ret
	
;-------------------------------------------;
; Obtem o local que pode ser usado
; Depois de conseguir sucesso a localizacao:
; Al - mantera o numero do local (0 - 8)
; Bx - mantera a posicao (bx [al])

getMove:
	call getChar; al = getchar()
	call isValidDigit
	cmp ah, 1
	je contCheckTaken
	mov dl, 0dh
	call putChar
	lea dx, inError
	call printString
	lea dx, newline
	call printString
	jmp getMove
	
	contCheckTaken: ; Checks this: if(grid[al] > '9'), grid[al] == 'O' or 'X'
	lea bx, grid	
	sub al, '1'
	mov ah, 0
	add bx, ax
	mov al, [bx]
	cmp al, '9'
	jng finishGetMove
	mov dl, 0dh
	call putChar
	lea dx, inDigitError
	call printString
	lea dx, newline
	call printString
	jmp getMove
	finishGetMove:
	lea dx, newline
	call printString
	ret
	
;-------------------------------------------;
; Inicia a grade de '1' para '9'
; Usos bx, al, cx
initiateGrid:
	lea bx, grid
	mov al, '1'
	mov cx, 9
	initNextTa:
	mov [bx], al
	inc al
	inc bx
	loop initNextTa
	ret
	
;-------------------------------------------;
; Verifica se um caractere em al e um digito
; NAO inclui '0'
; Se for Digito, ah = 1, senao ah = 0
isValidDigit:
	mov ah, 0
	cmp al, '1'
	jl sofIsDigit
	cmp al, '9'
	jg sofIsDigit
	mov ah, 1
	sofIsDigit:
	ret
	
	         
	         
;-------------------------------------------;	
; Produz a grade 3x3
; Usa bx, dl, dx
printGrid:
	lea bx, grid
	call printRow
	lea dx, separator
	call printString
	lea dx, newline
	call printString
	call printRow
	lea dx, separator
	call printString
	lea dx, newline
	call printString
	call printRow
	ret

;-------------------------------------------;
; Emite uma unica linha da grade
; Utiliza bx como o primeiro numero na linha
; No fim:
; Dl = terceira celula na linha
; Bx + = 3, para a linha seguinte
; Dx aponta para nova linha
printRow:

	;First Cell
	mov dl, ' '
	call putChar
	mov dl, [bx]
	call putCharColor
	call putChar
	mov dl, ' '
	call putChar
	mov dl, '|'
	call putChar
	inc bx
	
	;Second Cell
	mov dl, ' '
	call putChar
	mov dl, [bx]
	call putCharColor
	call putChar
	mov dl, ' '
	call putChar
	mov dl, '|'
	call putChar
	inc bx
	
	;Third Cell
	mov dl, ' '
	call putChar
	mov dl, [bx]
	call putCharColor
	call putChar
	inc bx
	
	lea dx, newline
	call printString
	ret
	
;-------------------------------------------;	
; Returns 1 in al if a player won
; 1 for win, 0 for no win
; Changes bx
checkWin:
	lea si, grid
	call checkDiagonal
	cmp win, 1
	je endCheckWin
	call checkRows
	cmp win, 1
	je endCheckWin
	call CheckColumns
	endCheckWin:
	ret
	
;-------------------------------------------;	
checkDiagonal:
	;DiagonalLtR
	mov bx, si
	mov al, [bx]
	add bx, 4	;grid[0] ---> grid[4]
	cmp al, [bx]
	jne diagonalRtL
	add bx, 4	;grid[4] ---> grid[8]
	cmp al, [bx]
	jne diagonalRtL
	mov win, 1
	ret
	
	diagonalRtL:
	mov bx, si
	add bx, 2	;grid[0] ---> grid[2]
	mov al, [bx]
	add bx, 2	;grid[2] ---> grid[4]
	cmp al, [bx]
	jne endCheckDiagonal
	add bx, 2	;grid[4] ---> grid[6]
	cmp al, [bx]
	jne endCheckDiagonal
	mov win, 1
	endCheckDiagonal:
	ret
	
;-------------------------------------------;
checkRows:	
	;firstRow
	mov bx, si; --->grid[0]
	mov al, [bx]
	inc bx		;grid[0] ---> grid[1]
	cmp al, [bx]
	jne secondRow
	inc bx		;grid[1] ---> grid[2]
	cmp al, [bx]
	jne secondRow
	mov win, 1
	ret
	
	secondRow:
	mov bx, si; --->grid[0]
	add bx, 3	;grid[0] ---> grid[3]
	mov al, [bx]
	inc bx	;grid[3] ---> grid[4]
	cmp al, [bx]
	jne thirdRow
	inc bx	;grid[4] ---> grid[5]
	cmp al, [bx]
	jne thirdRow
	mov win, 1
	ret
	
	thirdRow:
	mov bx, si; --->grid[0]
	add bx, 6;grid[0] ---> grid[6]
	mov al, [bx]
	inc bx	;grid[6] ---> grid[7]
	cmp al, [bx]
	jne endCheckRows
	inc bx	;grid[7] ---> grid[8]
	cmp al, [bx]
	jne endCheckRows
	mov win, 1
	endCheckRows:
	ret
	
;-------------------------------------------;	
CheckColumns:
	;firstColumn
	mov bx, si; --->grid[0]
	mov al, [bx]
	add bx, 3	;grid[0] ---> grid[3]
	cmp al, [bx]
	jne secondColumn
	add bx, 3	;grid[3] ---> grid[6]
	cmp al, [bx]
	jne secondColumn
	mov win, 1
	ret
	
	secondColumn:
	mov bx, si; --->grid[0]
	inc bx	;grid[0] ---> grid[1]
	mov al, [bx]
	add bx, 3	;grid[1] ---> grid[4]
	cmp al, [bx]
	jne thirdColumn
	add bx, 3	;grid[4] ---> grid[7]
	cmp al, [bx]
	jne thirdColumn
	mov win, 1
	ret
	
	thirdColumn:
	mov bx, si; --->grid[0]
	add bx, 2	;grid[0] ---> grid[2]
	mov al, [bx]
	add bx, 3	;grid[2] ---> grid[5]
	cmp al, [bx]
	jne endCheckColumns
	add bx, 3	;grid[5] ---> grid[8]
	cmp al, [bx]
	jne endCheckColumns
	mov win, 1
	endCheckColumns:
	ret
	
;funcao de capitura do nome	
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			                          
; getstr reads a string from keyboard. The size of buffer
; (the maximum character to read) is in CX register.
; The buffer must have 3 more rooms to save the 
; return/new-line/$ sequence.
; The input string may not contain a $ character because
; that would force the MS-DOS I/O to terminate the printing.
; (Just test it!)
; DX contains the address of buffer in memory
; In return, CX would have the number of bytes actually read.

getstr      proc

            ; preserve used register
            push    ax
            push    bx
            push    si

            ; si used as base address
            mov     si, dx

            ; bx used as index to the base address
            mov     bx, 0

; It is a bit funny because I used BX as index and 
; si as base address (Names si: source index, 
; bx: base register), but it doesn't really matter.
; It just reduces the readability of the code 
; slightly             

            ; It is a loop                      
L11:        
            ; read next character
            mov     ah, 1
            int     21h

            ; Check if it is not return 
            ; (indicating the end of line)                                 
            cmp     al, 13 ; return character
            jz      L12

            ; save the read character in buffer.
            mov     [si][bx], al

            ; next index of buffer
            inc     bx

L12:
            ; loop until count-down is zero and not 
            ; matched return character            
            loopnz  L11

            ; bx contains the length of string.
            ; save it in cx                          
            mov     cx, bx

            ; append a sequence of return, 
            inc     bx
            mov     [si][bx], 13                                                                  

            ; new-line and                               
            inc     bx
            mov     [si][bx], 10                                                                  

            ; '$' character to the string          
            inc     bx
            mov     [si][bx], '$'                                                                  

            ; recover used register          
            pop     si
            pop     bx
            pop     ax
            ret
getstr      endp			                          
			                          
			                           
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	                
      		          	
	
ends
end start
