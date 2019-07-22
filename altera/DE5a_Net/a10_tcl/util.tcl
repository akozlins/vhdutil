# util.tcl --
#
# author : Alexandr Kozlinskiy
# date : 2017-11-24
#

source [ file join [ file dirname [ info script ] ] "coroutine.tcl"]

namespace eval ::util {}

proc ?t { args } {
    set start [ clock micro ]
    try {
        set ret [ uplevel 1 $args ]
    } \
    finally {
        set t [ expr { ( [ clock micro ] - $start ) / 1000.0 } ]
        puts "DEBUG: => $t ms"
    }
    return $ret
}

proc ?c { args } {
    set err [ catch { uplevel 1 $args } ]
    if { $err } {
        puts "WARN: $::errorInfo"
    }
}

# ::util::exec --
#
proc ::util::exec { args } {
    set chan [ open |$args ]

    try {
        set blocking [ ::chan configure $chan -blocking ]
        if { [ info coroutine ] != "" } {
            ::chan configure $chan -blocking 0
        }
        while 1 {
            set result [ ::chan gets $chan line ]
            if { $result == 0 } continue
            if { [ ::chan eof $chan ] == 1 } break
            if { [ ::chan blocked $chan ] } {
                ::chan event $chan readable [ list [ info coroutine ] ]
                yield
                ::chan event $chan readable {}
            } \
            else {
                puts $line
            }
        }
    } \
    finally {
        ::chan configure $chan -blocking $blocking
        ::chan close $chan
    }
}

proc ::util::exec_test { args } {
    lassign [ ::chan pipe ] r w
    lappend args >@$w &
    set pid [ exec {*}$args ]
    ::chan close $w

    while 1 {
        set result [ ::chan gets $r line ]
        if { $result == 0 } continue
        if { [ ::chan eof $r ] } break
        puts $line
    }
    close $r
}

# ::util::fcopy --
#
proc ::util::fcopy { args } {
    if { [ info coroutine ] == "" || [ lsearch $args -command ] >= 0 } {
        tailcall ::chan copy {*}$args
    }

    lappend args -command [ info coroutine ]
    ::chan copy {*}$args
    yield
}

# ::util::filenav --
#
# File navigator listbox with scrollbar.
#
# Arguments:
# frameName
# pathName
# patterns (optional)
#
proc ::util::filenav { frameName pathName { patterns {} } } {
    upvar 1 $pathName path

    set l $frameName.l
    set s $frameName.s

    if { [ winfo exists $frameName ] == 0 } {
        frame $frameName
        listbox $l -selectmode single -yscrollcommand [ list $s set ] -exportselection 0
        scrollbar $s -command [ list $l yview ]
        grid $l -column 0 -row 0 -sticky nsew
        grid $s -column 1 -row 0 -sticky ns
        grid columnconfigure $frameName 0 -weight 1
        grid rowconfigure $frameName 0 -weight 1
        bind $l <Double-1> [ list ::util::filenav $frameName $pathName $patterns ]
    }
    if { [ winfo class $l ] != "Listbox" } {
        error "invalid widget type: '[ winfo class $l ]', require 'Listbox'"
    }

    #
    while 1 {
        if { [ file exists $path ] } break;
        set path [ file dirname $path ]
    }

    set dir $path
    if { [ file isfile $dir ] } {
        set dir [ file dirname $dir ]
    }

    if { [ $l get active ] != "" } {
        set path [ file normalize [ file join $dir [ $l get active ] ] ]
        if { [ file isdirectory $path ] } {
            set dir $path
        }
    }

    # get dirs and files
    set dirs [ glob -nocomplain -directory $dir -tails -types d -- * ]
    set files [ glob -nocomplain -directory $dir -tails -types f -- * ]

    $l delete 0 end

    set i 0
    # fill '..' if not a volume path
    if { [ lsearch [ file volumes ] $dir ] < 0 } {
        $l insert end ..
        incr i
    }
    # fill dirs, set foreground color
    foreach dir [ lsort $dirs ] {
        $l insert end $dir/
        $l itemconfigure $i -fg blue
        incr i
    }
    # fill files, check patterns
    foreach file [ lsort $files ] {
        set match 1
        foreach pattern $patterns {
            set match [ string match $pattern $file ]
            if { $match } break
        }
        if { $match == 0 } continue
        $l insert end $file
        incr i
    }

    # select file
    set index -1
    if { [ file isfile $path ] } {
        set index [ lsearch [ $l get 0 end ] [ file tail $path ] ]
    }
    $l see $index
    $l activate $index
    $l selection set $index

    # reduce path
    # TODO: use file separator
#    if { $path == [pwd] } { set path "" }
#    set path [ regsub "^[pwd]/" $path "" ]
#    if { $path == $::env(HOME) } { set path "~" }
#    set path [ regsub "^$::env(HOME)/" $path "~/" ]

    return
}

proc ::util::treeview_compact { t { root {} } } {
    set items [ $t children $root ]

    foreach item $items {
        treeview_compact $t $item

        set items_ [ $t children $item ]
        if { [ llength $items_ ] == 1 } {
            set item_ [ lindex $items_ 0 ]
            $t move $item_ $root end
            $t item $item_ -text [ file join [ $t item $item -text ] [ $t item $item_ -text ] ]
            $t delete [ list $item ]
        }
    }
}

proc ::util::treeview_sel { t { script {} } } {
    $t tag remove tag_sel
    set item [ $t focus ]
    if { $item != {} } {
        $t tag add tag_sel [ list $item ]
        if 1 $script
    }
}

# ::util::treeview --
#
proc ::util::treeview { frameName paths { script {} } } {
    set t $frameName.t
    set s $frameName.s

    if { [ winfo exists $frameName ] == 0 } {
        frame $frameName
        ttk::treeview $t -selectmode browse -yscrollcommand [ list $s set ]
        scrollbar $s -command [ list $t yview ]
        grid $t -column 0 -row 0 -sticky nsew
        grid $s -column 1 -row 0 -sticky ns
        grid columnconfigure $frameName 0 -weight 1
        grid rowconfigure $frameName 0 -weight 1

        $t tag configure tag_font -font { 9x15 -15 bold }
        $t tag configure tag_path -foreground blue
        $t tag configure tag_sel -foreground red
        $t tag bind tag_item <Double-1> [ list ::util::treeview_sel $t $script ]
    }

    $t delete [ $t children {} ]
    foreach path $paths {
        set root {}
        foreach name [ file split $path ] {
            set item [ file join $root $name ]
            if { [ $t exists $item ] == 0 } {
                $t insert $root end -id $item -text $name -open true
                $t tag add tag_font [ list $item ]
                $t tag add tag_path [ list $root ]
            }
            set root $item
        }
        $t tag add tag_item [ list $root ]
    }

    ::util::treeview_compact $t

    $t focus [ lindex $paths 0 ]
    ::util::treeview_sel $t
}
