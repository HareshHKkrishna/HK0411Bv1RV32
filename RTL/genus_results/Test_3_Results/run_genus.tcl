#--------------------------------------------------
# Search Path
#--------------------------------------------------
set_db init_hdl_search_path .

#--------------------------------------------------
# Technology Libraries
#--------------------------------------------------
read_libs {
    /home/user19/Documents/Cadence/gsclib045_all_v4.8/gsclib045/timing/slow_vdd1v0_basicCells.lib
    /home/user19/Documents/Cadence/gsclib045_all_v4.8/gsclib045/timing/slow_vdd1v0_multibitsDFF.lib
}

#--------------------------------------------------
# Physical Libraries
#--------------------------------------------------
read_physical -lef {
    /home/user19/Documents/Cadence/gsclib045_all_v4.8/gsclib045/lef/gsclib045_tech.lef
    /home/user19/Documents/Cadence/gsclib045_all_v4.8/gsclib045/lef/gsclib045_macro.lef
    /home/user19/Documents/Cadence/gsclib045_all_v4.8/gsclib045/lef/gsclib045_multibitsDFF.lef
}

#--------------------------------------------------
# Read RTL
#--------------------------------------------------
read_hdl -sv -f rtl.f

elaborate cpu_top_wrapper

check_design > check_design.rpt

read_sdc cpu_top.sdc

# IMPORTANT
init_design

syn_generic
syn_map
syn_opt

report_qor > qor.rpt

report_timing -lint > timing_lint.rpt

report_timing -max_paths 20 > timing20.rpt

report_gates > gates.rpt

report_area -detail > area_detail.rpt

report_power > power.rpt

write_hdl -mapped > cpu_top_wrapper_netlist.v

write_sdc > cpu_top_wrapper_synth.sdc

write_db cpu_top_wrapper.db