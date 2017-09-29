/*-----------------------------------------------------------------------

Date				:		2017-08-29
Description			:		Design for sdram_manage .

-----------------------------------------------------------------------*/

module sdram_manage
(
	//global clock
	input					clk					,			//system clock
	input					rst_n				,     		//sync reset
	
	//sdram interface
	output					sdram_clk			,
	output					sdram_cke			,
	output					sdram_cas_n			,
	output					sdram_cs_n			,
	output			[1:0]	sdram_dqm			,
	output			[1:0]	sdram_bank			,
	output					sdram_ras_n			,
	output					sdram_we_n			,
	output	reg		[12:0]	sdram_addr			,
	inout			[15:0]	sdram_dq			,

	//afresh interface
	input					ref_req				,
	output	reg				ref_en 				,
	input					flag_ref_end		,
	input			[3:0]	aref_cmd			,
	input			[12:0]	aref_addr			,
	
	//init	interface	
	input			[3:0]	init_cmd			,
    input			[12:0]	init_addr			,
	input					flag_init_end		,
	
	//write	interface
	output	reg				wr_en				,
	input					wr_req				,
	input					flag_wr_end			,
	input			[3:0]	wr_cmd				,
	input			[12:0]	wr_addr				,
	input			[15:0]	wr_dq				,
	
	//read	interface
	output	reg				rd_en				,
	input					rd_req				,
	input					flag_rd_end			,
	input			[3:0]	rd_cmd				,
	input			[12:0]	rd_addr				,
	output	reg		[4:0]	state				,
	input			[1:0]	sdram_bank_addr		,
	input					wr_clear
	
	
); 


//--------------------------------
//Funtion :   参数定义
localparam      IDLE            =       5'b0_0001			;
localparam      ARBIT           =       5'b0_0010			;
localparam      AREF            =       5'b0_0100			;
localparam      WRITE           =       5'b0_1000			;
localparam      READ            =       5'b1_0000			;

parameter		DELAY_10US		=		10'd1000			;
reg				[3:0]			cmd_reg						;


//--------------------------------
//Funtion wr_en

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_en <= 1'b0;
	else if(state == ARBIT && ref_req == 1'b0 && wr_req)
		wr_en <= 1'b1;
	else
		wr_en <= 1'b0;
end


//--------------------------------
//Funtion ref_en

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		ref_en <= 1'b0;
	else if(state == ARBIT && ref_req)
		ref_en <= 1'b1;
	else
		ref_en <= 1'b0;
end

//--------------------------------
//Funtion rd_en		优先级 刷新 > 写请求 > 读请求

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_en <= 1'b0;
	else if(state == ARBIT && ref_req == 1'b0  && rd_req == 1'b1 && wr_req == 1'b0)
		rd_en <= 1'b1;
	else
		rd_en <= 1'b0;
end



//--------------------------------
//Funtion :	仲裁状态机

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state <= IDLE;
	else
		case(state)
			
			IDLE :
			begin
				if(flag_init_end)
					state <= ARBIT;
				else
					state <= IDLE;
			end
			//仲裁
			ARBIT :
			begin
				if(ref_en)
					state <= AREF;
				else if(wr_en)
					state <= WRITE;
				else if(rd_en)
					state <= READ;
				else
					state <= ARBIT;
			end
			//刷新
			AREF :
			begin
				if(flag_ref_end)
					state <= ARBIT;
				else
					state <= AREF;
			end
			//write
			WRITE :
			begin
				if(flag_wr_end || wr_clear)//when fifo is empty can not write
					state <= ARBIT;
				else
					state <= WRITE;
			end
			//read
			READ :
			begin
				if(flag_rd_end)
					state <= ARBIT;
				else
					state <= READ;
			end
			
			default :
				state <= IDLE;
		endcase
end


//--------------------------------
//Funtion :	cmd addr 组合逻辑不会有延时

always @(*)
begin
	case(state)
		IDLE :
		begin
			cmd_reg    = init_cmd;
			sdram_addr = init_addr;
		end
		
		AREF :
		begin
			cmd_reg    = aref_cmd;
			sdram_addr = aref_addr;
		end
		
		WRITE :
		begin
			cmd_reg	   = wr_cmd;
			sdram_addr = wr_addr;
		end
		
		READ  :
		begin
			cmd_reg    = rd_cmd;
			sdram_addr = rd_addr;
		end
		
		default :
		begin
			cmd_reg    = 4'b0111;
			sdram_addr = 1'd0;
		end
		
	endcase
end




//--------------------------------
//Funtion :	others


assign					sdram_clk = ~clk;
assign					sdram_cke = 1'b1;
assign					sdram_dqm = 2'd0;
assign					{sdram_cs_n , sdram_ras_n , sdram_cas_n , sdram_we_n} = cmd_reg;			
assign					sdram_dq   = (state == WRITE) ? wr_dq : {16{1'bz}};
assign					sdram_bank	=	1'd0;


endmodule
	
