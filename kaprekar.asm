DATA SEGMENT PARA PUBLIC 'DATA'
   
    INPUT_MSG DB "Starting from: $"
    WRONG_INPT_MSG DB "Wrong input, try again: $"
    ITERATIONS_MSG DB "Iterations: $"
    NUMBER DB 6, ?, 6 DUP(0)  ; Allow space for 4 digits and a null terminator
    ADR_NUM DW NUMBER  ; Address of the buffer
    NUMBER2 DB 6, ?, 6 DUP(0)  ; Allow space for 4 digits and a null terminator
    ADR_NUM2 DW NUMBER2  ; Address of the buffer
    OK DB 0
    IS_OK DB 0
    IS_KAP DB 0
    ITERATIONS DB 1

DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODE, DS:DATA

    SORT_ASC PROC NEAR

    MOV BP,SP
    MOV SI, [BP+2]

    XOR CX,CX
    MOV CL,[SI+1]
    MOV BH,[SI+1]
    ADD SI,2

    lb1:     
        PUSH CX
        MOV CL,BH
        MOV DI,[BP+2]
        ADD DI,2
        lb2:
        MOV AH,[DI]
        MOV AL,[SI]
        CMP AH,AL
        JA dont
            
            MOV [SI],AH
            MOV [DI],AL
        dont:
        INC DI
        LOOP LB2
        POP CX
        INC SI
    LOOP lb1
RET
SORT_ASC ENDP

SORT_DESC PROC NEAR

    MOV BP,SP
    MOV SI, [BP+2]

    XOR CX,CX
    MOV CL,[SI+1]
    MOV BH,[SI+1]
    ADD SI,2

    lbb1:     
        PUSH CX
        MOV CL,BH
        MOV DI,[BP+2]
        ADD DI,2
        lbb2:
        MOV AH,[DI]
        MOV AL,[SI]
        CMP AH,AL
        JB doont
            
            MOV [SI],AH
            MOV [DI],AL
        doont:
        INC DI
        LOOP LBB2
        POP CX
        INC SI
    LOOP lbB1
RET
SORT_DESC ENDP
    ; Macro to read input
    READS MACRO X
        PUSH DX
        PUSH AX

        MOV DX, X
        MOV AH, 0AH
        INT 21H

        POP AX
        POP DX
    ENDM

    ; Macro to print message
    PRINTS MACRO X
    local print_loop,end_print
        PUSH DX
        PUSH AX
        PUSH SI
        MOV SI, X
        INC SI

        XOR AX, AX

        MOV AL, [SI]
        MOV AL, 4
        ADD SI, AX
        INC SI
    
        MOV BYTE PTR [SI], '$'

        MOV SI, X
        ADD SI, 2
        MOV DX, SI

        PRINT_LOOP: 
        MOV AH, 02H
        MOV DL, [SI]      ; Move character to DL for printing
        INT 21H           ; Print character
        INC SI            ; Move to the next character
        CMP BYTE PTR [SI], '$'  ; Check for end of string marker
        JE END_PRINT      ; If end of string, jump to end
        JMP PRINT_LOOP    ; Repeat until end of string
    END_PRINT:
        POP SI
        POP AX
        POP DX
    ENDM

    ; Macro to validate input
    VALIDATE MACRO X, OK
        PUSH DX
        PUSH AX
        PUSH SI
        PUSH BX

        MOV SI, X
        INC SI
        
        XOR AX, AX
        MOV AL, [SI]
        MOV AL, 4
        ADD SI, AX
        INC SI
        
        MOV BYTE PTR [SI], '$'
        
        MOV SI, X
        ADD SI, 2
        MOV DX, SI

        PRINT_LOOOP: 
        MOV DL, [SI]      ; Move character to DL for printing
        CMP DL, '0'
        JB INVALID_INPUT
        CMP DL, '9'       ; Compare with '9'
        JA INVALID_INPUT
        INC SI            ; Move to the next character
        CMP BYTE PTR [SI], '$'  ; Check for end of string marker
        JE VALID_INPUT      ; If end of string, jump to end
        JMP PRINT_LOOOP    ; Repeat until end of string

        INVALID_INPUT:
        MOV AH, 09h
        LEA DX, WRONG_INPT_MSG
        INT 21h
        MOV OK, 0
        JMP END_VALIDATE

        VALID_INPUT:
        MOV OK, 1

        END_VALIDATE:
        POP BX
        POP SI
        POP AX
        POP DX
    ENDM

    ; Macro to print a new line
    NEW_LINE MACRO
        push DX
        push AX
        MOV DL, 10
        MOV AH, 02H
        INT 21h
        MOV DL, 13
        MOV DH, 02H
        INT 21H
        pop AX
        pop DX
    ENDM
MINUS MACRO
        push DX
        push AX
        MOV DL, '-'
        MOV AH, 02H
        INT 21h
        pop AX
        pop DX
    ENDM
EQUAL MACRO
        push DX
        push AX
        MOV DL, '='
        MOV AH, 02H
        INT 21h
        pop AX
        pop DX
    ENDM
ITERATOONS_MSG_MARCO MACRO
        push DX
        push AX
        MOV AH, 09h
        LEA DX, ITERATIONS_MSG
        INT 21h
        pop AX
        pop DX
    ENDM

 EQUAL_DIGI MACRO X, IS_OK
        PUSH DX
        PUSH AX
        PUSH SI
        PUSH BX

        XOR AX,aX
        XOR SI,SI
        XOR DX,DX
        XOR BX, BX         ; Clear BX register
        MOV BL, '1'        ; Set BX to '1' assuming digits are equal
        MOV SI, X 
        ADD SI, 2           ; Point SI to the address of the buffer
        MOV AH, [SI]
        INC SI             ; Move to the second digit

        XOR CX, CX         ; Clear CX register for iteration
        MOV CX, 3
        CMP_LOOP:
            CMP AH, [SI]   ; Compare the first digit with the current digit
            JE EQUAL_LABEL       ; If not equal, set BX to '0' and exit loop
            MOV BL, '0'
        EQUAL_LABEL:
            INC SI         ; Move to the next digit
        LOOP CMP_LOOP     ; If loop completes, all digits are equal
        
        MOV IS_OK, BL     ; Store the result in IS_OK

        POP BX
        POP SI
        POP AX
        POP DX
ENDM


    ; Macro to check if input matches Kaprekar constant
IS_KAP_CT MACRO X, IS_KAP
        PUSH DX
        PUSH AX
        PUSH SI
        PUSH BX
         XOR AX,aX
        XOR SI,SI
        XOR DX,DX
        XOR BX, BX          ; Clear BX register
        MOV BL, '0'         ; Set BX to '0' assuming digits are not equal
        MOV SI, X 
        ADD SI, 2           ; Point SI to the address of the buffer
        MOV AH, [SI]        ; Load the first digit into AH
        CMP AH, '6'         ; Compare first digit with '6'
        JNE NOT_EQ          ; If not equal, jump to NOT_EQ
        INC SI              ; Move to the second digit
        MOV AH, [SI]        ; Load the second digit into AH
        CMP AH, '1'         ; Compare second digit with '1'
        JNE NOT_EQ          ; If not equal, jump to NOT_EQ
        INC SI              ; Move to the third digit
        MOV AH, [SI]        ; Load the third digit into AH
        CMP AH, '7'         ; Compare third digit with '7'
        JNE NOT_EQ          ; If not equal, jump to NOT_EQ
        INC SI              ; Move to the fourth digit
        MOV AH, [SI]        ; Load the fourth digit into AH
        CMP AH, '4'         ; Compare fourth digit with '4'
        JNE NOT_EQ          ; If not equal, jump to NOT_EQ

        MOV BL, '1'         ; If all digits match, set BL to '1'
        MOV IS_KAP, BL       ; Store the result in IS_KAP
        POP BX
        POP SI
        POP AX
        POP DX
        JMP END_IS_KAP
    NOT_EQ:
        MOV BL, '0'         ; If digits don't match, set BL to '0'
        MOV IS_KAP, BL       ; Store the result in IS_KAP
        POP BX
        POP SI
        POP AX
        POP DX
        END_IS_KAP:
ENDM

COPY_NUM MACRO X,Y

    PUSH DX
    PUSH AX
    PUSH SI
    PUSH BX

    MOV SI,X
    MOV DI,Y
    MOV CX,6

    COPY_LOOP:

    MOV AX,[SI]
   ; MOV BX,[SI]
    MOV [DI],AX
   ; MOV [SI],BX
    INC SI
    INC DI
    LOOP COPY_LOOP



    POP BX
    POP SI
    POP AX
    POP DX

ENDM

SUBTRACTION MACRO X, Y
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    MOV SI, X          ; Point SI to the first number
    MOV DI, Y          ; Point DI to the second number
    ADD SI, 6          ; Skip over any potential length information
    ADD DI, 6          ; Skip over any potential length information
    MOV CX, 4          ; Set CX to 4, indicating four digits to subtract

    SUBSTRACTION_LOOP:
        DEC SI           ; Move to the next digit of the first number
        DEC DI           ; Move to the next digit of the second number
        MOV DX, 0        ; Clear DX (carry flag) for each iteration
        MOV AL, [SI]     ; Load a digit from the first number
        SUB AL, '0'      ; Convert ASCII digit to numeric value
        MOV BL, [DI]     ; Load a digit from the second number
        SUB BL, '0'      ; Convert ASCII digit to numeric value
        CMP AL, BL       ; Compare the digits
        JAE NO_BORROW    ; Jump if no borrow (result is positive or zero)
        ADD AL, 10       ; Add 10 (borrow) to the first digit
        INC DX           ; Set the carry flag to indicate borrowing
    NO_BORROW:
        SUB AL, BL       ; Subtract the digits
        ADD AL, '0'      ; Convert numeric result back to ASCII
        MOV [SI], AL     ; Store the result back to memory
        CMP DX, 0        ; Check if there was a borrow
        JZ NO_CORRECTION ; If no borrow, skip correction
        DEC SI           ; Move back to the previous digit
        SUB BYTE PTR [SI], 1  ; Subtract 1 from the previous digit
        INC SI           ; Move back to the current digit
    NO_CORRECTION:
        LOOP SUBSTRACTION_LOOP  ; Repeat for all four digits

    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
ENDM





START PROC FAR
    ; Initialization
    PUSH DS
    XOR AX, AX
    MOV DS, AX
    PUSH AX
    MOV AX, DATA
    MOV DS, AX

    ; Print input message
    MOV AH, 09h
    LEA DX, INPUT_MSG
    INT 21h

READING:
    ; Read input
    READS ADR_NUM
    NEW_LINE

    ; Check if the input is valid
    VALIDATE ADR_NUM, OK
    CMP OK, 0
    JE READING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;READING
ITERATE:
    NEW_LINE
    PUSH ADR_NUM    
    CALL SORT_ASC
    POP ADR_NUM
    PRINTS ADR_NUM
    COPY_NUM ADR_NUM, ADR_NUM2

    ; Print a minus sign for clarity
    MINUS

    ; Call the sort procedure for descending order for the second number
    PUSH ADR_NUM2
    CALL SORT_DESC
    POP ADR_NUM2
    PRINTS ADR_NUM2

    ; Print an equal sign for clarity
    EQUAL

    ; Subtract the sorted descending number from the sorted ascending number
    SUBTRACTION ADR_NUM, ADR_NUM2

    ; Print the result
    PRINTS ADR_NUM
    NEW_LINE

    XOR CX, CX
    IS_KAP_CT ADR_NUM, IS_KAP
    MOV CL, IS_KAP
    CMP CL, '0'
    JE CONTINUE

    JMP END_ITERATION

CONTINUE:
    XOR CX, CX
    EQUAL_DIGI ADR_NUM, IS_OK
    MOV CL, IS_OK
    CMP CL, '0'
    JE CONTINUE_NEXT

    JMP END_ITERATION

CONTINUE_NEXT:
    MOV BL,ITERATIONS
    INC BL
    MOV ITERATIONS,BL
    JMP ITERATE     ; Continue iterating

END_ITERATION:
    ITERATOONS_MSG_MARCO
    MOV DL, ITERATIONS      ; Print the iteration count
    ADD DL,'0'
    MOV AH, 02H
    INT 21H
    RET
START ENDP

CODE ENDS
END START