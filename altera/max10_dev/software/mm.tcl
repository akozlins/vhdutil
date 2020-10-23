#

set mm_paths [ get_service_paths master ]
set mm_index -1

proc mm_claim { pattern } {
    set index [ lsearch $::mm_paths $pattern ]

    if { $index == $::mm_index } {
        return
    }
    if { [ info exists ::mm ] } {
        ::close_service master $::mm
        unset ::mm
    }
    if { $index >= 0 } {
        set path [ lindex $::mm_paths $index ]
        puts "INFO: claim master '$path'"
        set ::mm [ ::claim_service master $path "" ]
    }
    set ::mm_index $index
}
