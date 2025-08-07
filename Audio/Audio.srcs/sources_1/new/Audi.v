`timescale 1ns / 1ps



module Audio(  
                               
    // Assuming 100MHz input clock.My need to adjust the counter below
    // if any other input frequency is used
	    input Clk,   

    // Output to CS4344 		
		output reg SDIN,							   
        output reg SCLK,                    
		output reg LRCK,
		output  MCLK
		);

// Register used internally
reg [31:0]counter=0;
reg [15:0]count=0;
reg pwm;


integer pwmcount=99;

// Reduce the Clock Frequency
parameter freq = 100000000/60000;


 
assign MCLK = Clk;
always @(posedge Clk)   
 begin
   if (count==0)                                           
	  begin
	   pwm <= (pwmcount==19)? counter[24] : counter[20];  
		pwmcount <= (pwmcount==0)? 99:pwmcount-1;
	
    	
	    if (pwm) begin                                              
	      count <= freq/100;
    
	
         LRCK <= 1'b0; 
       end			
		 else begin
		   count <= freq/freq;
			LRCK <= 1'b1;
			SCLK <= ~SCLK;
		 end
		 
    
		 SDIN <= ~SDIN;                                             
     end
	else 
	   count <= count-1;
	  counter <= counter+1;
  end
endmodule