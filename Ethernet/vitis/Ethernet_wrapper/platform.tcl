# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\projects\Elbert_S7\Ethernet\vitis\Ethernet_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\projects\Elbert_S7\Ethernet\vitis\Ethernet_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {Ethernet_wrapper}\
-hw {C:\projects\Elbert_S7\Ethernet\Ethernet_wrapper.xsa}\
-out {C:/projects/Elbert_S7/Ethernet/vitis}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {lwip_echo_server}
platform generate -domains 
platform active {Ethernet_wrapper}
platform generate -quick
platform generate
bsp reload
bsp write
platform generate -domains 
platform active {Ethernet_wrapper}
bsp reload
bsp config lwip_dhcp "true"
bsp write
bsp reload
platform generate -domains 
platform active {Ethernet_wrapper}
platform generate -domains 
