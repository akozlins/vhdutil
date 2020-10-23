#
# author : Alexandr Kozlinskiy
# date : 2019-08-26
#

namespace eval ::ufm {
    set CSR 0x700F00F0
    set STATUS [ expr $CSR + 4 * 0 ]
    set CONTROL [ expr $CSR + 4 * 1 ]
}

proc ::ufm::wait_idle { mm { ms 1 } } {
    while { true } {
        set status [ master_read_32 $mm $::ufm::STATUS 1 ]
        if { ($status & 0x3) == 0 } {
            break
        }
        after $ms
    }
}

proc ::ufm::disable_wp { mm sector } {
    set sector [ expr $sector + 22 ]
    set control [ master_read_32 $mm $::ufm::CONTROL 1 ]
    set control [ expr $control & ~(1 << $sector) ]
    master_write_32 $mm $::ufm::CONTROL $control
}

proc ::ufm::enable_wp { mm sector } {
    set sector [ expr $sector + 22 ]
    set control [ master_read_32 $mm $::ufm::CONTROL 1 ]
    set control [ expr $control | (1 << $sector) ]
    master_write_32 $mm $::ufm::CONTROL $control
}

proc ::ufm::write { mm addr u32 } {
    set sector 0
    if { 0x00000000 <= $addr && $addr < 0x00004000 } { set sector 1 }
    if { 0x00004000 <= $addr && $addr < 0x00008000 } { set sector 2 }

    if { !(1 <= $sector && $sector <= 5) } {
        error "error: sector $sector is not valid"
    }

    set status [ master_read_32 $mm $::ufm::STATUS 1 ]
    if { $status & (1 << (4 + $sector)) } {
        error "error: sector $sector is read only"
    }

    if { [ master_read_32 $mm $addr 1 ] != 0xFFFFFFFF } {
        puts [ format "warn: \[0x%08X\] != 0xFFFFFFFF" [ expr $addr ] ]
    }

    try {
        ::ufm::disable_wp $mm $sector

        master_write_32 $mm $addr $u32

        ::ufm::wait_idle $mm

        set control [ master_read_32 $mm $::ufm::CONTROL 1 ]
        if { ($control & 0x08) != 0x08 } {
            error "error: write is not successful"
        }
    } \
    finally {
        ::ufm::enable_wp $mm $sector
    }

    if { [ master_read_32 $mm $addr 1 ] != $u32 } {
        puts [ format "warn: \[0x%08X\] != 0x%08X" [ expr $addr ] [ expr $u32 ] ]
    }
}

proc ::ufm::erase { mm sector } {
    if { !(1 <= $sector && $sector <= 5) } {
        error "error: sector $sector is not valid"
    }

    set status [ master_read_32 $mm $::ufm::STATUS 1 ]
    if { $status & (1 << (4 + $sector)) } {
        error "error: sector $sector is read only"
    }

    try {
        ::ufm::disable_wp $mm $sector

        ::ufm::wait_idle $mm

        set control [ master_read_32 $mm $::ufm::CONTROL 1 ]
        master_write_32 $mm $::ufm::CONTROL [ expr $control & ~(0x7 << 20) | ($sector << 20) ]

        ::ufm::wait_idle $mm

        set control [ master_read_32 $mm $::ufm::CONTROL 1 ]
        if { ($control & 0x10) != 0x10 } {
            error "error: sector $sector erase is not successful"
        }
    } \
    finally {
        ::ufm::enable_wp $mm $sector
    }
}
