/*-----------------------------------------------------------------------
* Date          :       2017/9/21 8:55:13  
* Version       :       1.0
* Description   :       Design for.
    * --------------------------------------------------------------------*/

module  vga_top
(
        //clk       interface
        input                   clk                     ,       
        input                   rst_n                   ,       
        //vga       interface
        output  wire            vga_clk                 ,       
        output  wire    [ 7:0]  vga_b                   ,
        output  wire    [ 7:0]  vga_g                   ,
        output  wire    [ 7:0]  vga_r                   ,
        output  wire            vga_blank               ,       
        output  wire            vga_sync                , 
        output  wire            vga_hs                  ,       
        output  wire            vga_vs                  ,       

        //rdfifo    interface
        output  wire            vga_display_value       ,       
        input   wire    [15:0]  rd_q    				,
	
		//user		interface
		output	wire			vga_done					
);	

//--------------------------------
////Funtion : define

//wire                            vga_display_value               ;       
wire        [10:0]              value_x                         ;
wire        [10:0]              value_y                         ;
wire		[23:0]				rgb								;




vga_qudong		qudong_inst(
	//global clock
	.clk				(clk				),			//system clock
	.rst_n				(rst_n				),     		//sync reset
	.rgb				(rgb				),
	.vga_clk			(vga_clk			),
	.vga_b				(vga_b				),
	.vga_g				(vga_g				),
	.vga_r				(vga_r				),
	.vga_blank			(vga_blank			),
	.vga_sync			(vga_sync			),
	.vga_hs				(vga_hs				),
	.vga_vs				(vga_vs				),
	.value_x			(value_x			),
	.value_y    		(value_y			)
);

vga_control		vga_control_inst
(
	.clk         		(clk				),
	.rst_n       		(rst_n				),
	.value_x     		(value_x			),
	.value_y     		(value_y			),
	.rgb         		(rgb				),

       
    .rd_q         		(rd_q				),
    .vga_display_value  (vga_display_value	),
	.vga_done			(vga_done			)
);



endmodule



