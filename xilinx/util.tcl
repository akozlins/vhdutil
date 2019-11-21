#

proc sim { tb } {
    set_property top_lib xil_defaultlib [ get_filesets sim_1 ]
    set_property top $tb [ get_filesets sim_1 ]
    launch_simulation
}

proc pgm { bit } {
    set dev [ get_hw_devices "xc7z020_1" ]
    set_property PROGRAM.FILE $bit $dev
    program_hw_devices $dev
}

proc add_files_glob { pattern { fileset "sources_1" }  } {
    foreach { file } [ lsort [ glob -nocomplain -- $pattern ] ] {
        add_files -fileset $fileset $file
    }
}

proc read_xdc_glob { pattern  } {
    foreach { file } [ lsort [ glob -nocomplain -- $pattern ] ] {
        read_xdc -unmanaged $file
    }
}
