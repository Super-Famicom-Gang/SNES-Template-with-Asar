; Additional math functions
function lobyte(x) = x&$FF
function hibyte(x) = lobyte(x>>8)
function exbyte(x) = bank(x)

function loword(x) = x&$FFFF
function hiword(x) = loword(x>>16)

function offs(x) = loword(x)
function page(x) = hibyte(x)

; RAM allocation macros
macro allocateRAM(page, ...)
	pushpc
    if <page> >= $200 || <page> < 0
        error "RAM page <page> is outside the allowed bounds of $000..$1FF."
    endif
	if not(defined("RAM_LOCATION_<page>"))
		!RAM_LOCATION_<page> #= $7E0000+(<page>*$100)
	endif
	org !RAM_LOCATION_<page>
	
    ; Actually put the data
    !__allocateRAM_cnt #= 0
    while !__allocateRAM_cnt < sizeof(...)
		<...[!__allocateRAM_cnt]>: skip <...[!__allocateRAM_cnt+1]>
		!__allocateRAM_cnt #= !__allocateRAM_cnt+2
	endwhile

	!RAM_LOCATION_<page> #= pc()
	if !RAM_LOCATION_<page> >= $7E0000+((<page>+1)*$100)
		warn "Page <page> of RAM is full"
	endif
    if !RAM_LOCATION_<page> >= $7E0000+(((<page>&$100)+$100)*$100)
        error "Page <page> of RAM has crossed the bank boundary into" $hex(!RAM_LOCATION_<page>, 6)
    endif
	pullpc
endmacro

; ROM allocation macros
macro codebank(bank)
    ; First push the old PC
    if defined("CURRENT_BANK")
        !{ROM_LOCATION_!CURRENT_BANK} #= pc()

        if not(!EXROM)
            !{ROM_LOCATION_!CURRENT_BANK} #= !{ROM_LOCATION_!CURRENT_BANK}&$7FFFFF
        endif

        ; THIS CODE IS COMPLETELY UNTESTED!!!
        if not(!LOROM) && !{CURRENT_BANK}&$40 != 0 \
            && offs(!{ROM_LOCATION_!CURRENT_BANK}) > $8000
            ; Check if the ROM's overflowed
            !MIRROR_BANK #= !{CURRENT_BANK}&$BF
            if defined("ROM_LOCATION_!{MIRROR_BANK}")
                error "Bank !{CURRENT_BANK} has overflowed into !{MIRROR_BANK}"
            else
                !{ROM_LOCATION_!MIRROR_BANK} #= pc()
            endif
        endif
    endif

    !CURRENT_BANK #= <bank>

    if <bank> == $7E || <bank> == $7F
        print "======="
        print "Are you tryna write to ROM at the location of RAM?"
        print "That's a very nice attempt but i'll stuff you in a pram"
        print "======="
    endif

    if not(!EXROM)
        !{CURRENT_ROMSPEED} #= (!{CURRENT_BANK}&$80)<<16
        !{CURRENT_BANK} #= !{CURRENT_BANK}&$7F
    endif
    
    ; Has the new bank ever had code?
    if not(defined("ROM_LOCATION_!{CURRENT_BANK}"))
        !{ROM_LOCATION_!CURRENT_BANK} #= (!{CURRENT_BANK}<<16)
        if !CURRENT_BANK&$40 == 0 || !LOROM    ; If bank has ROM mirrors
            !{ROM_LOCATION_!CURRENT_BANK} #= !{ROM_LOCATION_!CURRENT_BANK}|$8000
        endif
    elseif not(!LOROM) && offs(!{ROM_LOCATION_!CURRENT_BANK}) >= $8000
        !{CURRENT_BANK} #= !{CURRENT_BANK}&$BF  ; If HiROM bank overflowed w/ no consequence, un$40 the bank
    endif

    ; Finally, switch
    org !{ROM_LOCATION_!CURRENT_BANK}|!{CURRENT_ROMSPEED}
    bank !{CURRENT_BANK}|bank(!{CURRENT_ROMSPEED})
endmacro