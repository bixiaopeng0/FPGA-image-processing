/*-----------------------------------------------------------------------
* Date          :       2017/10/7 19:13:03
* Version       :       1.0
* Description   :       Design for 3X3 matrix.
* --------------------------------------------------------------------*/

module  matrix_3X3
(       
        //global    clk
        input                   clk                     ,       
        input                   rst_n                   ,
        //data_in   interface
        input          [ 7:0]   data_in                 ,
		input					clken					,
        //user      interface 
        output  reg    [ 7:0]   matrix_p11 , matrix_p12 , matrix_p13 ,
        output  reg    [ 7:0]   matrix_p21 , matrix_p22 , matrix_p23 ,
        output  reg    [ 7:0]   matrix_p31 , matrix_p32 , matrix_p33 
);

//--------------------------------
////Funtion : define 

wire		[ 7:0]		taps0x		;
wire		[ 7:0]		taps1x		;



//--------------------------------
////Funtion : shift

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		matrix_p11 <= 1'd0;
		matrix_p12 <= 1'd0;
		matrix_p13 <= 1'd0;
		matrix_p21 <= 1'd0;
		matrix_p22 <= 1'd0;
		matrix_p23 <= 1'd0;
		matrix_p31 <= 1'd0;
		matrix_p32 <= 1'd0;
		matrix_p33 <= 1'd0;
	end
	else if(clken)
	begin
		{matrix_p11 , matrix_p12 , matrix_p13} <= {matrix_p12 , matrix_p13 , taps1x};
		{matrix_p21 , matrix_p22 , matrix_p23} <= {matrix_p22 , matrix_p23 , taps0x};
		{matrix_p31 , matrix_p32 , matrix_p33} <= {matrix_p32 , matrix_p33 , data_in};
	end
end



//--------------------------------
////Funtion : shift_ram ip

shift_three shift_inst
(
	.clock			(clk		),
	.clken			(clken		),
	.shiftin		(data_in	),
	.shiftout		(			),
	.taps0x			(taps0x		),
	.taps1x         (taps1x		)
);




endmodule



