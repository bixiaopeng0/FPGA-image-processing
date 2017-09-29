/*-----------------------------------------------------------------------
Date        :       2017/9/8 20:38:52 
Version     :       1.0
Description :       Design for ov7670 top design.
    --------------------------------------------------------------------*/

module  ov7670_top
(
        //clk   interface
        input                   clk                     ,
        input                   rst_n                   ,       
        input   wire            clk_24m                 ,   //ov7670 clk       
        //ov7670  interface
        input                   ov7670_pclk             ,      
        input                   ov7670_href             ,      
        input                   ov7670_vsync            ,      
        input           [7:0]   ov7670_data             ,
		output  wire            ov7670_pwdn             ,       
        output  wire            ov7670_rst_n            ,  
        output  wire            ov7670_xclk             ,       
        output  wire            ov7670_iic_scl          ,       
        inout                   ov7670_iic_sda          ,       
        output  wire    [15:0]  ov7670_data_out         ,

		//user	interface
        output  wire            ov7670_data_value       ,
		output	wire			vsync_pos	

);

//--------------------------------
//Funtion : define  register

wire                            power_down                      ;       
 
reg     [2:0]                   pos_arr                         ;       
wire                            start                           ;   

wire							busy							;  
wire    [15:0]                  cfg_array                       ; 
wire                            cfg_done                        ;       
 
//debug

wire							wd_rd_en						;
wire	[15:0]					read_addr						;


//--------------------------------
//Funtion : 0v7670 power crtl


 power_ctrl power_ctrl_inst
(
	//global clock
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
	
	//ov7670 interface
        .ov7670_rst	            (ov7670_rst_n           ),
        .ov7670_pwdn            (ov7670_pwdn            ),
	
	//user	 interface
        .power_down             (power_down             )
) ;



//--------------------------------
//Funtion : ov7670_iic

ov7670_iic  iic_inst
(
        // clk  interface
        .clk                    (clk	                ),      //max 100k
        .rst_n                  (rst_n & power_down     ),

        //IIC   interface
        .iic_clk                (ov7670_iic_scl         ),
        .iic_sda                (ov7670_iic_sda         ),

       //user   interface
        .start                  (start                  ),
        .wdata                  ({8'h42 , cfg_array}    ),
        .riic_data              (riic_data              ),
        .busy                   (busy                   ),
		.wd_rd_en				(wd_rd_en				),
		.read_addr				(read_addr 				)

);

//--------------------------------
//Funtion : ov7670_cfg
ov7670_cfg	cfg_inst
(
        //global    clk
        .clk                    (clk                    ),
        .rst_n                  (rst_n & power_down     ),
        //IIC interface
        .cfg_data               (cfg_array              ),
		//user interface
		.busy					(busy					),
		.start  				(start                  ),
		.cfg_done				(cfg_done               )		
);

//--------------------------------
//Funtion : ov7670_data

 ov7670_data	data_inst
(
    //clk interface
        .clk                    (clk                    ),
        .rst_n                  (rst_n & power_down     ),
    //ov7670 interface
        .ov7670_pclk            (ov7670_pclk            ),
        .ov7670_href            (ov7670_href            ),
        .ov7670_vsync           (ov7670_vsync           ),
        .ov7670_data            (ov7670_data            ),
        .ov7670_xclk            (ov7670_xclk            ),
    //user  interface
        .ov7670_data_out        (ov7670_data_out        ),
        .clk_24m                (clk_24m                ),
        .ov7670_data_value      (ov7670_data_value      ),
		.vsync_pos				(vsync_pos				)
);



//--------------------------------
//Funtion : debug



debug 	debug_inst1
(
	.probe			(riic_data			),
	.source			(wd_rd_en			)	
);

debug1 debug_inst2
(
	.probe			(					),
	.source			(read_addr			)
);



endmodule


