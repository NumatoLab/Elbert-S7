# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\projects\Elbert_S7\DDR3_memtest\vitis_classic\DDR3_system\_ide\scripts\systemdebugger_ddr3_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\projects\Elbert_S7\DDR3_memtest\vitis_classic\DDR3_system\_ide\scripts\systemdebugger_ddr3_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "ftdi Elbert NLB1PJ2PA" && level==0 && jtag_device_ctx=="jsn-Elbert-NLB1PJ2PA-0362f093-0"}
fpga -file C:/projects/Elbert_S7/DDR3_memtest/vitis_classic/DDR3/_ide/bitstream/DDR_wrapper.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw C:/projects/Elbert_S7/DDR3_memtest/vitis_classic/DDR_wrapper/export/DDR_wrapper/hw/DDR_wrapper.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow C:/projects/Elbert_S7/DDR3_memtest/vitis_classic/DDR3/Debug/DDR3.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
