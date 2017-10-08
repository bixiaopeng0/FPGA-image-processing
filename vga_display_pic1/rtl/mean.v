/*-----------------------------------------------------------------------
* Date          :       2017/10/7 20:30:01 
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  mean
(
        //clk   interface
        input                   clk                     ,       
        input                   rst_n                   ,       
        
        //input data
        input       [ 7:0]      mean_p11 , mean_p12 , mean_p13 ,
        input       [ 7:0]      mean_p21 , mean_p22 , mean_p23 ,
        input       [ 7:0]      mean_p31 , mean_p32 , mean_p33 ,
        input					vga_en					,
        //mean interface
        output      [ 7:0]      mean_data				,
		output					mean_en
);

//--------------------------------
////Funtion : define

wire        [ 7:0]          max_data1		;
wire        [ 7:0]          mid_data1		;
wire        [ 7:0]          min_data1		;

wire        [ 7:0]          max_data2		;
wire        [ 7:0]          mid_data2		;
wire        [ 7:0]          min_data2		;

wire        [ 7:0]          max_data3		;
wire        [ 7:0]          mid_data3		;
wire        [ 7:0]          min_data3		;


wire        [ 7:0]          max_min_data	;
wire        [ 7:0]          mid_mid_data	;
wire        [ 7:0]          min_min_data	;

reg			[ 2:0]			delay_en		;

//--------------------------------
////Funtion : define

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		delay_en <= 1'd0;
	else
		delay_en <= {delay_en[1:0] , vga_en};
end




sort_three	sort_1
(
        //global clk
        .clk  (clk)               		   ,       
        .rst_n(rst_n)               	   ,       

        //input data
        .data_in1(mean_p11)                ,
        .data_in2(mean_p12)                ,
        .data_in3(mean_p13)                ,

        //sort  interface
        .max_data(max_data1)                ,
        .mid_data(mid_data1)                ,
        .min_data(min_data1)            

); 


sort_three	sort_2
(
        //global clk
        .clk  (clk)               		   ,       
        .rst_n(rst_n)               	   ,       

        //input data
        .data_in1(mean_p21)                ,
        .data_in2(mean_p22)                ,
        .data_in3(mean_p23)                ,

        //sort  interface
        .max_data(max_data2)               ,
        .mid_data(mid_data2)               ,
        .min_data(min_data2)            

); 


sort_three	sort_3
(
        //global clk
        .clk  (clk)               		   ,       
        .rst_n(rst_n)               	   ,       

        //input data
        .data_in1(mean_p31)                ,
        .data_in2(mean_p32)                ,
        .data_in3(mean_p33)                ,

        //sort  interface
        .max_data(max_data3)               ,
        .mid_data(mid_data3)               ,
        .min_data(min_data3)            

); 


sort_three	sort_4
(
        //global clk
        .clk  (clk)               		   ,       
        .rst_n(rst_n)               	   ,       

        //input data
        .data_in1(max_data1)                ,
        .data_in2(max_data2)                ,
        .data_in3(max_data3)                ,

        //sort  interface
        .max_data(        )                ,
        .mid_data(		  )                ,
        .min_data(max_min_data)            

); 


sort_three	sort_5
(
        //global clk
        .clk  (clk)               		   ,       
        .rst_n(rst_n)               	   ,       

        //input data
        .data_in1(mid_data1)               ,
        .data_in2(mid_data2)               ,
        .data_in3(mid_data3)               ,

        //sort  interface
        .max_data(		  )                ,
        .mid_data(mid_mid_data)                ,
        .min_data(		  )            

); 


sort_three	sort_6
(
        //global clk
        .clk  (clk)               		   ,       
        .rst_n(rst_n)               	   ,       

        //input data
        .data_in1(min_data1)                ,
        .data_in2(min_data2)                ,
        .data_in3(min_data3)                ,

        //sort  interface
        .max_data(min_min_data)              ,
        .mid_data(        )                ,
        .min_data(	      )            

); 


sort_three	sort_7
(
        //global clk
        .clk  (clk)               		   ,       
        .rst_n(rst_n)               	   ,       

        //input data
        .data_in1(max_min_data)                ,
        .data_in2(mid_mid_data)                ,
        .data_in3(min_min_data)                ,

        //sort  interface
        .max_data(			)                ,
        .mid_data(mean_data )                ,
        .min_data(			)            

); 


assign		mean_en = delay_en[2];


endmodule


