/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for .

-----------------------------------------------------------------------*/

module vga_display_pic
(
	//global clock
	input					clk					,			//system clock
	input					rst_n				,     		//sync reset
		
	//vga interface	
	output			[7:0]	vga_b				,
	output			[7:0]	vga_g				,
	output			[7:0]	vga_r				,
		
	output					vga_clk				,
	output					vga_blank			,
	output					vga_sync			,
	output					vga_hs				,
	output					vga_vs	
	
); 


//--------------------------------
//Funtion :   rom_pic		图像数据            

wire		[15:0]		rom_addr				;
wire		[23:0]		rom_q					;	
wire		[23:0]		rgb						;
wire		[10:0]		value_x					;
wire		[10:0]		value_y					;
wire		[ 7:0]		gray					;					
wire		[10:0]		sobel_data				;
                                           

//matrix
wire					vga_en								;
wire					mean_en								;
wire					display_val							;
wire		[ 7:0]		sobel_p11,sobel_p12,sobel_p13		;
wire		[ 7:0]		sobel_p21,sobel_p22,sobel_p23		;
wire		[ 7:0]		sobel_p31,sobel_p32,sobel_p33		;

wire		[ 7:0]		mean_p11,mean_p12,mean_p13			;
wire		[ 7:0]		mean_p21,mean_p22,mean_p23			;
wire		[ 7:0]		mean_p31,mean_p32,mean_p33			;

//mead

wire		[ 7:0]		mean_data							;

//--------------------------------
//Funtion :   mean_filter



 mean	mean_inst
(
        //clk   interface
     .clk				(clk				),       
     .rst_n				(rst_n				),      
			
        //input dat	
     .mean_p11			(mean_p11			), 
	 .mean_p12			(mean_p12			), 
	 .mean_p13			(mean_p13			),
     .mean_p21			(mean_p21			), 
	 .mean_p22			(mean_p22			), 
	 .mean_p23			(mean_p23			),
     .mean_p31			(mean_p31			), 
	 .mean_p32			(mean_p32			), 
	 .mean_p33			(mean_p33			),
	 .mean_data			(mean_data    		),
	 .vga_en			(vga_en				),
	 .mean_en			(mean_en			)
);	




//--------------------------------
//Funtion :   sort 

rom_pic 	rom_u1
(
	.address			(rom_addr			),
	.clock				(clk				),
	.q					(rom_q				)
);


//--------------------------------
//Funtion :   vga_driver


vga_qudong	driver_u2(
	//global clock
	.	clk				(clk				),			//system clock
	.	rst_n			(rst_n				),     		//sync reset
	.	rgb				(rgb				),
	.	vga_clk			(vga_clk			),
	.	vga_b			(vga_b				),
	.	vga_g			(vga_g				),
	.	vga_r			(vga_r				),
	.	vga_blank		(vga_blank			),
	.	vga_sync		(vga_sync			),
	.	vga_hs			(vga_hs				),
	.	vga_vs			(vga_vs				),
	.	value_x			(value_x			),				
	.	value_y			(value_y			)
);			


//--------------------------------
//Funtion :   vga_control

vga_control	control_u3
(
	//global clock
	.	clk				(clk				),			//system clock
	.	rst_n			(rst_n				),     		//sync reset
	
	//vga interface
	.	value_x			(value_x			),
	.	value_y			(value_y			),
	.	rgb				(rgb				),

	//rom interface

	.	rom_addr		(rom_addr			),		//
	.	rom_q			(rom_q				),
	
	.	gray			(gray				),
	.	sobel_data		(sobel_data			),
	.	vga_en			(vga_en				),
	.	display_val		(display_val		)
); 

//--------------------------------
//Funtion :   matrix

 matrix_3X3 matrix_mean_inst
(       
        //global    clk
     .clk				(clk				),       
     .rst_n				(rst_n				),
        //data_in   interface
     .data_in			(gray				),
     .clken				(vga_en	     		),
        //user      interface 
     .matrix_p11		(mean_p11			), 
	 .matrix_p12		(mean_p12			), 
	 .matrix_p13		(mean_p13			),
     .matrix_p21		(mean_p21			), 
	 .matrix_p22		(mean_p22			), 
	 .matrix_p23		(mean_p23			),
     .matrix_p31		(mean_p31			), 
	 .matrix_p32		(mean_p32			), 
	 .matrix_p33		(mean_p33			)
);	


 matrix_3X3 sobel_inst
(       
        //global    clk
     .clk				(clk				),       
     .rst_n				(rst_n				),
        //data_in   interface
     .data_in			(mean_data			),
     .clken				(mean_en   			),
        //user      interface 
     .matrix_p11		(sobel_p11			), 
	 .matrix_p12		(sobel_p12			), 
	 .matrix_p13		(sobel_p13			),
     .matrix_p21		(sobel_p21			), 
	 .matrix_p22		(sobel_p22			), 
	 .matrix_p23		(sobel_p23			),
     .matrix_p31		(sobel_p31			), 
	 .matrix_p32		(sobel_p32			), 
	 .matrix_p33		(sobel_p33			)
);
//--------------------------------
//Funtion :   vga_control



sobel	sobel_u4
(
	//global clock
	.clk				(clk				),			//system clock
	.rst_n				(rst_n				),     		//sync reset
	
	//gray interface
	
	//sobel	interface
	.sobel_data			(sobel_data			),
    .matrix_p11			(sobel_p11			), 
	.matrix_p12			(sobel_p12			), 
	.matrix_p13			(sobel_p13			),
    .matrix_p21			(sobel_p21			), 
	.matrix_p22			(sobel_p22			), 
	.matrix_p23			(sobel_p23			),
    .matrix_p31			(sobel_p31			), 
	.matrix_p32			(sobel_p32			), 
	.matrix_p33			(sobel_p33			),
		
	//vga_en	
	.mean_en			(mean_en			),
	.display_val		(display_val		)
	
); 



endmodule
	
