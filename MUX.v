`timescale 1ns / 1ps

module MUX(
input IN1,
input IN2,
input IN3,
input IN4,
input [1:0] sel_line,
output reg out
    );
    
always@(*)
begin
    case(sel_line)
    2'b00 : out = IN1;  //serializer
    2'b01 : out = IN2;  //start
    2'b10 : out = IN3;  //parity
    2'b11 : out = IN4;  //stop
    endcase

end    
    
endmodule
