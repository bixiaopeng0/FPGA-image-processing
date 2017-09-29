/*-----------------------------------------------------------------------
* Date     	    :       2017/9/9 19:05:48  
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  top
(
        //clk   interface
        input                   clk                     ,
        input                   rst_n                   ,       
        //0v7670  interface
        output  wire            ov7670_pwdn             ,       
        output  wire            ov7670_rst_n            ,  
        output  wire            ov7670_xclk             ,       
        output  wire            ov7670_iic_scl          ,       
        inout                   ov7670_iic_sda          ,
		input					ov7670_pclk				,
		input					ov7670_href				,
		input					ov7670_vsync			,
		input			[7:0]	ov7670_data				,

        //vga   interface
        output  wire            vga_clk                 ,       
        output  wire    [ 7:0]  vga_b                   ,
        output  wire    [ 7:0]  vga_g                   ,
        output  wire    [ 7:0]  vga_r                   ,
        output  wire            vga_blank               ,       
        output  wire            vga_sync                , 
        output  wire            vga_hs                  ,       
        output  wire            vga_vs                  ,  

    	//sdram interface
    	output					sdram_clk               ,
    	output					sdram_cke               ,		//时钟使能
    	output					sdram_cs_n              ,		//控制信号之一
    	output					sdram_cas_n             ,	    //同上
    	output					sdram_ras_n             ,	    //
    	output					sdram_we_n              ,		//
    	output			[1:0]	sdram_bank              ,		//bank地址
    	output			[12:0]	sdram_addr              ,		//行列地址
    	output			[1:0]	sdram_dqm               ,		//数据使能
    	inout			[15:0]	sdram_dq	                	//数据
        
);


//--------------------------------
////Funtion : define   

//system_crtl
wire                            clk_24m                         ;  
wire							clk_40m							;
wire							clk_100m						;
wire							sys_rst_n						;     

//vga define
wire                            vga_display_value               ;       
wire    [15:0]                  rd_q                            ;
wire    [15:0]                  ov7670_data_out                 ;
wire							ov7670_data_value				;

wire							vga_init_value					;
wire							vga_done						;
wire							vsync_pos						;
//--------------------------------
////Funtion : System crtl

 system_crtl	sys_inst
(
		//clk interface
        .clk                     (clk					),       
        .rst_n                   (rst_n					),       
                                 
        //global interface       ()
        .clk_24                  (clk_24m				),       
        .clk_40                  (clk_40m				),      
		.clk_100				 (clk_100m				),
        .sys_rst_n               (sys_rst_n				)           
);


//--------------------------------
////Funtion : ov_7670_top

ov7670_top  ov7670_inst
(
        //clk   interface
        .clk                    (clk                    ),
        .rst_n                  (sys_rst_n              ),
        .clk_24m                (clk_24m                ),
        //0v7670  interface
        .ov7670_pwdn            (ov7670_pwdn            ),
        .ov7670_rst_n           (ov7670_rst_n           ),
        .ov7670_xclk            (ov7670_xclk            ),
        .ov7670_iic_scl         (ov7670_iic_scl         ),
        .ov7670_iic_sda         (ov7670_iic_sda         ),
        .ov7670_pclk			(ov7670_pclk			),      
        .ov7670_href            (ov7670_href			),      
        .ov7670_vsync           (ov7670_vsync			),      
        .ov7670_data            (ov7670_data			),
        .ov7670_data_out        (ov7670_data_out        ),
        .ov7670_data_value      (ov7670_data_value      ),
		.vsync_pos				(vsync_pos				)
);

//--------------------------------
////Funtion : vga_top

vga_top vga_inst
(
        //clk       interface
        .clk                    (clk_40m	             ),
        .rst_n                  (sys_rst_n&vga_init_value),
        //vga       interface
        .vga_clk                (vga_clk                ),
        .vga_b                  (vga_b                  ),
        .vga_g                  (vga_g                  ),
        .vga_r                  (vga_r                  ),
        .vga_blank              (vga_blank              ),
        .vga_sync               (vga_sync               ),
        .vga_hs                 (vga_hs                 ),
        .vga_vs                 (vga_vs                 ),
        
        //rdfifo    interface
        .vga_display_value      (vga_display_value      ),
        .rd_q                   (rd_q                   ),
		.vga_done				(vga_done				)
);



//--------------------------------
////Funtion : pll
 sdram_top      sdram_inst
(
	//global clock
		.clk					(clk					),			//system clock
		.rst_n					(sys_rst_n				),     		//sync reset
		.clk_24m				(ov7670_pclk			),
		.clk_40m				(clk_40m				),
		.clk_100m				(clk_100m				),
	                           
	//sdram interface           ()
		.sdram_clk				(sdram_clk				),
		.sdram_cke				(sdram_cke				),		//时钟使能
		.sdram_cs_n				(sdram_cs_n				),		//控制信号之一
		.sdram_cas_n			(sdram_cas_n			),		//同上
		.sdram_ras_n			(sdram_ras_n			),			//
		.sdram_we_n				(sdram_we_n				),		//
		.sdram_bank				(sdram_bank				),		//bank地址
		.sdram_addr				(sdram_addr				),		//行列地址
		.sdram_dqm				(sdram_dqm				),		//数据使能
		.sdram_dq				(sdram_dq				),		//数据
		.wr_fifo_write_en		(ov7670_data_value	    ),
        .wr_data				(ov7670_data_out        ), 
		.rd_q					(rd_q					),
		.vga_display_value		(vga_display_value		),
		.vga_init_value			(vga_init_value			),
		.vga_done				(vga_done				),
		.vsync_pos				(vsync_pos				)
	//user interface

	
); 





endmodule





