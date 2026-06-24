if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name LIBSET\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow_vdd1v0_basicCells.lib\
    ${::IMEX::libVar}/mmmc/slow_vdd1v0_multibitsDFF.lib]
create_rc_corner -name RC\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name DELAY\
   -library_set LIBSET\
   -rc_corner RC
create_constraint_mode -name CONSTRAINTS\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/CONSTRAINTS/CONSTRAINTS.sdc]
create_analysis_view -name VIEW -constraint_mode CONSTRAINTS -delay_corner DELAY -latency_file ${::IMEX::dataVar}/mmmc/views/VIEW/latency.sdc
set_analysis_view -setup [list VIEW] -hold [list VIEW]
