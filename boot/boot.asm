org 0x7c00 ;org 设置起始地址
BaseOfStack equ 0x7c00 ;equ=赋值
;======== 初始化 ax,ds,es,ss,sp
Label_Start:
mov ax,cs
mov ds,ax
mov es,ax
mov ss,ax
mov sp,BaseOfStack
;================= 调用bios终端服务程序INT 10h(控制屏幕)
;======== clear screen
mov ax,0600h                ;按指定范围滚动窗口（ah=06h)(ah=ax的高8位,al=ax的低8位)  al=滚动的列数，等0等于清屏，且bx,cx,dx寄存器参数不起作用
mov bx,0700h                ;设置颜色等属性(bh)（bit 0-2 字体颜色; bit 3 字体亮度; bit 4-6 背景颜色 ; bit 7 字体闪烁）
mov cx,0                    ;左上角行列标号（ch=行，cl=列）CH=高行数，CL=左列数，DH=低行数，DL=右列数
mov dx,0184fh               ;右下角行列标号（dh=行，dl=列）
int 10h
;======== set focus
mov ax,0200h                ;设置屏幕光标位置(ah=02h)
mov bx,0000h                ;bh=页码
mov dx,0000h                ;dh=光标所在的行数，dl=光标所在的列数
int 10h
;======== dispaly on screen:Start Booting...
mov ax,1301h                ;显示字符串(ah=13h) 设置写入模式(al)(00h字符串属性由bl提供,长度由cx提供; 01h同00h但光标移至尾部; 02h 字符串属性由每个字符后面紧跟的字节提供，故CX寄存器提供的字符串长度改成以Word为单位
mov bx,000fh                ;bh=页码 bl=字体属性,同06h
mov dx,0000h                ;dh=光标所在的行数，dl=光标所在的列数
mov cx,10                   ;cx=字符串长度
push ax
mov ax,ds
mov es,ax           
pop ax
mov bp,StartBootMessage     ;bp显示字符串的地址
int 10h
;=================== 调用bios终端服务程序INT 13h(控制磁盘)
;======== reset floppy
xor ah,ah
xor dl,dl                   ;dl=驱动器号(软盘：00h-7fh; 硬盘：80h-0ffh) (00h 第一个软盘驱动器;80h 第一个硬盘驱动器 )
int 13h                     ;复位ah=00
jmp $

StartBootMessage: db "Start boot" ;db=定义字节变量；dw=定义字变量（一个字两个字节）；dd=定义双字变量
;======== fill zero until whole sector
times 510-($-$$) db 0       ;times=重复定义数据或指令 $=当前行的起始地址 $$=section的起始地址
dw 0xaa55                   ;

label_file_loaded:
jmp BaseOfLoader:OffsetOfLoader ;段外跳转（指定目标的和偏移量）

