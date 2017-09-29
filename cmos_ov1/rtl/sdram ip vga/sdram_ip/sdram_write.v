/*-----------------------------------------------------------------------

Date				:		2017-08-29
Description			:		Design for sdram write .

-----------------------------------------------------------------------*/

module sdram_write
(
	//global clock
	input					clk				,			//system clock
	input					rst_n			,     		//sync reset
	
	//sdram_write interface
	input					wr_en			,			//写使能
	output	reg				wr_req			,			//写请求
	input					wr_trig			,		//写触发给写请求信号

	//sdram interface
	output	reg		[3:0]	wr_cmd			,
	output	reg		[12:0]	wr_addr			,
	input			[15:0]	wr_q			,
	output	reg		[15:0]	wr_dq			,
	//afresh interface
	//input					ref_req  
	input			[4:0]	state			,
	output	reg				sdram_wdata_value,
	input					vsync_pos		,
	output	reg				wr_clear		,
	output	reg				flag_wr_end
); 


//--------------------------------
//Funtion :    参数定义

/* localparam		S_IDLE		=		5'b0_0001;
localparam		S_REQ		=		5'b0_0010;
localparam		S_ACT		=		5'b0_0100;
localparam		S_WR		=		5'b0_1000;
localparam		S_PRE		=		5'b1_0000;

reg							flag_wr;
reg			[4:)]			state; */

parameter		NOP		=		4'b0111				,
				ACT		=		4'b0011				,
				WR		=		4'b0100				,
				PRE		=		4'b0010				,
				CMD_END	=		4'd12 				,		//指令delay
				COL_END	=		10'd632				,	//列地址最后四个地址
				ROW_END	=		13'd479				,			//行地址结束
				AREF	=		5'b0_0100			,
				WRITE	=		5'b0_1000			;


//reg						flag_wr_end					;		//write egiht over
reg						flag_ye_end					;		//write one hang over
reg		[ 9:0]			col_addr					;

reg		[12:0]			row_addr					;
reg		[12:0]			row_addr_reg				;
reg		[3:0]			cmd_cnt						;



//--------------------------------
//Funtion :    wr_req

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_req <= 1'd0;
	else if(wr_en)
		wr_req <= 1'd0;
	else if(state != WRITE && wr_trig)
		wr_req <= 1'd1;
end

//--------------------------------
//Funtion :    flag_wr_end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_wr_end <= 1'd0;
	else if(cmd_cnt == CMD_END)
		flag_wr_end <= 1'd1;
	else
		flag_wr_end <= 1'd0;
end

//--------------------------------
//Funtion :    cmd_cnt

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cmd_cnt <= 1'd0;
	else if((state == WRITE) && (wr_clear == 1'b0) )   //rduse > 100
		cmd_cnt <= cmd_cnt + 1'b1;
	else
		cmd_cnt <= 1'd0;
end

//--------------------------------
//Funtion :    wr_cmd

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_cmd <= 1'd0;
	else case(cmd_cnt)
		//预充电 或者 nop
		4'd1 :
		begin
				wr_cmd <= PRE;
		end
		//act
		4'd2 :
		begin
				wr_cmd <= NOP;
		end

		4'd3 :
		begin
				wr_cmd <= ACT;
		end		

		4'd4 :
		begin
				wr_cmd <= NOP;
		end	
		
		//write
		4'd5 :
		begin
			wr_cmd <= WR;
		end
		default : wr_cmd <= NOP;
	
	endcase
end

//--------------------------------
//Funtion :   fifo en
//-------------This is ok--------------

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sdram_wdata_value <= 1'd0;
	else	
	case(cmd_cnt)
	4'd4 : 
		sdram_wdata_value <= 1'd1;
	4'd5 :
		sdram_wdata_value <= 1'd1;
	4'd6 :
		sdram_wdata_value <= 1'd1;
	4'd7 :
		sdram_wdata_value <= 1'd1;
	4'd8 : 
		sdram_wdata_value <= 1'd1;
	4'd9 :
		sdram_wdata_value <= 1'd1;
	4'd10:
		sdram_wdata_value <= 1'd1;
	4'd11:
		sdram_wdata_value <= 1'd1;
	default :
		sdram_wdata_value <= 1'd0;
	endcase
end
//-----------debug-------------------
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_dq <= 1'd0;
	else case(cmd_cnt)
    	4'd5  :
			wr_dq <= wr_q;
		4'd6  :
			wr_dq <= wr_q;
		4'd7  :
			wr_dq <= wr_q;
		4'd8  :
			wr_dq <= wr_q; 
 		4'd9  :
			wr_dq <= wr_q;
		4'd10 :
			wr_dq <= wr_q;
		4'd11 :
			wr_dq <= wr_q;
		4'd12 :
			wr_dq <= wr_q;    
//------------DEBUG--------------------
/*    		4'd5  :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]};
		4'd6  :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]};
		4'd7  :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]};
		4'd8  :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]}; 
 		4'd9  :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]};
		4'd10 :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]};
		4'd11 :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]};
		4'd12 :
			wr_dq <= {row_addr_reg[7:0] , col_addr[7:0]}; */
		default : 
			wr_dq <= 1'd0;
	endcase
end 

//--------------------------------
//Funtion :    row_addr_reg

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		row_addr_reg <= 1'd0;
	else if(row_addr_reg == ROW_END && col_addr == COL_END && flag_wr_end)
		row_addr_reg <= 1'd0;
	else if(flag_wr_end && col_addr == COL_END)
		row_addr_reg <= row_addr_reg + 1'b1;
end

//--------------------------------
//Funtion :    row_addr
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		row_addr <= 1'd0;
	else 	
		row_addr <= row_addr_reg;
end

//--------------------------------
//Funtion :    	col_addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		col_addr <= 1'd0;
	else if(col_addr == COL_END && flag_wr_end)
		col_addr <= 1'd0;
	else if(flag_wr_end)
		col_addr <= col_addr + 4'd8;
end

//--------------------------------
//Funtion :  flag_ye_end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_ye_end <= 1'd0;
	else if(row_addr_reg == ROW_END && col_addr == COL_END && flag_wr_end)
		flag_ye_end <= 1'd1;
	else
		flag_ye_end <= 1'd0;
end
//--------------------------------
//Funtion :    	wr_addr
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_addr <= 1'd0;
	else case(cmd_cnt)
		// 3'd2 :
			// wr_addr <= row_addr;
		3'd1 :
			wr_addr  <= 13'b0_0100_0000_0000;
		
		3'd5 :
			wr_addr  <= {3'd0 , col_addr};
			
		default :
			wr_addr <= row_addr;
	endcase
end



//--------------------------------
//Funtion :    	wr_clear

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_clear <= 1'd0;
	else if(flag_ye_end)
		wr_clear <= 1'd1;
	else if(vsync_pos)
		wr_clear <= 1'd0;
end







endmodule
	
