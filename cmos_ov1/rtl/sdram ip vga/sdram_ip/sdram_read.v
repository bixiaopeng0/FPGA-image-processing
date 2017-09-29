/*-----------------------------------------------------------------------

Date				:		2017-08-30
Description			:		Design for sdram_read .

-----------------------------------------------------------------------*/

module sdram_read
(
	//global clock
	input					clk				,			//system clock
	input					rst_n			,     		//sync reset
	
	//read interface
	output	reg				rd_req			,   		//读请求
	input					rd_en			,
	
	//sdram	interface
	output	reg		[3:0]	rd_cmd			,
	output	reg		[12:0]	rd_addr			,
//	output			[1:0]	rd_bank,
	input			[15:0]	sdram_dq		,
	output			[15:0]	rd_dq			,
		
	//
	input			[4:0]	state			,
	output	reg				sdram_rd_data_value,
	input					vga_done		,
	input					rd_trig			,
	output	reg				flag_rd_end

	
); 


//--------------------------------
//Funtion :  参数化定义
parameter			NOP		=		4'b0111				,
					PRE		=		4'b0010				,
					ACT		=		4'b0011				,
					RD		=		4'b0101				,
					
					CMD_END	=		4'd14				,
					COL_END	=		11'd632				,
					ROW_END	=		13'd479				,
					AREF	=		5'b0_0100			,
					READ	=		5'b1_0000			;

reg		[12:0]		row_addr				;
reg		[ 9:0]		col_addr				;
reg		[3:0]		cmd_cnt					;
reg					vga_done_r				;
//reg					flag_rd_end				;
//--------------------------------
//Funtion :    rd_req

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_req <= 1'b0;
	else if(rd_en)
		rd_req <= 1'b0;
	else if(rd_trig && state != READ)
		rd_req <= 1'b1;
end

//--------------------------------
//Funtion : clear (one frame is over)

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_done_r <= 1'd0;
	else 
		vga_done_r <= vga_done;
end

//--------------------------------
//Funtion :    cmd_cnt

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cmd_cnt <= 1'd0;
	else if(state == READ)
		cmd_cnt <= cmd_cnt + 1'b1;
	else
		cmd_cnt <=	1'd0;
end

//--------------------------------
//Funtion :    flag_rd_end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_rd_end <= 1'd0;
	else if(cmd_cnt == CMD_END)
		flag_rd_end <= 1'd1;
	else
		flag_rd_end <= 1'd0;
end


//--------------------------------
//Funtion :    row_addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		row_addr <= 1'd0;
	else if((row_addr == ROW_END && col_addr == COL_END && flag_rd_end) || vga_done_r)
		row_addr <= 1'd0;
	else if(col_addr == COL_END && flag_rd_end)
		row_addr <= row_addr + 1'b1;
end

//--------------------------------
//Funtion :    col_addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		col_addr <= 1'd0;
	else if((col_addr == COL_END && flag_rd_end) || vga_done_r )
		col_addr <= 1'd0;
	else if(flag_rd_end)
		col_addr <= col_addr + 4'd8;
end


//--------------------------------
//Funtion :    rd_cmd

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_cmd <= NOP;
	else case(cmd_cnt)
		
		4'd1 :

			rd_cmd <= PRE;

		4'd2 :
			rd_cmd <= NOP;				
		
		4'd3 :
			rd_cmd <= ACT;

		4'd4 :
			rd_cmd <= NOP;
			
		4'd5 :
			rd_cmd <= RD;
			
		default : 
			rd_cmd <= NOP;
	endcase
end

//--------------This Ok-------------------
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sdram_rd_data_value <= 1'd0;
	else
	case(cmd_cnt)
		
		4'd7  : sdram_rd_data_value <= 1'd1;
		4'd8  : sdram_rd_data_value <= 1'd1;
		4'd9  : sdram_rd_data_value <= 1'd1;
		4'd10 : sdram_rd_data_value <= 1'd1;
		4'd11 : sdram_rd_data_value <= 1'd1;
		4'd12 : sdram_rd_data_value <= 1'd1;
		4'd13 : sdram_rd_data_value <= 1'd1;
		4'd14 : sdram_rd_data_value <= 1'd1;
		default : sdram_rd_data_value <= 1'd0;
		
	endcase
end

//-------------debug------------------------

/* always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_dq <= 1'd0;
	else
	case(cmd_cnt)
		
		4'd7  : rd_dq <= 16'hffff;
		4'd8  : rd_dq <= 16'hffff;
		4'd9  : rd_dq <= 16'hffff;
		4'd10 : rd_dq <= 16'hffff;
		4'd11 : rd_dq <= 16'h0ff0;
		4'd12 : rd_dq <= 16'h0ff0;
		4'd13 : rd_dq <= 16'h0ff0;
		4'd14 : rd_dq <= 16'h0ff0;
		default : rd_dq <= sdram_dq;
		
	endcase
end
 */





//--------------------------------
//Funtion :    rd_addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_addr <= 1'd0;
	else case(cmd_cnt)
		
		3'd1 :
			rd_addr <= 13'b0_0100_0000_0000;
		
		3'd5 :
			rd_addr <= {3'd0 , col_addr};
		
		default : 
			rd_addr <= row_addr;
	endcase
end




assign		rd_dq = sdram_dq;



endmodule
	
