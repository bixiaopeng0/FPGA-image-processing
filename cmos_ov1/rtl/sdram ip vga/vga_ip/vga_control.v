module	vga_control
(
    	input			    	clk                     ,
    	input			    	rst_n                   ,
    	input		[10:0]	    value_x                 ,
    	input		[10:0]  	value_y                 ,
       	output	reg	[23:0]	    rgb                     ,

        //rd_fifo   interface
        input       [15:0]      rd_q                    ,
        output  reg             vga_display_value       ,
		output	reg				vga_done		
);


//--------------------------------
////Funtion : define 

localparam          X_CNT       =       10'd640         ;
localparam          Y_CNT       =       10'd480         ;



//--------------------------------
////Funtion : vga_value   640X480

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        vga_display_value <= 1'd0;
    else if(((value_x >= 50 && value_x <= X_CNT + 49) && (value_y >= 1 && value_y <= Y_CNT)))
        vga_display_value <= 1'd1;
    else
        vga_display_value <= 1'd0;
end


//--------------------------------
////Funtion : rgb   rgb565  ---  rgb888

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rgb <= 1'd0;
    else if((value_x >= 51 && value_x <= X_CNT + 50) && (value_y >= 1 && value_y <= Y_CNT))
        rgb <= {rd_q[15:11] , rd_q[13:11] , rd_q[10:5] , rd_q[6:5] , rd_q[4:0] , rd_q[2:0]};
    else
        rgb <= 1'd0;
end

//--------------------------------
////Funtion : vga_done

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)	
		vga_done <= 1'd0;
	else if((value_x == X_CNT + 51) && (value_y == Y_CNT + 1))
		vga_done <= 1'd1;
	else
		vga_done <= 1'd0;
end



		
endmodule

	
