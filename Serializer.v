`timescale 1ns / 1ps


module Serializer #(parameter data_width=8)(
input [data_width-1:0] in_data,
input DATA_VALID_S,
input enable,
input CLK,
input RST,
output wire done,
output reg out_data
    );
 reg [3:0] counter;
 reg [data_width-1:0] temp;
 wire count_done;   
always@(posedge CLK or negedge RST)
    begin
        if(!RST)
        begin
            out_data<=1;
            counter<=0;
        end
        else if(DATA_VALID_S)
            temp<=in_data;
        else if (enable && !count_done)
        begin
            out_data<=temp[counter];
            counter<=counter+1;
        end
        else
        begin
          //  done<=1;
            counter<=0;
            out_data<=1;
        end
    end    
 
assign count_done=(counter==4'b1000)?1:0;
assign done=(count_done==1)?1:0;    
endmodule
