name "BTL"
org  100h 

jmp code                        
  
;macro 
asg MACRO a, b;fast assign
    mov al, b
    mov a, al
ENDM


print MACRO msg, x, y, color, length
    mov bh, 0;Chon man 0
    mov bl, color
    mov cx, length;do dai string
    mov dl, x;toa do x de in
    mov dh, y;toa do y de in 
    mov bp, offset msg;string duoc dung de in
    mov al, 1;Chon che do hien thi co atribute de in mau
    mov ah, 13h;Cac lenh bat buoc cua interrupts INT 10h / AH = 13h    
    int 10h
ENDM 

nhap2so MACRO target 
    mov tmp2, 10
    call mainNhap2so
    asg target, tmp1
ENDM

mainNhap2so proc   
    mov ah, 01h
    int 21h
    sub al, '0'
    mov tmp1, al  
    int 21h
    cmp al, 0x0D 
    je n2soEnd
    sub al, '0'
    mov bl, al
    mov al, tmp1
    mul tmp2
    add al, bl
    mov tmp1, al      
n2soEnd:
    ret
endp   

decider MACRO inp, state, increase, maxVal, minVal  
    asg tmp1, inp
    asg tmp2, state
    asg tmp3, increase
    asg tmp4, maxVal
    asg tmp5, minVal 
    call mainDecider 
    asg inp, tmp1
    asg state, tmp2
ENDM

mainDecider proc
    cmp tmp2, 0
    je c0
    cmp tmp2,1
    je c1  
c0:
    mov al, tmp1
    mov bl, tmp3
    add al, bl
    mov tmp1, al
    cmp al, tmp4
    jge c0stage
    ret
c0stage:
    mov al, tmp1
    mov bl, tmp3
    sub al, bl
    sub al, bl
    mov tmp1, al
    mov tmp2, 1
    ret
c1:
    mov al, tmp1
    mov bl, tmp3
    sub al, bl
    mov tmp1, al
    cmp al, tmp5
    jl c1stage
    ret
c1stage:
    mov al, tmp1
    mov bl, tmp3
    add al, bl   
    add al, bl
    mov tmp1, al
    mov tmp2,0
    ret
    
ENDP   
    
    

;define
toaDox db 1
toaDoy db 1
mau db 1
trangThaix db 1   
trangThaiy db 0  
trangThaiMau db 0
tangX db 1
tangY db 1    
;text map. Gom 5 mang moi mang gom 13 phan tu la ki tu duoc in tren 1 dong      
m1 db 219,219,219,0,219,219,219,0,219,0,219,219,219;Dong dau tien   
m2 db 219,0,219,0,0,219,0,0,219,0,0,219,0 
m3 db 219,219,219,0,0,219,0,0,219,0,0,219,0 
m4 db 219,0,0,0,0,219,0,0,219,0,0,219,0  
m5 db 219,0,0,0,0,219,0,0,219,0,0,219,0
;input msg 
mNhapX db 'Xin moi nhap vi tri xuat phat cua X: '
mNhapY db 'Xin moi nhap vi tri xuat phat cua Y: '
mNhapXTang db 'Xin moi nhap muc tang cua X: '
mNhapYTang db 'Xin moi nhap muc tang cua Y: ' 
;tmp define
tmp1 db 0
tmp2 db 10
tmp3 db 0
tmp4 db 0  
tmp5 db 0            
                                                                                                                                 
;work zone: 80 x 25 x hien thi 255 mau, text mode
code:   mov ah, 00h
        mov al, 03h   
        mov cx, 1
        int 10h  
        call input
        call lUpdate   
        

;All Function
;Clear screen
clrscr proc 
    mov ah, 06h 
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h      
    ret
clrscr endp  

input proc     
    print mNhapX, 0, 0, 7, 37
    nhap2so toaDox 
    print mNhapy, 0, 1, 7, 37
    nhap2so toaDoy   
    print mNhapXTang, 0, 2, 7, 29
    nhap2so tangX
    print mNhapYTang, 0, 3, 7, 29
    nhap2so tangY    
    ret      
endp



            
lUpdate proc ;led update  
    mov mau, 1 ;mau <10  
    ;runmode y; 0=xuong 1=len
    mov trangThaix, 0        
    ;runmode x; 0=phai 1=trai
    mov trangThaiy, 0 
    ;runmode color direction 0= tang 1= giam
    mov trangThaiMau, 0
    jmp mainLoop
       
mainLoop:   
    call clrscr    
    call prFull 
      
    ;thay mau  
    decider mau, trangThaiMau, 1 10, 1
    
    ;di chuyen   
    decider toadox, trangThaix, tangX, 67, 0
    
    decider toadoy, trangThaiy, tangY, 20, 0

    jmp mainLoop 
    

  
lUpdate endp




prFull proc
    asg tmp1, toaDoy;tmp la dong dang duoc in 
    
    print m1, toaDox, tmp1, mau, 13;in dong dau tien
    
    inc tmp1
    print m2, toaDox, tmp1, mau, 13;in dong thu hai
    
    inc tmp1
    print m3, toaDox, tmp1, mau, 13;in dong thu ba
    
    inc tmp1
    print m4, toaDox, tmp1, mau, 13;in dong thu tu
    
    inc tmp1
    print m5, toaDox, tmp1, mau, 13;in dong thu nam
     
    ret
    
prFull endp
    
;Stop process  
stop: ret
 
                  
                  
                  
