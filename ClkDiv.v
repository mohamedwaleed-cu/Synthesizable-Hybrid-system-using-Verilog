`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2021 01:22:10 AM
// Design Name: 
// Module Name: clock_divider
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


module ClkDiv#(parameter div_bits=8)(
input   i_ref_clk,
input   i_rst_n,
input   i_clk_en,
input  [div_bits-1:0] i_div_ratio,
output       o_div_clk
    );
    
 reg [2:0] counter=3'b000;
 reg flag;  //used in odd division to indicate the end of low clk period
 wire [div_bits-1:0] temp;
 wire state;
 wire is_one,is_zero,clk_en;
 reg div_clk;

 
 always@(posedge i_ref_clk or negedge i_rst_n)
 begin
    if(!i_rst_n)
    begin
        div_clk<=0;
        counter<=0;
        flag<=0;
    end
    else
    begin
            if(clk_en)
            begin
            case(state)
            1'b1: begin         //odd divider state
                        if(counter==temp)
                        begin
                        div_clk<=~div_clk;
                        counter<=3'b000;
                        flag<=1;
                        end
                        else if(flag && (counter==temp-1))
                        begin
                        div_clk<=~div_clk;
                        counter<=0;
                        flag<=0;
                        end
                        else
                        begin
                        div_clk<=div_clk;
                        counter<=counter+1;
                        flag<=flag;
                        end
                     end
             1'b0:begin         //even divider state
                         if(counter==temp-1)
                            begin
                            div_clk<=~div_clk;
                            counter<=3'b000;
                            end
                            else
                            begin
                            div_clk<=div_clk;
                            counter<=counter+1;
                            end            
                  end 
             default:      div_clk<=div_clk;      
            endcase
            end  
            else   // if not clock enable
            begin
            counter<=0;
            div_clk<=0;
            flag<=0;
            end            
    end          
 end
    
assign state = (i_div_ratio[0])?1'b1:1'b0;    //state=1 stands for odd division & state=0 stands for even division
assign temp = (state)?((i_div_ratio-1)>>1):(i_div_ratio>>1);
assign is_one  = (i_div_ratio == 1'b1) ;   //check division ratio=1
assign is_zero = ~|i_div_ratio ;           //check_division ratio=0
assign clk_en = i_clk_en & !is_one & !is_zero;
assign o_div_clk = clk_en ? div_clk : i_ref_clk ;      
endmodule
