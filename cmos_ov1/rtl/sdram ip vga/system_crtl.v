/*-----------------------------------------------------------------------
* Date          :       2017/9/23 15:48:25 
* Version       :       1.0
* Description   :       Design for system crtl clk.
* --------------------------------------------------------------------*/

module  system_crtl
(
		//clk interface
        input                   clk                     ,       
        input                   rst_n                   ,       

        //global interface
        output  wire            clk_24                  ,       
        output  wire            clk_40                  ,       //90 degree
		output	wire			clk_100					,
        output  reg             sys_rst_n                          
);

      

//--------------------------------
////Funtion : ¼Ä´æ
 
always @(posedge clk )
begin
    sys_rst_n <= rst_n;
end



//--------------------------------
////Funtion : pll crtl

pll_crtl pll_inst(
		.refclk			(clk			),   //  refclk.clk
		.rst			(!sys_rst_n		),      //   reset.reset
		.outclk_0		(clk_40			), // outclk0.clk
		.outclk_1		(clk_24			), // outclk1.clk
		.outclk_2		(clk_100		),
		.locked			(				)    //  locked.export
	);




endmodule



