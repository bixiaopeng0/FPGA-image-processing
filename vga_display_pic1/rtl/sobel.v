/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for sobel.

-----------------------------------------------------------------------*/

module sobel
(
	//global clock
	input					clk					,			//system clock
	input					rst_n				,     		//sync reset
	
	
	//sobel	interface
	output			[10:0]	sobel_data			,
	
	//matrix	 interface
    input		    [ 7:0]   matrix_p11 , matrix_p12 , matrix_p13 ,
    input		    [ 7:0]   matrix_p21 , matrix_p22 , matrix_p23 ,
    input		    [ 7:0]   matrix_p31 , matrix_p32 , matrix_p33 ,

	//en
	input					mean_en				,
	output					display_val		
	
); 


//--------------------------------
//Funtion :  变量声明



reg			[9:0]		gx_temp1											;
reg			[9:0]		gx_temp2											;
reg			[9:0]		gx_data												;

reg			[9:0]		gy_temp1											;
reg			[9:0]		gy_temp2											;
reg			[9:0]		gy_data;             

reg			[20:0]		gxy_square											;
reg			[ 4:0]		delay_en											;

//--------------------------------
//Funtion :  计算Gx Gy

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		gx_temp1 <= 1'd0;
		gx_temp2 <= 1'd0;
		gx_data	 <= 1'd0;
	end
	else
	begin
		gx_temp1 <= matrix_p31 + (matrix_p32 << 1) + matrix_p33;
		gx_temp2 <= matrix_p11 + (matrix_p12 << 1) + matrix_p13;
		gx_data  <= (gx_temp1 >= gx_temp2) ? gx_temp1 - gx_temp2 : gx_temp2 - gx_temp1;
	end
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		gy_temp1 <= 1'd0;
		gy_temp2 <= 1'd0;
		gy_data	 <= 1'd0;
	end
	else
	begin
		gy_temp1 <= matrix_p11 + (matrix_p21 << 1) + matrix_p31;
		gy_temp2 <= matrix_p13 + (matrix_p23 << 1) + matrix_p33;
		gy_data  <= (gy_temp1 >= gy_temp2) ? gy_temp1 - gy_temp2 : gy_temp2 - gy_temp1;
	end
end

//--------------------------------
//Funtion :  gx^2 + gy^2

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		gxy_square <= 1'd0;
	else
		gxy_square <= gx_data * gx_data + gy_data * gy_data;
end


//--------------------------------
//Funtion :  sqrt

sqrt_sobel sqrt_inst(
	.radical(gxy_square),
	.q(sobel_data)
	//remainder
	);

//--------------------------------
//Funtion :  delay_en

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		delay_en <= 1'd0;
	else
		delay_en <= {delay_en[3:0] , mean_en};
end

assign	display_val = delay_en[4];


endmodule
	
