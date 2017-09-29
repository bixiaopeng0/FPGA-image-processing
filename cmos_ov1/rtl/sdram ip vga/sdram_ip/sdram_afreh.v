/*-----------------------------------------------------------------------

Date				:		2017-08-29
Description			:		Design for auto refresh.

-----------------------------------------------------------------------*/

module sdram_afreh
(
	//global clock
	input					clk							,			//system clock
	input					rst_n						,     		//sync reset
	
	//init		interface
	input					flag_init_end				,
	
	//auto_freh interface
	input					ref_en						,
	output	reg				ref_req						,
	output	reg				flag_ref_end				,
	
	//sdram		interface
	output	reg		[3:0]	aref_cmd					,
	output	reg		[12:0]	aref_addr

	
); 

//--------------------------------
//Funtion : 
	parameter		CMD_END		=	4'd8				,
					DELAY_7US	=	9'd350				,
					NOP			=	4'b0111				,
					PRECHARGE	=	4'b0010				,
					AREF		=	4'b0001				;
	
	reg			[8:0]		cnt_7us						;
	reg						flag_ref					;		//处于自刷新阶段标志
	reg						flag_start					;		//自刷新启动标志
	reg			[3:0]		cnt_cmd						;



//--------------------------------
//Funtion : 	flag_start              

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_start <= 1'd0;
	else if(flag_init_end)
		flag_start <= 1'd1;
end

//--------------------------------
//Funtion : 	7us

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_7us <= 1'd0;
	else if(cnt_7us == DELAY_7US)
		cnt_7us <= 1'd0;
	else if(flag_start)
		cnt_7us <= cnt_7us + 1'b1;
end

//--------------------------------
//Funtion : flag_ref

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_ref <= 1'd0;
	else if(cnt_cmd == CMD_END)
		flag_ref <= 1'd0;
	else if(ref_en)
		flag_ref <= 1'd1;
end

//--------------------------------
//Funtion : cnt_cmd

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_cmd <= 1'd0;
	else if(flag_ref)
		cnt_cmd <= cnt_cmd + 1'b1;
	else
		cnt_cmd <= 1'd0;
end

//--------------------------------
//Funtion : flag_ref_end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_ref_end <= 1'd0;
	else if(cnt_cmd == CMD_END)
		flag_ref_end <= 1'd1;
	else
		flag_ref_end <= 1'd0;
end


//--------------------------------
//Funtion : cmd_reg

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		aref_cmd <= NOP;
	else case(cnt_cmd)
		3'd0 :
		begin
			if(flag_ref)
				aref_cmd <= PRECHARGE;
			else
				aref_cmd <= NOP;
		end
		
		3'd1 :
		begin
			aref_cmd <= AREF;
		end
		
		3'd5 :
		begin
			aref_cmd <= AREF;
		end
		
		
		
		default : 
			aref_cmd <= NOP;
	
	endcase
end

//--------------------------------
//Funtion : sdram_addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		aref_addr <= 1'd0;
	else case(cnt_cmd)
		
		4'd0 :
		begin
			if(flag_ref)
				aref_addr <= 13'b0_0100_0000_0000;
			else
				aref_addr <= 1'd0;
		end
		
		default : aref_addr <= 1'd0;
	endcase
end

//--------------------------------
//Funtion : ref_req

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)	
		ref_req <= 1'b0;
	else if(ref_en)
		ref_req <= 1'd0;
	else if(cnt_7us == DELAY_7US)
		ref_req <= 1'b1;
end


endmodule
	
