/*-----------------------------------------------------------------------

Date				:		2017-08-29
Description			:		Design for sdram_top.

-----------------------------------------------------------------------*/

module sdram_top
(
	//global clock
	input					clk							,			//system clock
	input					rst_n						,     		//sync reset
	input					clk_24m						,
	input					clk_40m						,
	input					clk_100m					,
	
	//sdram interface
	output					sdram_clk					,
	output					sdram_cke					,		//时钟使能
	output					sdram_cs_n					,		//控制信号之一
	output					sdram_cas_n					,		//同上
	output					sdram_ras_n					,		//
	output					sdram_we_n					,		//
	output			[1:0]	sdram_bank					,		//bank地址
	output			[12:0]	sdram_addr					,		//行列地址
	output			[1:0]	sdram_dqm					,		//数据使能
	inout			[15:0]	sdram_dq					,		//数据

	//fifo interface

	input					wr_fifo_write_en			,
	input			[15:0]	wr_data						, 
	output			[15:0]	rd_q						,
	input					vga_display_value			,
	
	output					vga_init_value				,
	input					vga_done					,
	input					vsync_pos
	
); 


//--------------------------------
//Funtion :   init            
wire		[3:0]		init_cmd				;
wire		[12:0]		init_addr				;
wire					flag_init_end			;

wire					ref_en					;
wire					ref_req					;
wire					flag_ref_end			;
wire		[3:0]		aref_cmd				;
wire		[12:0]		aref_addr				;
wire		[1:0]		aref_bank				;

wire					rd_trig					;
wire					wr_trig					;
	
wire					wr_en					;
wire					wr_req					;
wire					flag_wr_end				;
//wire					wr_trig					;
wire					flag_rd_end				;
wire		[3:0]		wr_cmd					;
wire		[12:0]		wr_addr					;
wire		[15:0]		wr_q					;
wire		[15:0]		wr_dq					;
wire		[4:0]		state					;
	
wire					rd_req					;

wire					rd_en					;
wire		[3:0]		rd_cmd					;
wire		[12:0]		rd_addr					;
wire		[15:0]		rd_dq					;


wire					wr_fifo_read_en			;
wire					rd_fifo_wr_en			;
wire					sdram_wdata_value		;
wire					sdram_rd_data_value		;
wire					wr_clear				;
//wire					rd_usedw_en				;
sdram_init	init_u1
(
	//global clock
	.clk             (clk	             ),			//system clock
	.rst_n           (rst_n              ),     	//sync reset
	
	//sdram_init interface
	.init_cmd        (init_cmd           ),			//sdram 命令寄存器
	.init_addr       (init_addr          ),			//地址线
	.flag_init_end   (flag_init_end      )			//sdram初始化标志
	
); 

//--------------------------------
//Funtion :   init    

sdram_afreh		afreh_u2
(
	//global clock
	.clk             (clk                ),				//system clock
	.rst_n           (rst_n              ),     		//sync reset
	
	//init		interface
	.flag_init_end   (flag_init_end      ),
	
	//auto_freh interface
	.ref_en          (ref_en             ),
	.ref_req         (ref_req            ),
	.flag_ref_end    (flag_ref_end       ),
	
	//sdram		interface
	.aref_cmd        (aref_cmd           ),
	.aref_addr       (aref_addr          )
	
); 
//--------------------------------
//Funtion :   write

sdram_write	write_u3
(
	//global clock
	.clk			(clk_100m   		),			//system clock
	.rst_n			(rst_n				),     		//sync reset
	
	//sdram_write interface
	.wr_en			(wr_en				),			//写使能
	.wr_req			(wr_req				),			//写请求
	.wr_trig		(wr_trig			),			//写触发

	//sdram interface
	.wr_cmd			(wr_cmd				),
	.wr_addr		(wr_addr			),
	.wr_q			(wr_q				),
	.wr_dq			(wr_dq				),
	//afresh interface
	//input					ref_req  
	.state			(state				),
	.sdram_wdata_value(sdram_wdata_value),
	.vsync_pos		(vsync_pos			),
	.wr_clear		(wr_clear			),
	.flag_wr_end	(flag_wr_end		)
);


//--------------------------------
//Funtion :   read


sdram_read	read_u4
(
	//global clock
	.clk			(clk_100m   		),			//system clock
	.rst_n			(rst_n				),     		//sync reset
	
	//read interface
	.rd_req			(rd_req				),   		//读请求
	.rd_en			(rd_en				),
	
	//sdram	interface
	.rd_cmd			(rd_cmd				),
	.rd_addr		(rd_addr			),
	.rd_dq			(rd_dq			 	),			//read sdram data
	.sdram_dq		(sdram_dq			),
	.state			(state				),
	.sdram_rd_data_value(sdram_rd_data_value),
	.vga_done		(vga_done			),
	.rd_trig		(rd_trig			),
	.flag_rd_end	(flag_rd_end		)
	
	
); 

//--------------------------------
//Funtion :   仲裁模块


sdram_manage	manage_u5
(
	//global clock
	.clk			(clk_100m			),			//system clock
	.rst_n			(rst_n				),     		//sync reset
	
	//sdram interface
	.sdram_clk		(sdram_clk			),
	.sdram_cke		(sdram_cke			),
	.sdram_cas_n	(sdram_cas_n		),
	.sdram_cs_n		(sdram_cs_n			),
	.sdram_dqm		(sdram_dqm			),
	.sdram_bank		(sdram_bank			),
	.sdram_ras_n	(sdram_ras_n		),
	.sdram_we_n		(sdram_we_n			),
	.sdram_addr		(sdram_addr			),
	.sdram_dq		(sdram_dq			),

	//afresh interface
	.ref_req		(ref_req			),
	.ref_en			(ref_en				) ,
	.flag_ref_end	(flag_ref_end		),
	.aref_cmd		(aref_cmd			),
	.aref_addr		(aref_addr			),
//	.	aref_bank(aref_bank),
	
	//init	interface	
	.init_cmd		(init_cmd			),
    .init_addr		(init_addr			),
//	.init_bank(init_bank),
	.flag_init_end	(flag_init_end		),
	
	//write	interface
	.wr_en			(wr_en				),
	.wr_req			(wr_req				),
	.flag_wr_end	(flag_wr_end		),
	.wr_cmd			(wr_cmd				),
	.wr_addr		(wr_addr			),
//	.wr_bank(wr_bank),
	.wr_dq			(wr_dq				),
	//.wr_wrig		(wr_trig			),
	
	//read	interface
	.rd_en			(rd_en				),
	.rd_req			(rd_req				),
	.rd_cmd			(rd_cmd				),
	.rd_addr		(rd_addr			),
	.state			(state				),
	.wr_clear		(wr_clear			),
	.flag_rd_end	(flag_rd_end		)
	
	
); 



//--------------------------------
//Funtion : fifo_control

fifo_control	fifo_inst
(
    //clk   interface
	.clk            (clk				),       
	.rst_n          (rst_n				),   
	.clk_24m        (clk_24m			),
	.clk_100m       (clk_100m			),    
    .clk_40m		(clk_40m			),
    //wrfifo interface
    .wrfifo_write_en(wr_fifo_write_en   ),         
    .wrfifo_read_en (sdram_wdata_value	),       
    .wr_trig        (wr_trig			),       
    .wr_data 		(wr_data			),
    .wr_q           (wr_q				),

    //rdfifo interface
    .rd_fifo_wr_en  (sdram_rd_data_value),
    .rd_fifo_rd_en  (vga_display_value	),       
    .rd_trig		(rd_trig			),  
    .rd_data  		(rd_dq				),
    .rd_q			(rd_q				),      
		
	//vga	interface
	.vga_init_value (vga_init_value		),
	.vga_done		(vga_done			),
	.wr_clear		(wr_clear			)

);





endmodule
	
