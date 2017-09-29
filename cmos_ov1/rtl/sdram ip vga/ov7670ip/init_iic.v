/*-----------------------------------------------------------------------

Date				:		2017-09-03
Description			:		Design for 摄像头初始化 .

-----------------------------------------------------------------------*/

module init_iic
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//XXX interface
	output					lcd_dclk,   	//
	output	reg		[23:0]	lcd_rgb,		//

	//user interface

	output	reg		[11:0]	lcd_xpos		//
	
); 


//--------------------------------
//Funtion :               

always @(posedge clk or negedge rst_n)
begin

end

endmodule
	
