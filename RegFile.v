`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2021 08:14:14 PM
// Design Name: 
// Module Name: reg_file
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


module RegFile #(parameter regno=16,data_width=8,address_bits=4)(
input [data_width-1:0] WrData,
input [address_bits-1:0] Address,
input WrEn,
input RdEn,
input CLK,
input RST,
output reg [data_width-1:0] RdData,
output  [data_width-1:0] REG0,
output  [data_width-1:0] REG1,
output  [data_width-1:0] REG2,
output  [data_width-1:0] REG3,
output  [data_width-1:0] REG4,
output  [data_width-1:0] REG5
    );
    
reg [data_width-1:0] Reg_file [regno-1:0];

always@(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
    Reg_file[0]<={data_width-1{1'b0}};
    Reg_file[1]<={data_width-1{1'b0}};
    Reg_file[2]<={data_width-1{1'b0}};
    Reg_file[3]<={data_width-1{1'b0}};
    Reg_file[4]<={data_width-1{1'b0}};
    Reg_file[5]<={data_width-1{1'b0}};
    Reg_file[6]<={data_width-1{1'b0}};
    Reg_file[7]<={data_width-1{1'b0}};
    Reg_file[8]<={data_width-1{1'b0}};
    Reg_file[9]<={data_width-1{1'b0}};
    Reg_file[10]<={data_width-1{1'b0}};
    Reg_file[11]<={data_width-1{1'b0}};
    Reg_file[12]<={data_width-1{1'b0}};
    Reg_file[13]<={data_width-1{1'b0}};
    Reg_file[14]<={data_width-1{1'b0}};
    Reg_file[15]<={data_width-1{1'b0}};
    end
    else
    begin
            if(WrEn)
            begin
            Reg_file[Address]<=WrData;
            end
            else if (RdEn)
            begin
            RdData <= Reg_file[Address];
            end
            else
            begin
            RdData<={data_width-1{1'b0}};
            end 
    
    end
    


end 
assign REG0 =Reg_file[0];
assign REG1 =Reg_file[1];
assign REG2 =Reg_file[2];
assign REG3 =Reg_file[3];
assign REG4 =Reg_file[4];
assign REG5 =Reg_file[5];

   
endmodule
