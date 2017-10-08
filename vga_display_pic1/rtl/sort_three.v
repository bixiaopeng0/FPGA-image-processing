/*-----------------------------------------------------------------------
* Date          :       2017/10/5 21:05:52  
* Version       :       1.0
* Description   :       Design for sort.
* -----------------------------------------------------------------------*/

module  sort_three
(
        //global clk
        input                   clk                     ,       
        input                   rst_n                   ,       

        //input data
        input       [ 7:0]      data_in1                ,
        input       [ 7:0]      data_in2                ,
        input       [ 7:0]      data_in3                ,

        //sort  interface
        output  reg [ 7:0]      max_data                ,
        output  reg [ 7:0]      mid_data                ,
        output  reg [ 7:0]      min_data            

);  

//--------------------------------
////Funtion : define
wire    [  7:0]      shiftout            ;
wire    [255:0]      taps                ;


//---------------------------------
////Funtion : find the max data

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        max_data <= 1'd0;
    else if(data_in1 >= data_in2 && data_in1 >= data_in3)
        max_data <= data_in1;
    else if(data_in2 >= data_in1 && data_in2 >= data_in3)
        max_data <= data_in2;
    else if(data_in3 >= data_in1 && data_in3 >= data_in2)
        max_data <= data_in3;
end


//--------------------------------
////Funtion : find the median data

always @(posedge clk or negedge rst_n)
begin
     if(!rst_n)
         mid_data <= 1'd0;
     else if((data_in1 <= data_in2 && data_in1 >= data_in3) || (data_in1 >= data_in2 && data_in1 <= data_in3))
         mid_data <= data_in1;
     else if((data_in2 <= data_in1 && data_in2 >= data_in3) || (data_in2 >= data_in1 && data_in2 <= data_in3))
         mid_data <= data_in2;
     else if((data_in3 <= data_in2 && data_in3 >= data_in1) || (data_in3 >= data_in2 && data_in3 <= data_in1))
         mid_data <= data_in3;
end

//--------------------------------
////Funtion : find the min data

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        min_data <= 1'd0;
    else if(data_in1 <= data_in2 && data_in1 <= data_in3)
        min_data <= data_in1;
    else if(data_in2 <= data_in1 && data_in2 <= data_in3)
        min_data <= data_in2;
    else if(data_in3 <= data_in2 && data_in3 <= data_in1)
        min_data <= data_in3;
end


endmodule


