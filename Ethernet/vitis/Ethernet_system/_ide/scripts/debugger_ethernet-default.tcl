# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\projects\Elbert_S7\Ethernet\vitis\Ethernet_system\_ide\scripts\debugger_ethernet-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\projects\Elbert_S7\Ethernet\vitis\Ethernet_system\_ide\scripts\debugger_ethernet-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Platform Cable USB 00001901e61701" && level==0 && jtag_device_ctx=="jsn-DLC9LP-00001901e61701-0362f093-0"}
fpga -file C:/projects/Elbert_S7/Ethernet/vitis/Ethernet/_ide/bitstream/download.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw C:/projects/Elbert_S7/Ethernet/vitis/Ethernet_wrapper/export/Ethernet_wrapper/hw/Ethernet_wrapper.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow C:/projects/Elbert_S7/Ethernet/vitis/Ethernet/Debug/Ethernet.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
