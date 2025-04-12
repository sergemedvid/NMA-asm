.model small
.stack 100h
.data
.code
main:
    mov ax, @data
    mov ds, ax

    ; Slow loop (waste time)
    mov cx, 4FFFh
outer:
    push cx
    mov cx, 4FFFh
inner:
    loop inner
    pop cx
    loop outer

    ; Exit to DOS
    mov ax, 4C00h
    int 21h
end main
