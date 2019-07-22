#
# author : Alexanrd Kozlinskiy
# date : 2017-11-27
#

source [ file join [ file dirname [ info script ] ] "util.tcl"]

namespace eval ::quartus {}

proc check_magic { fname magic } {
    set f [ open $fname r ]
    fconfigure $f -translation binary
    try {
        set n [ string length $magic ]
        if { [ string match $magic [ read $f $n ] ] == 0 } {
            error "invalid file magic: '$fname', require '$magic'"
        }
    } \
    finally {
        close $f
    }
}

# ::quartus::sof2flash --
#
# Convert FPGA configuration (SOF) to flash file (SREC).
#
# Arguments:
# input SOF file
# offset (optional) location within the flash
# optionbit (optional) Option Bit Address
#
# Results:
# Location of output flash file.
#
proc ::quartus::sof2flash { input { offset 0x02B40000 } { optionbit 0x00030000 } } {
    puts "DEBUG: sof2flash ..."
    if { [ file extension $input ] != ".sof" } {
        error "invalid file type: '$input', require '.sof'"
    }
    check_magic $input "SOF"
    set output [ file rootname $input ].flash

#    if { [ file exists $output ] && [ file mtime $output ] > [ file mtime $input ] } {
#        puts "INFO: '$output' is up to date"
#        return $output
#    }

    set cmd [ list sof2flash --pfl --optionbit=$optionbit --programmingmode=PS \
                             --verbose \
                             --input=$input \
                             --output=$output --offset=$offset ]
    ::util::exec {*}$cmd 2>@1

    return $output
}

# ::quartus::elf2flash --
# Convert software file (ELF) to flash file (SREC).
#
# Arguments:
# input ELF file
# reset (optional) CPU reset address
#
# Results:
# Location of output flash file.
#
proc ::quartus::elf2flash { input { reset 0x05E40000 } } {
    puts "DEBUG: elf2flash ..."
    if { [ file extension $input ] != ".elf" } {
        error "invalid file type: '$input', require '.elf'"
    }
    check_magic $input "\x7FELF"
    set output [ file rootname $input ].flash

    set cmd [ list elf2flash --base=0x0 --end=0x0FFFFFFF \
                             --boot=$::env(SOPC_KIT_NIOS2)/components/altera_nios2/boot_loader_cfi.srec \
                             --reset=$reset \
                             --input=$input --output=$output ]
    ::util::exec {*}$cmd 2>@1

    return $output
}

# ::quartus::flash2bin --
# Convert flash file (SREC) to binary format.
#
proc ::quartus::flash2bin { input } {
    puts "DEBUG: flash2bin ..."
    if { [ file extension $input ] != ".flash" } {
        error "invalid file type: '$input', require '.flash'"
    }
    set output [ file rootname $input ].bin

    set cmd [ list objcopy -Isrec -Obinary $input $output ]
    ::util::exec {*}$cmd 2>@1

    return $output
}
