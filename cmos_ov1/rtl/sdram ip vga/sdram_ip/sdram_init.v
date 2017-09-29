/*-----------------------------------------------------------------------

Date				:		2017-08-29
Description			:		Design for sdram_init .

-----------------------------------------------------------------------*/

module sdram_init
(
	//global clock
	input					clk					,			//system clock
	input					rst_n				,     		//sync reset
	
	//sdram_init interface
	output	reg		[3:0]	init_cmd			,		//sdram 命令寄存器
	output	reg		[12:0]	init_addr			,		//地址线

	//user interface
	output	reg				flag_init_end	//sdram初始化标志
	
); 

//--------------------------------
//Funtion :   参数定义
parameter	NOP			=	4'b0111					,
			PRECGE		=	4'b0010					,
			AUTO_REF	=	4'b0001					,
			MODE_SET	=	4'b0000					,
			CMD_END		=	6'd35					,
			DELAY_200US	=	10000					;
//200us delay
reg				[13:0]		cnt_200us				;
wire						flag_200us				;

//初始化标志
reg							flag_init				;	

//cmd指令计数
reg				[5:0]		cnt_cmd					;



//--------------------------------
//Funtion :    200us           			


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_200us <= 1'd0;
	else if(flag_200us == 1'b0)
		cnt_200us <= cnt_200us + 1'b1;
end



//--------------------------------
//Funtion :   sdram	初始化标志位是否结束
	

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_init <= 1'b1;
	else if(cnt_cmd == CMD_END)		//auto refresh结束标志位
		flag_init <= 1'b0;
end	
   
//--------------------------------
//Funtion :   cnt_cmd 200us延时后计数


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_cmd <= 1'd0;
	else if(flag_200us == 1'b1 && flag_init == 1'b1)
		cnt_cmd <= cnt_cmd + 1'b1;
end

//--------------------------------
//Funtion :   初始化结束标志

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		flag_init_end <= 1'b0;
	else if(cnt_cmd >= CMD_END)
		flag_init_end <= 1'b1;
	else
		flag_init_end <= 1'b0;
end


			
//--------------------------------
//Funtion :   cmd_reg

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		init_cmd <= NOP;
	else if(cnt_200us == DELAY_200US - 2'd3)
		init_cmd <= PRECGE;
	else if(flag_200us)
	begin
		case(cnt_cmd)
			//8 auto refresh 
			6'd0 , 6'd6 , 6'd10 , 6'd14 , 6'd18 , 6'd22 , 6'd26 , 6'd30: 
				init_cmd <= AUTO_REF;
			//mode	set
			6'd34 :
				init_cmd <= MODE_SET;
				
			default :
				init_cmd <= NOP;
			
		endcase
	end
end			
			
//--------------------------------
//Funtion :   sdram_addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		init_addr <= 13'd0;
	else if(cnt_200us == DELAY_200US - 2'd3) //预充电
		init_addr <= 13'b0_0100_0000_0000;
	else if(cnt_cmd == 6'd34)		  //模式寄存器设置
		init_addr <= 13'b0_0000_0000_0011;			//8 
	else
		init_addr <= 13'd0;
end

//--------------------------------
//Funtion :   init_bank

assign		flag_200us		=		(cnt_200us >= DELAY_200US - 1'b1) ? 1'b1 : 1'b0;
endmodule
	
