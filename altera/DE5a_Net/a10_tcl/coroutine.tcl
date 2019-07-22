# coroutine.tcl --
#
# author : Alexandr Kozlinskiy
# date : 2017-11-24
#
# source: https://github.com/tcltk/tcllib/tree/master/modules/coroutine
#

if { [ info exists ::coroutine::auto::once ] } return

namespace eval ::coroutine::util {}

proc ::coroutine::util::after {delay} {
    ::after $delay [info coroutine]
    yield
    return
}

proc ::coroutine::util::update {{what {}}} {
    if {$what eq "idletasks"} {
        ::after idle [info coroutine]
    } elseif {$what ne {}} {
        # Force proper error message for bad call.
        tailcall ::tcl::update $what
    } else {
        ::after 0 [info coroutine]
    }
    yield
    return
}

namespace eval ::coroutine::auto {}

proc ::coroutine::auto::wrap_after {delay args} {
    if {
        ([info coroutine] eq {}) ||
        ([llength $args] > 0)
    } {
        # We use the core builtin when called from either outside of a
        # coroutine, or for an asynchronous delay.

        tailcall ::coroutine::auto::core_after $delay {*}$args
    }

    # Inside of coroutine, and synchronous delay (args == "").
    tailcall ::coroutine::util::after $delay
}

proc ::coroutine::auto::wrap_update {{what {}}} {
    puts "::coroutine::util::update"
    if {[info coroutine] eq {}} {
        tailcall ::coroutine::auto::core_update {*}$what
    }

    # This is a full re-implementation of mode (1), because the
    # coroutine-aware part uses the builtin itself for some
    # functionality, and this part cannot be taken as is.

    if {$what eq "idletasks"} {
        after idle [info coroutine]
    } elseif {$what ne {}} {
        # Force proper error message for bad call.
        tailcall ::coroutine::auto::core_update $what
    } else {
        after 0 [info coroutine]
    }
    yield
    return
}

::apply { {} {
    foreach { cmd } { after update } {
        rename ::$cmd [namespace current]::core_$cmd
        rename [namespace current]::wrap_$cmd ::$cmd
    }
} ::coroutine::auto }

set ::coroutine::auto::once 1
