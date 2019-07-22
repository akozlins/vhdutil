#

set project_name [lindex $quartus(args) 0]

package require ::quartus::flow
project_open $project_name
execute_flow -dont_export_assignments -compile
project_close
