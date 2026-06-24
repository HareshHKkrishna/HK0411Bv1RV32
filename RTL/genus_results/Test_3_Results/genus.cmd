# Cadence Genus(TM) Synthesis Solution, Version 25.11-s095_1, built Aug 12 2025 10:59:05

# Date: Tue Jun 23 08:02:07 2026
# Host: localhost.localdomain (x86_64 w/Linux 4.18.0-553.el8_10.x86_64) (4cores*8cpus*1physical cpu*11th Gen Intel(R) Core(TM) i5-11320H @ 3.20GHz 8192KB)
# OS:   Rocky Linux 8.10 (Green Obsidian)

source run_genus.tcl
write_hdl -mapped > cpu_top_wrapper_netlist.v
write_hdl -mapped -output cpu_top_wrapper_netlist.v
write_hdl -mapped > cpu_top_wrapper_netlist.v
write_sdc > cpu_top_wrapper_synth.sdc
write_db cpu_top_wrapper.db
exit
