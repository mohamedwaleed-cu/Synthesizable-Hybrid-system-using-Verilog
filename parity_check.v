`timescale 1ns / 1ps

module parity_check #(parameter data_width=8)
(
input [data_width-1:0] data,
input DATA_VALID,
input parity_type,
output parity_bit
    );
//wire [data_width-1:0] temp;
//assign temp=(DATA_VALID==1)?data:temp;    
assign parity_bit=(DATA_VALID)?((parity_type==0)?(^data):(~^data)):parity_bit;    
    
    
endmodule
