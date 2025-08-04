# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\projects\Elbert_S7\DDR3_memtest\vitis_classic\DDR_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\projects\Elbert_S7\DDR3_memtest\vitis_classic\DDR_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {DDR_wrapper}\
-hw {C:\projects\Elbert_S7\DDR3_memtest\DDR_wrapper.xsa}\
-out {C:/projects/Elbert_S7/DDR3_memtest/vitis_classic}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {memory_tests}
platform generate -domains 
platform active {DDR_wrapper}
platform generate -quick
platform generate
platform active {DDR_wrapper}
platform config -updatehw {C:/projects/Elbert_S7/DDR3_memtest/DDR_wrapper.xsa}
platform generate -domains 
