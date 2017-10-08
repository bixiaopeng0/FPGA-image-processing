/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for .

-----------------------------------------------------------------------*/


module vga_control
(
	//global clock
	input					clk					,			//system clock
	input					rst_n				,     		//sync reset
	
	//vga interface
	input			[10:0]	value_x				,
	input			[10:0]	value_y				,
	output			[23:0]	rgb					,

	//rom interface

	output	reg		[15:0]	rom_addr			,		//
	input			[23:0]	rom_q				,
	
	//user	interface
	output			[ 7:0]	gray				,
	input			[10:0]	sobel_data			,
	output					vga_en				,
	input					display_val
); 
//--------------------------------
//Funtion : define
wire		[10:0]		display_x				;
wire		[10:0]		display_y				;



//--------------------------------
//Funtion :    display_区域           


assign		vga_en		=	((value_x >= 8'd100 && value_x < 9'd300) && (value_y >= 8'd100 && value_y < 9'd300)) ? 1'b1 : 1'b0;


//--------------------------------
//Funtion :    rgb

//assign		rgb				=	(display_addr == 1'b1) ? rom_q : 1'd0; 
assign		rgb				=	(display_val == 1'b1 && sobel_data > 100) ? {3{8'hff}} : 1'd0; 


//--------------------------------
//Funtion :    转灰度处理
//wire		[7:0]		gray;

assign		gray = (rom_q[23:16]*19595 + rom_q[15:8]*38469 + rom_q[7:0]*7472) >> 16;



//--------------------------------
//Funtion :    rom_addr


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rom_addr <= 1'd0;
	else if(vga_en)
		rom_addr <= display_x  +  display_y*200;
	else
		rom_addr <= 1'd0;
end


assign			display_x		=	value_x - 8'd100;
assign			display_y		=	value_y	- 8'd100;



endmodule
	
