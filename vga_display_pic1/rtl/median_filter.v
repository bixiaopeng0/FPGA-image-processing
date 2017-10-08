/*-----------------------------------------------------------------------
* Date          :       2017/10/5 20:33:40  
* Version       :       1.0
* Description   :       Design for median_filter.
* --------------------------------------------------------------------*/


module median_filter 
(
        //global    clk
        input                   clk                     ,       
        input                   rst_n                   ,

        //input     data
        input       [ 7:0]      data_in                 ,

        //median    interface
        output  reg [ 7:0]      median_data

);

//--------------------------------
////Funtion : register define

reg			[7:0]		matrix_p11 , matrix_p12 , matrix_p13				;
reg			[7:0]		matrix_p21 , matrix_p22 , matrix_p23				;
reg			[7:0]		matrix_p31 , matrix_p32 , matrix_p33				;



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
	else
	begin
		matrix_p11 <= data_in;
		matrix_p12 <= matrix_p11;
		matrix_p13 <= matrix_p12;
		matrix_p21 <= matrix_p13;
		matrix_p22 <= matrix_p21;
		matrix_p23 <= matrix_p22;
		matrix_p31 <= matrix_p23;
		matrix_p32 <= matrix_p31;
		matrix_p33 <= matrix_p32;	
	end
end








endmodule



