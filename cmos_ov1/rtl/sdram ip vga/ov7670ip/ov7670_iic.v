/*-----------------------------------------------------------------------
Date        :       2017/9/6 21:13:55  
Version     :       1.0
Description :       Design for IIC_control.
    --------------------------------------------------------------------*/

module  ov7670_iic
(
        // clk  interface
        input                   clk                     ,      //50M 
        input                   rst_n                   ,       

        //IIC   interface
        output	reg             iic_clk                 ,      //iic_clk 
        inout		            iic_sda                 ,      //iic_sda

       //user   interface
        input                   start                   ,     //iic_start
        input           [23:0]  wdata                   ,     //register data
        output  reg             busy                    ,     //busy message
		
		//debug
        output  reg     [ 7:0]  riic_data               ,   //read data
		input					wd_rd_en				,
		input			[15:0]	read_addr		

);


//--------------------------------
//Funtion : define signals



reg     [23:0]                  wdata_reg                       ;     //regster_data   reg  
reg     [ 5:0]                  time_cnt                        ;     //time
reg                             sda_reg                         ;     //iic_data  register  
reg                             flag_ack                        ;     //ack     
reg                             done                            ;       
reg								iic_clk1						;
reg		[8:0]					div_cnt							;

wire                            dir                             ;      //0 :write 1:read
wire							div_clk							;
wire							div_en							;
//--------------------------------
//Funtion : wdata register

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wdata_reg <= 1'd0;
    else if(start == 1'd1)
        wdata_reg <= wdata;
end


//--------------------------------
//Funtion : 100k iic
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		div_cnt <= 1'd0;
	else
		div_cnt <= div_cnt + 1'b1;
end


//--------------------------------
//Funtion : doing flag

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        busy <= 1'b0;
    else if(start)    
        busy <= 1'b1;
    else if(done)
        busy <= 1'b0;
end

//--------------------------------
//Funtion : done flag

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        done <= 1'd0;
    else if((time_cnt == 51 && dir == 1)||(time_cnt >= 38 && !dir))	//read
        done <= 1'd1;
    else
        done <= 1'd0;
end



//--------------------------------
//Funtion : time_cnt

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        time_cnt <= 1'd0;
	else if((time_cnt >= 52 && dir) || (time_cnt >= 39 && !dir)||(!busy))
		time_cnt <= 1'd0;
    else if(busy && div_en)     
        time_cnt <=  time_cnt + 1'b1;
end



//--------------------------------
//Funtion : flag_ack

always @(posedge clk)
begin
    if((time_cnt == 12 || time_cnt == 23 || time_cnt == 38 || (time_cnt >= 40 && time_cnt <= 47)) && (dir == 1'b1))
        flag_ack <= 1'd1;
    else if(dir == 1'b0 && (time_cnt == 12 || time_cnt == 23 || time_cnt == 34))
        flag_ack <= 1'd1;
    else
        flag_ack <= 1'd0;
end



//--------------------------------
//Funtion : sda_reg

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        iic_clk1 <= 1'd1;
        sda_reg <= 1'd1;
		riic_data <= 1'd0;
    end
    else if(dir == 1'b1)    //read
        case(time_cnt)
            //idle
            6'd0 : begin
                        iic_clk1 <= 1'd1;
                        sda_reg <= 1'd1;  
                   end
            //start
            6'd1 :begin
                        iic_clk1 <= 1'd1;
                        sda_reg <= 1'd0;
                  end
            6'd2 :begin
						iic_clk1 <= 1'd0;
						sda_reg <= 1'd0;
                  end
						
			//ID_addr
			6'd3 :		sda_reg <= read_addr[15];
			6'd4 :		sda_reg <= read_addr[14];
			6'd5 :		sda_reg <= read_addr[13];
			6'd6 :		sda_reg <= read_addr[12];
			6'd7 :		sda_reg <= read_addr[11];
			6'd8 :		sda_reg <= read_addr[10];
			6'd9 :		sda_reg <= read_addr[ 9];
			6'd10:		sda_reg <= read_addr[ 8];				
			//ack
			6'd11:		iic_clk1<= 1'd0;
			6'd12:					   ;
			6'd13:		iic_clk1<= 1'd0;
			//sub_addr
			6'd14:		sda_reg <= read_addr[ 7];
			6'd15:		sda_reg <= read_addr[ 6];
			6'd16:		sda_reg <= read_addr[ 5];
			6'd17:		sda_reg <= read_addr[ 4];
			6'd18:		sda_reg <= read_addr[ 3];
			6'd19:		sda_reg <= read_addr[ 2];
			6'd20:		sda_reg <= read_addr[ 1];
			6'd21:		sda_reg <= read_addr[ 0];	
			//ack
			6'd22:		iic_clk1<= 1'd0;
			6'd23:					   ;
			6'd24:		iic_clk1<= 1'd0;
			//stop
			6'd25:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd0;
				  end
			6'd26:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd1;
				  end
			//start
			6'd27:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd1;
				  end
			6'd28:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd0;
				  end
			//ID_addr    0x43
			6'd29:		sda_reg <= 1'd0;
			6'd30:		sda_reg <= 1'd1;
			6'd31:		sda_reg <= 1'd0;
			6'd32:		sda_reg <= 1'd0;
			
			6'd33:		sda_reg <= 1'd0;
			6'd34:		sda_reg <= 1'd0;
			6'd35:		sda_reg <= 1'd1;
			6'd36:		sda_reg <= 1'd1;	
			//ack
			6'd37:		iic_clk1<= 1'd0;
			6'd38:					   ;
			6'd39:		iic_clk1<= 1'd0;
			//read_data
			6'd40:		riic_data[7] <= iic_sda;
			6'd41:		riic_data[6] <= iic_sda;
			6'd42:		riic_data[5] <= iic_sda;
			6'd43:		riic_data[4] <= iic_sda;
			6'd44:		riic_data[3] <= iic_sda;
			6'd45:		riic_data[2] <= iic_sda;
			6'd46:		riic_data[1] <= iic_sda;
			6'd47:		riic_data[0] <= iic_sda;
			//nack
			6'd48:		sda_reg <= 1'd1;
			//stop
			6'd49:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd0;
				  end
			6'd50:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd1;
				  end
            default :
					begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd1;
					end
        endcase     
		else
        case(time_cnt)
            //idle
            6'd0 : begin
                        iic_clk1 <= 1'd1;
                        sda_reg <= 1'd1;  
                   end
            //start
            6'd1 :begin
                        iic_clk1 <= 1'd1;
                        sda_reg <= 1'd0;
                  end
            6'd2 :begin
						iic_clk1 <= 1'd0;
						sda_reg <= 1'd0;
                  end
						
			//ID_addr
			6'd3 :		sda_reg <= wdata_reg[23];
			6'd4 :		sda_reg <= wdata_reg[22];
			6'd5 :		sda_reg <= wdata_reg[21];
			6'd6 :		sda_reg <= wdata_reg[20];
			6'd7 :		sda_reg <= wdata_reg[19];
			6'd8 :		sda_reg <= wdata_reg[18];
			6'd9 :		sda_reg <= wdata_reg[17];
			6'd10:		sda_reg <= wdata_reg[16];				
			//ack
			6'd11:		iic_clk1<= 1'd0;
			6'd12:					   ;
			6'd13:		iic_clk1<= 1'd0;
			//sub_addr
			6'd14:		sda_reg <= wdata_reg[15];
			6'd15:		sda_reg <= wdata_reg[14];
			6'd16:		sda_reg <= wdata_reg[13];
			6'd17:		sda_reg <= wdata_reg[12];
			6'd18:		sda_reg <= wdata_reg[11];
			6'd19:		sda_reg <= wdata_reg[10];
			6'd20:		sda_reg <= wdata_reg[9];
			6'd21:		sda_reg <= wdata_reg[8];	
			//ack
			6'd22:		iic_clk1<= 1'd0;
			6'd23:					   ;
			6'd24:		iic_clk1<= 1'd0;			
			//write_data
			6'd25:		sda_reg <= wdata_reg[7];
			6'd26:		sda_reg <= wdata_reg[6];
			6'd27:		sda_reg <= wdata_reg[5];
			6'd28:		sda_reg <= wdata_reg[4];
			6'd29:		sda_reg <= wdata_reg[3];
			6'd30:		sda_reg <= wdata_reg[2];
			6'd31:		sda_reg <= wdata_reg[1];
			6'd32:		sda_reg <= wdata_reg[0];
			//ack
			6'd33:		iic_clk1<= 1'd0;
			6'd34:					   ;
			6'd35:		iic_clk1<= 1'd0;
			//stop
			6'd36:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd0;
				  end
			6'd37:begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd1;
				  end
            default :
					begin
						iic_clk1 <= 1'd1;
						sda_reg  <= 1'd1;
					end
			endcase
end

//--------------------------------
//Funtion : iic_clk

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		iic_clk <= 1'd1;
	else if(dir == 1'b1) //read
	begin
		if(time_cnt == 0 || time_cnt == 1 || time_cnt == 2 || time_cnt == 11 || time_cnt == 13 || time_cnt == 22 || (time_cnt >= 24 && time_cnt <= 28) || time_cnt == 37 || time_cnt == 39 || time_cnt == 49 || time_cnt == 50)
			iic_clk <= iic_clk1;
		else
			iic_clk <= div_clk;
	end
	else //write
	begin
		if(time_cnt == 0 || time_cnt == 1 || time_cnt == 2 || time_cnt == 11 || time_cnt == 13 ||time_cnt == 22 || time_cnt == 24 || time_cnt == 33 || (time_cnt >= 35 && time_cnt <= 37))
			iic_clk <= iic_clk1;
		else
			iic_clk <= div_clk;
	end

end

assign		div_clk = div_cnt[8];
assign		div_en	= (div_cnt == 9'd0);
assign      iic_sda = (flag_ack == 1'b1) ? 1'bz : sda_reg;
assign      dir     = 1'd0;            //0write or 1read

endmodule


