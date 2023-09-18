`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2021 03:46:52 PM
// Design Name: 
// Module Name: top_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU #( parameter data_width=8,alu_fun_bits=4)
(input [data_width-1:0] A,
input [data_width-1:0] B,
input [alu_fun_bits-1:0] ALU_FUN,
input Enable,
input CLK,
input RST,
output reg [data_width-1:0] ALU_OUT,
output reg OUT_VALID
    );

reg [data_width-1:0] temp;
    
always@(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
    ALU_OUT<={data_width-1{1'b0}};
    OUT_VALID<=1'b0;
    end
    else
    if(Enable)
    begin
    ALU_OUT<=temp;
    OUT_VALID<=1'b1;
    end
    else
    begin
    ALU_OUT<={data_width-1{1'b0}};
    OUT_VALID<=1'b0;
    end
end    


always@(*)
begin
    case(ALU_FUN[3:2])
    2'b00:begin
                if(ALU_FUN[1:0]==2'b00)
                begin
                    temp=A+B;
                end
                else if(ALU_FUN[1:0]==2'b01)
                begin
                    temp=A-B;
                end
                else if(ALU_FUN[1:0]==2'b10)
                begin
                    temp=A*B;
                end
                else 
                begin
                    temp=A/B;
                end
            end
    2'b01:begin
                if(ALU_FUN[1:0]==2'b00)
                begin
                    temp=A&B;
                end
                else if(ALU_FUN[1:0]==2'b01)
                begin
                    temp=A|B;
                end
                else if(ALU_FUN[1:0]==2'b10)
                begin
                    temp=~(A&B);
                end                                
                else
                begin
                    temp=~(A|B);
                end                
            end
    2'b10:begin
                if(ALU_FUN[1:0]==2'b00)
                begin
                    temp=A^B;
                end
                else if(ALU_FUN[1:0]==2'b01)
                begin
                    temp=~(A^B);
                end  
                else if(ALU_FUN[1:0]==2'b10)
                begin
                    if(A==B)
                    temp=16'b0000000000000001;
                    else
                    temp=16'b0000000000000000;
                end  
                else 
                begin
                    if(A>B)
                    temp=16'b0000000000000010;
                    else
                    temp=16'b0000000000000000;
                end                                              
            end 
    2'b11:begin
                if(ALU_FUN[1:0]==2'b00)
                begin
                    if(A<B)
                    temp=16'b0000000000000001;
                    else
                    temp=16'b0000000000000000;
                end                  
                else if(ALU_FUN[1:0]==2'b01)
                begin
                    temp=A>>1;
                end
                else if(ALU_FUN[1:0]==2'b10)
                begin
                    temp=A<<1;
                end
                else
                    temp=16'b0000000000000000;                
            end 
    default:begin
                temp=16'b0000000000000000;
            end                                                      
            endcase    
end



    
endmodule
