/*-----------------------------------------------------------------------

Date				:		2017-09-03
Description			:		Design for poweer init.

-----------------------------------------------------------------------*/

module power_ctrl
(
	//global clock
        input                   clk                     ,       
        input                   rst_n                   ,       
	
	//ov7670 interface
        output  wire            ov7670_rst              ,       
        output  wire            ov7670_pwdn             ,       
	
	//user	 interface
        output  wire            power_down                   
); 


//--------------------------------
//Funtion :    参数定义
parameter			DELAY_5MS		=		250_000		,
					DELAY_3MS		=		150_000		;

reg		[24:0]			cnt_5ms							;
reg		[24:0]			cnt_3ms							;
										

//--------------------------------
//Funtion :    delay 5ms

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_5ms <= 1'd0;
	else if(cnt_5ms <= DELAY_5MS - 1'b1)
		cnt_5ms <= cnt_5ms + 1'd1;
end

//--------------------------------
//Funtion :    delay 3ms

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_3ms <= 1'd0;
	else if(ov7670_rst && cnt_3ms <= DELAY_3MS - 1'b1)
		cnt_3ms <= cnt_3ms + 1'b1;
end

       
//--------------------------------
//Funtion :    ov7670

assign		ov7670_rst =	(cnt_5ms <= DELAY_5MS - 1'b1) ? 1'b0 : 1'b1;
assign		ov7670_pwdn	=	1'b0;
assign		power_down	=	(cnt_3ms <= DELAY_3MS - 1'b1) ? 1'b0 : 1'b1;





endmodule
