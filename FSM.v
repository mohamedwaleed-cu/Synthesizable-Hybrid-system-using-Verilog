`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2021 02:54:32 PM
// Design Name: 
// Module Name: FSM
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


module FSM(
input valid,
input done,  //from serializer
input CLK,
input RST,
input PAR_EN,
output reg busy,
output reg ser_en, //enable to serializer
output reg [1:0] sel_line //to MUX
    );
    
reg [2:0] current_state,next_state;  
localparam [2:0] IDLE=3'b000,
                 start=3'b001,     
                 proceed_data=3'b011,
                 parity=3'b010,
                 stop=3'b110;
                    
always@(posedge CLK or negedge RST)
     begin
             if(!RST)
             current_state<=IDLE;
             else
             current_state<=next_state;
     end 
     
 //next_state_logic
 always@(*)
    begin
        case(current_state)
            IDLE:begin
                 if(valid==1 && done==0)   
                 next_state=start;   
                 else
                 next_state=IDLE;   
                 end
            start:begin
                  next_state=proceed_data;  
                  end       
    proceed_data:begin
                 if(done==1)   
                    begin
                         if(PAR_EN==1)
                         next_state=parity;
                         else
                         next_state=stop;
                    end  
                 else 
                        next_state=proceed_data;  
                 end   
         parity:begin
                    next_state=stop;
                end                 
         stop:begin
                    next_state=IDLE;
                end                       
       default:begin
                   next_state=IDLE;
               end             
        endcase
    
    end    
     
     
      
     
//next_state_output_logic
always@(*)
    begin
        case(current_state)
            IDLE:begin
                 busy=0;
                 ser_en=0;
                 sel_line=2'b00;   
                 end
            start:begin
                  busy=1;
                  ser_en=1;
                  sel_line=2'b01;                                 
                  end           
     proceed_data:begin
                  busy=1;  
                  ser_en=1;
                  sel_line=2'b00;  
                  end
            parity:begin
                  busy=1;
                  ser_en=0;
                  sel_line=2'b10;              
                   end
            stop:begin
                  busy=1;
                  ser_en=0;
                  sel_line=2'b11;              
                 end                 
         default:begin
                  busy=0;
                  ser_en=0;
                  sel_line=2'b00;          
                 end            
        endcase
    
    end     
                  
                  

    
endmodule
