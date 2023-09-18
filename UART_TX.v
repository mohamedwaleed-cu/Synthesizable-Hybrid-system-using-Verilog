`timescale 1ns / 1ps

module UART_TX #(parameter data_width=8)(
input [data_width-1:0] P_DATA,
input DATA_VALID,
input CLK,
input RST,
input PAR_EN,
input PAR_TYPE,
output  busy,
output  S_DATA
    );
 wire ser_en,done,serializer_output; 
 wire [1:0] sel_line;
 reg start=1'b0,stop=1'b0;
 wire parity_bit;
 
 
Serializer  A1 (.in_data(P_DATA),
               .enable(ser_en),
               .DATA_VALID_S(DATA_VALID),
               .CLK(CLK),     
               .RST(RST),
               .done(done),
               .out_data(serializer_output));


FSM A2  (.valid(DATA_VALID),
         .done(done),
         .CLK(CLK),
         .RST(RST),
         .PAR_EN(PAR_EN),
         .busy(busy),
         .ser_en(ser_en),
         .sel_line(sel_line));
         
MUX A3  (.IN1(serializer_output),         
         .IN2(start),
         .IN3(parity_bit),
         .IN4(stop),
         .sel_line(sel_line),
         .out(S_DATA));  
         
         
parity_check A4 
    (   .data(P_DATA),
        .DATA_VALID(DATA_VALID),    
        .parity_type(PAR_TYPE),
        .parity_bit(parity_bit));              
endmodule
