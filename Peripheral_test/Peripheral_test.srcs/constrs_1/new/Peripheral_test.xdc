## SEVEN SEGMENT DISPLAY###
set_property -dict {PACKAGE_PIN "A16" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[7]}]
set_property -dict {PACKAGE_PIN "B16" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[6]}]
set_property -dict {PACKAGE_PIN "A15" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[5]}]
set_property -dict {PACKAGE_PIN "B15" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[4]}]
set_property -dict {PACKAGE_PIN "A14" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[3]}]
set_property -dict {PACKAGE_PIN "B14" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[2]}]
set_property -dict {PACKAGE_PIN "A13" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[1]}]
set_property -dict {PACKAGE_PIN "B13" IOSTANDARD LVCMOS33} [get_ports {SevenSegment[0]}]
set_property -dict {PACKAGE_PIN "E12" IOSTANDARD LVCMOS33} [get_ports {Enable[0]}]
set_property -dict {PACKAGE_PIN "D12" IOSTANDARD LVCMOS33} [get_ports {Enable[1]}]
set_property -dict {PACKAGE_PIN "C13" IOSTANDARD LVCMOS33} [get_ports {Enable[2]}]
set_property -dict {PACKAGE_PIN "C14" IOSTANDARD LVCMOS33} [get_ports {Enable[3]}]

## CLK AND RESET #####
set_property -dict {PACKAGE_PIN "D14" IOSTANDARD LVCMOS33} [get_ports Clk]
set_property -dict {PACKAGE_PIN "T14" IOSTANDARD LVCMOS33} [get_ports RESET]


## DIP SWITCH ###
#set_property -dict {PACKAGE_PIN "B3" IOSTANDARD LVCMOS18} [get_ports {Switch[3]}]
set_property -dict {PACKAGE_PIN "C3" IOSTANDARD LVCMOS18} [get_ports {Switch[2]}]
set_property -dict {PACKAGE_PIN "B4" IOSTANDARD LVCMOS18} [get_ports {Switch[1]}]
set_property -dict {PACKAGE_PIN "C4" IOSTANDARD LVCMOS18} [get_ports {Switch[0]}]


## LEDs ####
set_property -dict {PACKAGE_PIN "T11" IOSTANDARD LVCMOS33} [get_ports {LED[7]}]
set_property -dict {PACKAGE_PIN "R11" IOSTANDARD LVCMOS33} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN "T13" IOSTANDARD LVCMOS33} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN "T12" IOSTANDARD LVCMOS33} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN "V13" IOSTANDARD LVCMOS33} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN "U12" IOSTANDARD LVCMOS33} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN "V15" IOSTANDARD LVCMOS33} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN "V14" IOSTANDARD LVCMOS33} [get_ports {LED[0]}]
