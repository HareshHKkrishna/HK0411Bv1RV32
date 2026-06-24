create_library_set -name LIBSET \
    -timing {
        /home/user19/Documents/Cadence/gsclib045_all_v4.8/gsclib045/timing/slow_vdd1v0_basicCells.lib
        /home/user19/Documents/Cadence/gsclib045_all_v4.8/gsclib045/timing/slow_vdd1v0_multibitsDFF.lib
    }

create_rc_corner -name RC

create_delay_corner \
    -name DELAY \
    -library_set LIBSET \
    -rc_corner RC

create_constraint_mode \
    -name CONSTRAINTS \
    -sdc_files {cpu_top_wrapper_synth.sdc}

create_analysis_view \
    -name VIEW \
    -constraint_mode CONSTRAINTS \
    -delay_corner DELAY

set_analysis_view \
    -setup VIEW \
    -hold VIEW