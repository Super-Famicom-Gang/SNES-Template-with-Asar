; Allocate pseudo registers
for i = 0..16
%allocateRAM(0, br!i, 1)
endfor
for i = 0..8
!t #= !i*2
wr!i = r!t
endfor
for i = 0..4
!t #= !i*4
dr!i = r!t
endfor
qr0 = br0
qr1 = br8

; Allocate dma buffer
%allocateRAM($1C0, boundCheck, 0, ==, dmaBuffer, $200)
