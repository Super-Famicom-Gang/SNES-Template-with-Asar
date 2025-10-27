; Allocate pseudo registers
for i = 0..8
%allocateRAM(0, r!i, 2)
r!{i}_lo = r!i
r!{i}_hi = r!{i}+1
endfor
for i = 0..4
!t #= !i*2
dr!i = r!t
endfor
qr0 = r0
qr1 = r4

; Allocate dma buffer
%allocateRAM($1C0, boundCheck, 0, ==, dmaBuffer, $200)
