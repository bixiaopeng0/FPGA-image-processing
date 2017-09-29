 /*-----------------------------------------------------------------------
* Date      :       2017/9/16 16:24:24  
* Version       :       1.0
* Description   :       Design for.
    * --------------------------------------------------------------------*/

module  ov7670_data
(
    //clk interface
        input                   clk                     ,       
        input                   rst_n                   ,       
    //ov7670 interface
        input                   ov7670_pclk             ,      
        input                   ov7670_href             ,      
        input                   ov7670_vsync            ,      
        input           [7:0]   ov7670_data             ,
        output  wire            ov7670_xclk             ,       
    //user  interface
        output  reg     [15:0]  ov7670_data_out         ,
        input                   clk_24m                 ,
		input					flag_ye_end				,
		output	reg				ov7670_data_value		,
		output	wire			vsync_pos				,
	//debug
		output	reg		[ 9:0]	cnt_x					,
		output	reg		[ 9:0]	cnt_y					
);

//--------------------------------
////Funtion : define 
wire                            vsync_neg                       ;            
wire                            href_pos                        ;    
wire							frame_value						;
       
reg                             cnt_byte                        ;       
reg         [ 2:0]              vsync_array                     ;
reg         [ 2:0]              href_array                      ;     
reg								data_value						;    
reg			[ 3:0]				frame_cnt						;
reg								data_busy						;

//--------------------------------
////Funtion : two buffer

always @(posedge ov7670_pclk or negedge rst_n)
begin
    if(!rst_n)
        vsync_array <= 1'd0;
    else
        vsync_array <= { vsync_array[1:0] , ov7670_vsync};
end

always @(posedge ov7670_pclk or negedge rst_n)
begin
    if(!rst_n)
        href_array <= 1'd0;
    else
        href_array <= { href_array[1:0] , ov7670_href};
end
 
//--------------------------------
////Funtion : data busy
 
always @(posedge ov7670_pclk or negedge rst_n)
begin
    if(!rst_n)
        data_busy <= 1'd0;
    else if(vsync_neg)
        data_busy <= 1'd1;
    else if(vsync_pos)
        data_busy <= 1'd0;
end


//--------------------------------
////Funtion : cnt_byte

always @(posedge ov7670_pclk or negedge rst_n)
begin
    if(!rst_n)
        cnt_byte <= 1'd0;
    else if(ov7670_href)
        cnt_byte <= cnt_byte + 1'b1;
    else
        cnt_byte <= 1'd0;
end


//--------------------------------
////Funtion :  {first_byte , second_byte}

always @(posedge ov7670_pclk or negedge rst_n)
begin
    if(!rst_n)
        ov7670_data_out <= 1'd0;
    else if(cnt_byte == 1'b1)
        ov7670_data_out <= {ov7670_data_out[15:8] , ov7670_data};
	else 
		ov7670_data_out <= {ov7670_data , 8'd0};
end


//--------------------------------
////Funtion :  frame_cnt

always @(posedge ov7670_pclk or negedge rst_n)
begin
	if(!rst_n)
		frame_cnt <= 1'd0;
	else if(frame_value == 1'b0 && vsync_pos == 1'b1)
		frame_cnt <= frame_cnt + 1'd1;
end


//--------------------------------
////Funtion :  ov7670_data_value

always @(posedge ov7670_pclk or negedge rst_n)
begin
	if(!rst_n)
		ov7670_data_value <= 1'd0;
	else if(cnt_byte == 1'b1 && frame_value)
		ov7670_data_value <= 1'd1;
	else	
		ov7670_data_value <= 1'd0;
end

//--------------------------------
////Funtion :  debug

always @(posedge ov7670_pclk or negedge rst_n)
begin
	if(!rst_n)
		cnt_x <= 1'd0;
	else if(cnt_byte)
		cnt_x <= cnt_x + 1'd1;
	else if(!ov7670_href)
		cnt_x <= 1'd0;
end

always @(posedge ov7670_pclk or negedge rst_n)
begin
	if(!rst_n)
		cnt_y <= 1'd0;
	else if(vsync_pos)
		cnt_y <= 1'd0;
	else if(href_pos)
		cnt_y <= cnt_y + 1'b1;
end




assign  vsync_neg = vsync_array[2] & !vsync_array[1] ;
assign  vsync_pos = !vsync_array[2] & vsync_array[1] ;

assign  href_pos  = !href_array[2] & href_array[1];
assign	frame_value = (frame_cnt > 4'd10) ? 1'b1 : 1'b0;
assign  ov7670_xclk = clk_24m;

endmodule



