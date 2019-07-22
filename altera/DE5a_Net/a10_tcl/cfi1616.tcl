#
# author : Alexandr Kozlinskiy
# date : 2017-11-08
#

namespace eval ::cfi1616 {
    set SR_DWS         0x00800080

    set CMD_READ_ARRAY 0x00FF00FF
    set CMD_PGM_BUF    0x00E800E8
    set CMD_CONFIRM    0x00D000D0
    set CMD_CFI_READ   0x00980098
    set CMD_ID_READ    0x00900090
    set CMD_SR_READ    0x00700070
    set CMD_LOCK_SETUP 0x00600060
    set CMD_SR_CLEAR   0x00500050
    set CMD_PGM_WORD   0x00400040
    set CMD_ERASE      0x00200020

    set ADDR_MASK_BLK  0xEFFC0000
    set ADDR_MASK_BUF  0xEFFFF800
}

proc ::cfi1616::read_array { mm } {
    master_write_32 $mm [ expr { 4 * 0x55 } ] $::cfi1616::CMD_READ_ARRAY
}

proc ::cfi1616::get_lock_conf { mm $addr } {
    master_write_32 $mm $addr $::cfi1616::CMD_ID_READ
    return [ master_read_32 $mm [ expr { $addr + 4 * 2 } ] 1 ]
}

proc ::cfi1616::check_wsm { mm addr } {
    set sr [ master_read_32 $mm $addr 1 ]
    if { [ expr { $sr & $::cfi1616::SR_DWS } ] != $::cfi1616::SR_DWS } { return [ set err -16 ] }

    set err 0
    if { $sr == $::cfi1616::SR_DWS } { return $err }

    master_write_32 $mm [ expr { 4 * 0x55 } ] $::cfi1616::CMD_SR_READ
    set sr [ master_read_32 $mm $addr 1 ]
    master_write_32 $mm [ expr { 4 * 0x55 } ] $::cfi1616::CMD_SR_CLEAR

    set err [ expr { ($sr | ($sr >> 16)) & 0x7F } ]
    if { $err } {
        error "error: [ format 0x%02X $err ]"
    }

    return $err
}

proc ::cfi1616::sync { mm addr { ms 10 } } {
    while { true } {
        set err [ check_wsm $mm $addr ]
        if { $err != -16 } break
        after $ms
    }
    read_array $mm
    return $err
}

proc ::cfi1616::lock { mm addr } {
    if { $addr & ~$::cfi1616::ADDR_MASK_BLK } {
        error "error: require block base address"
    }

    master_write_32 $mm $addr $::cfi1616::CMD_ID_READ
    set lock [ master_read_32 $mm [ expr { $addr + 4 * 2 } ] 1 ]
    if { $lock == 0x00010001 } { return 0 }
    if { $lock & 0x00020002 } {
        error "error: block is locked-down"
    }

    master_write_32 $mm $addr $::cfi1616::CMD_LOCK_SETUP
    master_write_32 $mm $addr 0x00010001

    master_write_32 $mm $addr $::cfi1616::CMD_ID_READ
    set lock [ master_read_32 $mm [ expr { $addr + 4 * 2 } ] 1 ]
    set err 0
    if { $lock != 0x00010001 } { set err -11 }

    read_array $mm
    return $err
}

proc ::cfi1616::unlock { mm addr } {
    if { $addr & ~$::cfi1616::ADDR_MASK_BLK } {
        error "error: require block base address"
    }

    master_write_32 $mm $addr $::cfi1616::CMD_ID_READ
    set lock [ master_read_32 $mm [ expr { $addr + 4 * 2 } ] 1 ]
    if { $lock == 0x00000000 } { return 0 }
    if { $lock & 0x00020002 } {
        error "error: block is locked-down"
    }

    master_write_32 $mm $addr $::cfi1616::CMD_LOCK_SETUP
    master_write_32 $mm $addr $::cfi1616::CMD_CONFIRM

    master_write_32 $mm $addr $::cfi1616::CMD_ID_READ
    set lock [ master_read_32 $mm [ expr { $addr + 4 * 2 } ] 1 ]
    set err 0
    if { $lock != 0x00000000 } { set err -11 }

    read_array $mm
    return $err
}

proc ::cfi1616::erase { mm addr } {
    if { $addr & ~$::cfi1616::ADDR_MASK_BLK } {
        error "error: require block base address"
    }

    master_write_32 $mm $addr $::cfi1616::CMD_ERASE
    master_write_32 $mm $addr $::cfi1616::CMD_CONFIRM

    return 0
}

proc ::cfi1616::program { mm addr buffer } {
    if { $addr & ~$::cfi1616::ADDR_MASK_BUF } {
        error "error: require buffer aligned address"
    }

    set n [ llength $buffer ]
    if { $n <= 0 } { error "n <= 0" }
    if { $n > 512 } { error "n > 512" }

    master_write_32 $mm $addr $::cfi1616::CMD_PGM_BUF
    set sr [ master_read_32 $mm $addr 1 ]
    if { [ expr { $sr & $::cfi1616::SR_DWS } ] == $::cfi1616::SR_DWS } { return [ set err -11 ] }

    set n [ expr { $n - 1 } ]
    master_write_32 $mm $addr [ format "0x%04X%04X" $n $n ]
    master_write_32 $mm $addr $buffer
    master_write_32 $mm $addr $::cfi1616::CMD_CONFIRM

    return 0
}

proc ::cfi1616::verify { mm addr buffer } {
    read_array $mm
    set rb [ master_read_32 $mm $addr $n ]
    if { [ string compare -nocase $buffer $rb ] != 0 } {
        error "wb != rb"
    }
}
