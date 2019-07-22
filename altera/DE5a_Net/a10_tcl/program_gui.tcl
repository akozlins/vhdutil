#
# author : Alexandr Kozlinskiy
# date : 2017-11-24
#

source [ file join [ file dirname [ info script ] ] "program.tcl"]

set ::stop 0
set ::progress 0

proc callback { n i } {
    set ::progress [ expr { 100.0 * $i / $n } ]
    update
    return $::stop
}

proc gui_program { addr fname } {
    if { [ file extension $fname ] == ".elf" } {
        set flash [ file rootname $fname ].[ clock format [ file mtime $fname ] -format %Y%m%d_%H%M%S ].flash
        if { [ file exists $flash ] == 0 } {
            file rename [ ?t ::quartus::elf2flash $fname ] $flash
        }
        set fname $flash
    }
    if { [ file extension $fname ] == ".sof" } {
        set flash [ file rootname $fname ].[ clock format [ file mtime $fname ] -format %Y%m%d_%H%M%S ].flash
        if { [ file exists $flash ] == 0 } {
            file rename [ ?t ::quartus::sof2flash $fname ] $flash
        }
        set fname $flash
    }
    if { [ file extension $fname ] == ".flash" } {
        set fname [ ?t ::quartus::flash2bin $fname ]
    }
    if { [ file extension $fname ] != ".bin" } {
        error "invalid file type: '$fname', require '.bin'"
    }

    ?t program_file -callback ::callback $::mm $addr $fname
}

proc configure { paths args } {
    foreach { path } $paths {
        $path configure {*}$args
    }
}

proc cmd_test { addr } {
    set ::stop 0
    configure { .p.test_b .p.elf_b .p.sof_b } -state disabled

    ?c program_test $addr

    configure { .p.test_b .p.elf_b .p.sof_b } -state normal
}

proc cmd_elf { addr fname } {
    set ::stop 0
    configure { .p.test_b .p.elf_b .p.sof_b } -state disabled

    ?c gui_program $addr $fname

    configure { .p.test_b .p.elf_b .p.sof_b } -state normal
}

proc cmd_sof { addr fname } {
    set ::stop 0
    configure { .p.test_b .p.elf_b .p.sof_b } -state disabled

    ?c gui_program $addr $fname

    configure { .p.test_b .p.elf_b .p.sof_b } -state normal
}

proc wtree_cmd { parent cmd } {
    foreach { child } [ winfo children $parent ] {
        apply $cmd $child
        wtree_cmd $child $cmd
    }
}

#proc center_window { window widht height } {
#    set x [ expr { ( [ winfo vrootwidth $window ] - $widht ) / 2 } ]
#    set y [ expr { ( [ winfo vrootheight $window ] - $height ) / 2 } ]
#    tkwait visibility $window
#    wm geometry $window ${widht}x${height}+$x+$y
#}

proc gui {} {
    package require Tk

#    tkwait visibility .
#    wm geometry . 800x600

    # mm
    ::util::treeview .m $::mm_paths {
        ::mm_claim [ lsearch $::mm_paths [ .m.t focus ] ]
    }
    .m.t configure -height 6
    grid .m -column 0 -row 0 -sticky ew

    # frame
    ttk::frame .f -padding 4
    grid .f -column 0 -row 1 -sticky nsew
    # sof
    ttk::label .f.sof_l -text "SOF:"
    grid .f.sof_l -column 0 -row 1 -sticky e
    ttk::entry .f.sof_e -textvariable ::sof
    grid .f.sof_e -column 1 -row 1 -sticky ew -padx 4
    ::util::filenav .f.sof_b ::sof [ list *.sof *.flash *.bin ]
    .f.sof_b.l configure -height 8 -width 40
    grid .f.sof_b -column 0 -columnspan 2 -row 0 -pady 2 -sticky ew
    # elf
    ttk::label .f.elf_l -text "ELF:"
    grid .f.elf_l -column 2 -row 1 -sticky e
    ttk::entry .f.elf_e -textvariable ::elf
    grid .f.elf_e -column 3 -row 1 -sticky ew -padx 4
    ::util::filenav .f.elf_b ::elf [ list *.elf *.flash *.bin ]
    .f.elf_b.l configure -height 8 -width 40
    grid .f.elf_b -column 2 -columnspan 2 -row 0 -pady 2 -sticky ew

    # program
    ttk::frame .p -padding 4
    grid .p -column 0 -row 2
    # test
    ttk::button .p.test_b -text "Test" -command {
        coroutine cr_cmd_test cmd_test 0x05e80000
    }
    grid .p.test_b -column 2 -row 0
    # elf
    ttk::button .p.elf_b -text "Program ELF" -command {
        coroutine cr_cmd_elf cmd_elf $::elf_addr $::elf
    }
    grid .p.elf_b -column 1 -row 0
    # sof
    ttk::button .p.sof_b -text "Program SOF" -command {
        coroutine cr_cmd_sof cmd_sof $::sof_addr $::sof
    }
    grid .p.sof_b -column 0 -row 0
    # stop
    ttk::button .p.stop_b -text "Stop" -command {
        set ::stop 1
    }
    grid .p.stop_b -column 3 -row 0
    # progress
    ttk::progressbar .p.progress -variable ::progress
    grid .p.progress -column 0 -row 1 -columnspan 4 -sticky ew

    grid columnconfigure . 0 -weight 1
    grid columnconfigure .f 1 -weight 1
    grid columnconfigure .f 3 -weight 1

    wtree_cmd . {
        { p } {
            catch { $p configure -font { 9x15 -15 bold } }
        }
    }
}

if { $::argc >= 1 } { set sof [ lindex $::argv 0 ] }
if { $::argc >= 2 } { set elf [ lindex $::argv 1 ] }

?c gui
