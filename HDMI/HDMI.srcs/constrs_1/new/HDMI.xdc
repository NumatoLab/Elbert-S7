set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
##Clock Signal
set_property -dict { PACKAGE_PIN "D14"    IOSTANDARD LVCMOS33 } [get_ports { clk_in }];
set_property -dict { PACKAGE_PIN "T14"    IOSTANDARD LVCMOS33 } [get_ports { reset }]; 
###HDMI out  
set_property -dict { PACKAGE_PIN U18    IOSTANDARD TMDS_33  } [get_ports { data_n[0] }];  
set_property -dict { PACKAGE_PIN U17    IOSTANDARD TMDS_33  } [get_ports { data_p[0] }];  
set_property -dict { PACKAGE_PIN V17    IOSTANDARD TMDS_33  } [get_ports { data_n[1] }];  
set_property -dict { PACKAGE_PIN U16    IOSTANDARD TMDS_33  } [get_ports { data_p[1] }]; 
set_property -dict { PACKAGE_PIN T15    IOSTANDARD TMDS_33  } [get_ports { data_n[2] }];  
set_property -dict { PACKAGE_PIN R15    IOSTANDARD TMDS_33  } [get_ports { data_p[2] }]; 
set_property -dict { PACKAGE_PIN R17    IOSTANDARD TMDS_33  } [get_ports { clk_n}]; 
set_property -dict { PACKAGE_PIN R16    IOSTANDARD TMDS_33  } [get_ports { clk_p}];