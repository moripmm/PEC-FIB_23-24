.macro $movei p1 imm16
        movi    \p1, lo(\imm16)
        movhi   \p1, hi(\imm16)
.endm


.text
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Inicializacion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       $MOVEI r1, RSG
       wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a las interrupcciones
       movi   r1, 0xF
       out     9, r1      ;activa todos los visores hexadecimales
       movi   r1, 0xFF
       out    10, r1      ;muestra el valor 0xFFFF en los visores
       $MOVEI r6, inici   ;adreça de la rutina principal
       jmp    r6

       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina de servicio de interrupcion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:   movi r7, 0x44
       out    10, r7      ;muestra el numero de la excepcion por los visores hexadecimales
       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici: movi R0,0
       div r1,r1,r0        ;dividimos entre zero para forzar la excepcion de division entre zero 4(0x4)
       bz   r0,inici
       halt
