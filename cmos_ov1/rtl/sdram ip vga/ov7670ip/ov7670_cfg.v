/*-----------------------------------------------------------------------
* Date      :       2017/9/16 8:06:22  
* Version       :       1.0
* Description   :       Design for ov7670 register cfg.
    * --------------------------------------------------------------------*/

module  ov7670_cfg
(
        //global    clk
        input                   clk                     ,      
        input                   rst_n                   ,       
        //IIC interface
        output           [15:0] cfg_data                ,  
		//user interface
		input					busy					,
		output	reg				start					,
		output					cfg_done		
);

//--------------------------------
////Funtion : define 

wire    [15:0]   cfg_array[163:0]                               ;   
wire			 busy_neg										;//busy negedge
reg		[ 2:0]   busy_array										;
reg		[ 7:0]	 cfg_index										;
reg		[ 3:0]	 start_cnt										;
//--------------------------------
////Funtion :  detect busy_neg

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		busy_array <= 2'd0;
	else
		busy_array <= {busy_array[1:0] , busy};
end


//--------------------------------
////Funtion :  start

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		start_cnt <= 1'd0;
	else if(start_cnt < 15)
		start_cnt <= start_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		start <= 1'd0;
	else if(start_cnt < 10)   //start is 1
		start <= 1'd1;
	else if(busy_neg && (cfg_index <= 163))
		start <= 1'd1;
	else
		start <= 1'd0;
end

//--------------------------------
////Funtion :  cfg cnt

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cfg_index <= 1'd0;
	else if(busy_neg && (cfg_index < 163))
		cfg_index <= cfg_index + 1'b1;
end

assign cfg_done = (cfg_index == 163);

//--------------------------------
////Funtion : ¼Ä´æÆ÷

assign		cfg_data = cfg_array[cfg_index];


assign      cfg_array[000] = 16'h3a04;
assign      cfg_array[001] = 16'h40d0;
assign      cfg_array[002] = 16'h1204;
assign      cfg_array[003] = 16'h32b6;
assign      cfg_array[004] = 16'h1713;
assign      cfg_array[005] = 16'h1801;
assign      cfg_array[006] = 16'h1902;
assign      cfg_array[007] = 16'h1a7a;
assign      cfg_array[008] = 16'h030a;
assign      cfg_array[009] = 16'h0c00;
assign      cfg_array[010] = 16'h3e00;
assign      cfg_array[011] = 16'h7000;		//80 yiwei
assign      cfg_array[012] = 16'h7100;		//80 ²ÊÌõ
assign      cfg_array[013] = 16'h7211;
assign      cfg_array[014] = 16'h7300;
assign      cfg_array[015] = 16'ha202;
assign      cfg_array[016] = 16'h1180;
assign      cfg_array[017] = 16'h7a20;
assign      cfg_array[018] = 16'h7b1c;
assign      cfg_array[019] = 16'h7c28;
assign      cfg_array[020] = 16'h7d3c;
assign      cfg_array[021] = 16'h7e55;
assign      cfg_array[022] = 16'h7f68;
assign      cfg_array[023] = 16'h8076;
assign      cfg_array[024] = 16'h8180;
assign      cfg_array[025] = 16'h8288;
assign      cfg_array[026] = 16'h838f;
assign      cfg_array[027] = 16'h8496;
assign      cfg_array[028] = 16'h85a3;
assign      cfg_array[029] = 16'h86af;
assign      cfg_array[030] = 16'h87c4;
assign      cfg_array[031] = 16'h88d7;
assign      cfg_array[032] = 16'h89e8;
assign      cfg_array[033] = 16'h13e0;
assign      cfg_array[034] = 16'h0000;
assign      cfg_array[035] = 16'h1000;
assign      cfg_array[036] = 16'h0d00;
assign      cfg_array[037] = 16'h1428;
assign      cfg_array[038] = 16'ha505;
assign      cfg_array[039] = 16'hab07;
assign      cfg_array[040] = 16'h2475;
assign      cfg_array[041] = 16'h2563;
assign      cfg_array[042] = 16'h26a5;
assign      cfg_array[043] = 16'h9f78;
assign      cfg_array[044] = 16'ha068;
assign      cfg_array[045] = 16'ha103;
assign      cfg_array[046] = 16'ha6df;
assign      cfg_array[047] = 16'ha7df;
assign      cfg_array[048] = 16'ha8f0;
assign      cfg_array[049] = 16'ha990;
assign      cfg_array[050] = 16'haa94;
assign      cfg_array[051] = 16'h13ef;
assign      cfg_array[052] = 16'h0e61;
assign      cfg_array[053] = 16'h0f4b;
assign      cfg_array[054] = 16'h1602;
assign      cfg_array[055] = 16'h2102;
assign      cfg_array[056] = 16'h2291;
assign      cfg_array[057] = 16'h2907;
assign      cfg_array[058] = 16'h330b;
assign      cfg_array[059] = 16'h350b;
assign      cfg_array[060] = 16'h371d;
assign      cfg_array[061] = 16'h3871;
assign      cfg_array[062] = 16'h392a;
assign      cfg_array[063] = 16'h3c78;
assign      cfg_array[064] = 16'h4d40;
assign      cfg_array[065] = 16'h4e20;
assign      cfg_array[066] = 16'h6900;
assign      cfg_array[067] = 16'h7419;
assign      cfg_array[068] = 16'h8d4f;
assign      cfg_array[069] = 16'h8e00;
assign      cfg_array[070] = 16'h8f00;
assign      cfg_array[071] = 16'h9000;
assign      cfg_array[072] = 16'h9100;
assign      cfg_array[073] = 16'h9200;
assign      cfg_array[074] = 16'h9600;
assign      cfg_array[075] = 16'h9a80;
assign      cfg_array[076] = 16'hb084;
assign      cfg_array[077] = 16'hb10c;
assign      cfg_array[078] = 16'hb20e;
assign      cfg_array[079] = 16'hb382;
assign      cfg_array[080] = 16'hb80a;
assign      cfg_array[081] = 16'h4314;
assign      cfg_array[082] = 16'h44f0;
assign      cfg_array[083] = 16'h4534;
assign      cfg_array[084] = 16'h4658;
assign      cfg_array[085] = 16'h4728;
assign      cfg_array[086] = 16'h483a;
assign      cfg_array[087] = 16'h5988;
assign      cfg_array[088] = 16'h5a88;
assign      cfg_array[089] = 16'h5b44;
assign      cfg_array[090] = 16'h5c67;
assign      cfg_array[091] = 16'h5d49;
assign      cfg_array[092] = 16'h5e0e;
assign      cfg_array[093] = 16'h6404;
assign      cfg_array[094] = 16'h6520;
assign      cfg_array[095] = 16'h6605;
assign      cfg_array[096] = 16'h9404;
assign      cfg_array[097] = 16'h9508;
assign      cfg_array[098] = 16'h6c0a;
assign      cfg_array[099] = 16'h6d55;
assign      cfg_array[100] = 16'h6e11;
assign      cfg_array[101] = 16'h6f9f;
assign      cfg_array[102] = 16'h6a40;
assign      cfg_array[103] = 16'h0140;
assign      cfg_array[104] = 16'h0240;
assign      cfg_array[105] = 16'h13e7;
assign      cfg_array[106] = 16'h1500;
assign      cfg_array[107] = 16'h4f80;
assign      cfg_array[108] = 16'h5080;
assign      cfg_array[109] = 16'h5100;
assign      cfg_array[110] = 16'h5222;
assign      cfg_array[111] = 16'h535e;
assign      cfg_array[112] = 16'h5480;
assign      cfg_array[113] = 16'h589e;
assign      cfg_array[114] = 16'h4108;
assign      cfg_array[115] = 16'h3f00;
assign      cfg_array[116] = 16'h7505;
assign      cfg_array[117] = 16'h76e1;
assign      cfg_array[118] = 16'h4c00;
assign      cfg_array[119] = 16'h7701;
assign      cfg_array[120] = 16'h3dc2;
assign      cfg_array[121] = 16'h4b09;
assign      cfg_array[122] = 16'hc960;
assign      cfg_array[123] = 16'h4138;
assign      cfg_array[124] = 16'h5640;
assign      cfg_array[125] = 16'h3411;
assign      cfg_array[126] = 16'h3b02;
assign      cfg_array[127] = 16'ha489;
assign      cfg_array[128] = 16'h9600;
assign      cfg_array[129] = 16'h9730;
assign      cfg_array[130] = 16'h9820;
assign      cfg_array[131] = 16'h9930;
assign      cfg_array[132] = 16'h9a84;
assign      cfg_array[133] = 16'h9b29;
assign      cfg_array[134] = 16'h9c03;
assign      cfg_array[135] = 16'h9d4c;
assign      cfg_array[136] = 16'h9e3f;
assign      cfg_array[137] = 16'h7804;
assign      cfg_array[138] = 16'h7901;
assign      cfg_array[139] = 16'hc8f0;    
assign      cfg_array[140] = 16'h790f;    
assign      cfg_array[141] = 16'hc800;    
assign      cfg_array[142] = 16'h7910;    
assign      cfg_array[143] = 16'hc87e;    
assign      cfg_array[144] = 16'h790a;    
assign      cfg_array[145] = 16'hc880;    
assign      cfg_array[146] = 16'h790b;    
assign      cfg_array[147] = 16'hc801;    
assign      cfg_array[148] = 16'h790c;    
assign      cfg_array[149] = 16'hc80f;    
assign      cfg_array[150] = 16'h790d;    
assign      cfg_array[151] = 16'hc820;
assign      cfg_array[152] = 16'h7909;
assign      cfg_array[153] = 16'hc880; 
assign      cfg_array[154] = 16'h7902;                              
assign      cfg_array[155] = 16'hc8c0;                              
assign      cfg_array[156] = 16'h7903;                              
assign      cfg_array[157] = 16'hc840;                              
assign      cfg_array[158] = 16'h7905;                              
assign      cfg_array[159] = 16'hc830;                              
assign      cfg_array[160] = 16'h7926;                              
assign      cfg_array[161] = 16'h0903; 							 
assign      cfg_array[162] = 16'h3b42; 							 


//	
assign		cfg_array[163] = 16'h1e01;	//Ë®Æ½¾µÏñ
assign busy_neg = (busy_array[2] & !busy_array[1]);


endmodule               
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        