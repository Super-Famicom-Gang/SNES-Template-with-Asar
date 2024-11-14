; General macros
macro exec(cmd)
    <cmd>
endmacro

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

macro var(name, size)
	<name>: skip <size>
endmacro

macro byte(name)
	<name>: skip 1
endmacro

macro word(name)
	<name>: skip 2
endmacro

macro ptr(name)
	<name>: skip 3
endmacro

macro long(name)
	<name>: skip 4
endmacro

; ROM allocation macros
macro codebank(bank)
    ; First push the old PC
    if defined("CURRENT_BANK")
        !{ROM_LOCATION_!CURRENT_BANK} #= pc()
    endif

    !CURRENT_BANK #= <bank>
    
    ; Has the new bank ever had code?
    if not(defined("ROM_LOCATION_<bank>"))
        !ROM_LOCATION_<bank> #= (<bank><<16)
        if <bank>&$40 == 0 || !LOROM > 0    ; If bank has ROM mirrors
            !ROM_LOCATION_<bank> #= !ROM_LOCATION_<bank>|$8000
        endif
    endif

    ; Finally, switch
    org !ROM_LOCATION_<bank>
    bank <bank>
endmacro