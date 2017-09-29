/*-----------------------------------------------------------------------
* Date      :       2017/9/20 12:55:50  
* Version       :       1.0
* Description   :       Design for.
* --------------------------------------------------------------------*/

module  fifo_control
(
    //clk   interface
        input                   clk                     ,       
        input                   rst_n                   ,   
        input                   clk_24m                 ,
		input					clk_40m					,
        input                   clk_100m                ,    
   
    //wrfifo interface
        input                   wrfifo_write_en         ,            
        input                   wrfifo_read_en          ,       
        output  reg             wr_trig                 ,       
        input   wire    [15:0]  wr_data                 ,
        output  wire    [15:0]  wr_q                    ,

    //rdfifo interface
        input                   rd_fifo_wr_en           ,
        input                   rd_fifo_rd_en           ,       
        output  reg             rd_trig                 ,  
        input   wire    [15:0]  rd_data                 ,
        output  wire    [15:0]  rd_q                    ,    

	//vga	interface
		output	reg				vga_init_value			,
		input					vga_done				,
		input					wr_clear				,
	//debug
		output	reg				rdusedw_flag			

);


//--------------------------------
////Funtion : define

localparam    USE_MAX       =       8'd150                      ;  
localparam	  USE_MIN		=		8'd100						;
//fifo write sdram
wire                            wr_rdclk                        ;       
wire                            wr_wrclk                        ;      
wire        [10:0]              wr_wruse                        ;
wire                            wr_rdeq                         ;       
wire                            wr_wreq                         ;       

//fifo read sdram
wire                            rd_rdclk                        ;       
wire                            rd_wrclk                        ;       
wire         [10:0]             rd_rduse                        ;
wire                            rd_rdeq                         ;       
wire                            rd_wreq                         ;       

//--------------------------------
////Funtion read and write trig

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		wr_trig <= 1'd0;
		rd_trig <= 1'd0;
	end
	else if(wr_wruse < 300)	//read
	begin
		wr_trig <= 1'd0;
		rd_trig <= 1'd1;
	end
	else if(rd_rduse > 500)//write_fifo
	begin
		wr_trig <= 1'd1;
		rd_trig <= 1'd0;
	end
	else if(wr_wruse < 800)
	begin
		wr_trig <= 1'd0;
		rd_trig <= 1'd1;
	end
	else if(rd_rduse > 300 )
	begin
		wr_trig <= 1'd1;
		rd_trig <= 1'd0;
	end
	else 
	begin
		wr_trig <= 1'd0;
		rd_trig <= 1'd0;
	end
end 


//--------------------------------
////Funtion : vga_init_value

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_init_value <= 1'd0;
	else if(wr_wruse > 500)
		vga_init_value <= 1'd1;
end

//--------------------------------
////Funtion : debug

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rdusedw_flag <= 1'd0;
	else if(rd_rduse > 2000)
		rdusedw_flag <= 1'd1;
end


//--------------------------------
////Funtion : fifodata


fifo_1024_16 	wr_sdram_inst
(
	.data		(wr_data		),
	.rdclk		(wr_rdclk		),
	.rdreq		(wr_rdeq		),
	.wrclk		(wr_wrclk		),
	.wrreq		(wr_wreq		),
	.q			(wr_q			),
	.rdusedw	(rd_rduse		),
	.wrusedw    (				),
    .aclr       (!rst_n || wr_clear )           //高电平复位
);



fifo_1024_16 	rd_sdram_inst
(
	.data 		(rd_data		),
	.rdclk		(rd_rdclk		),
	.rdreq		(rd_rdeq		),
	.wrclk		(rd_wrclk		),
	.wrreq		(rd_wreq		),
	.q			(rd_q			),
	.rdusedw	(				),
	.wrusedw    (wr_wruse	    ),
    .aclr       (!rst_n || vga_done )
);

//--------------------------------
////Funtion : 

assign      wr_wreq = wrfifo_write_en;
assign      wr_rdeq = wrfifo_read_en;

assign      rd_wreq = rd_fifo_wr_en;
assign      rd_rdeq = rd_fifo_rd_en;


assign      wr_wrclk = clk_24m;
assign      wr_rdclk = clk_100m;

assign      rd_wrclk = clk_100m;
assign      rd_rdclk = clk_40m;


endmodule


