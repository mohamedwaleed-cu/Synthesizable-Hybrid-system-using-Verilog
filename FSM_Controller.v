`timescale 1ns / 1ps


module FSM_Controller#(parameter config_bits=8,Fun_bits=4)(
input UART_Status,
input Enable,  
input [config_bits-1:0] ALU_Config0,
input [config_bits-1:0] ALU_Config1,
input CLK,
input RST,
output reg [Fun_bits-1:0] ALU_FUN,
output reg ALU_Enable,
output reg CLKG_EN
    );
    
reg [4:0] current_state,next_state,previous_state;  
localparam [4:0] IDLE=5'b00000,
                 Check_ADD=5'b00001,     
                 Check_SUB=5'b00011,
                 Check_MULT=5'b00010,
                 Check_DIV=5'b00110,
                 Check_AND=5'b00111,
                 Check_OR=5'b00101,
                 Check_NAND=5'b00100,
                 Check_NOR=5'b01100,
                 Check_XOR=5'b01101,
                 Check_XNOR=5'b01111,
                 Check_CMP_equal=5'b01110,
                 Check_CMP_smaller=5'b01010,
                 Check_CMP_bigger=5'b01011,
                 Check_shift_right=5'b01001,
                 Check_shift_left=5'b01000,
                 Wait_busy_high=5'b11000,
                 Wait_busy_low=5'b11001;
                    
always@(posedge CLK or negedge RST)
     begin
             if(!RST)
             begin
             current_state<=IDLE;
             end
             else
             begin
             if(current_state!=Wait_busy_low && current_state!=Wait_busy_high )
             begin
             current_state <= next_state;
             previous_state <= current_state;
             end
             else
             begin
             current_state <= next_state;
             previous_state <= previous_state;
             end
             end
     end 
    
 //next_state_logic
 always@(*)
    begin
        case(current_state)
            IDLE:begin
                 if(Enable)   
                 next_state=Check_ADD;   
                 else
                 next_state=IDLE;   
                 end
        Check_ADD:begin
                  if(ALU_Config0[0]==1)  
                  next_state=Wait_busy_high;
                  else
                  next_state=Check_SUB;  
                  end       
        Check_SUB:begin
                  if(ALU_Config0[1]==1)   
                  next_state=Wait_busy_high;
                  else
                  next_state=Check_MULT;  
                  end
        Check_MULT:begin
                   if(ALU_Config0[2]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_DIV;  
                   end                     
        Check_DIV: begin
                   if(ALU_Config0[3]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_AND;  
                   end                 
        Check_AND: begin
                   if(ALU_Config0[4]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_OR;  
                   end                 
        Check_OR: begin
                   if(ALU_Config0[5]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_NAND;  
                   end   
       Check_NAND: begin
                   if(ALU_Config0[6]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_NOR;  
                   end                 
       Check_NOR:  begin
                   if(ALU_Config0[7]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_XOR;  
                   end
       Check_XOR:  begin
                   if(ALU_Config1[0]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_XNOR;  
                   end                   
      Check_XNOR:  begin
                   if(ALU_Config1[1]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_CMP_equal;  
                   end
 Check_CMP_equal:  begin
                   if(ALU_Config1[2]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_CMP_smaller;  
                   end                   
 Check_CMP_smaller:begin
                   if(ALU_Config1[3]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_CMP_bigger;  
                   end                        
 Check_CMP_bigger: begin
                   if(ALU_Config1[4]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_shift_right;  
                   end 
 Check_shift_right:begin
                   if(ALU_Config1[5]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=Check_shift_left;  
                   end                   
 Check_shift_left: begin
                   if(ALU_Config1[6]==1)   
                   next_state=Wait_busy_high;
                   else
                   next_state=IDLE;  
                   end
  Wait_busy_high:  begin
                   if(UART_Status)
                   next_state=Wait_busy_low;
                   else
                   next_state=Wait_busy_high; 
                   end                                                       
  Wait_busy_low:   begin
                   if(!UART_Status)
                   begin 
                           case(previous_state)
                           Check_ADD:begin next_state=Check_SUB; end
                           Check_SUB:begin next_state=Check_MULT; end
                           Check_MULT:begin next_state=Check_DIV; end
                           Check_DIV:begin next_state=Check_AND; end
                           Check_AND:begin next_state=Check_OR; end
                           Check_OR:begin next_state=Check_NAND; end
                           Check_NAND:begin next_state=Check_NOR; end
                           Check_NOR:begin next_state=Check_XOR; end
                           Check_XOR:begin next_state=Check_XNOR; end
                           Check_XNOR:begin next_state=Check_CMP_equal; end
                           Check_CMP_equal:begin next_state=Check_CMP_smaller; end
                           Check_CMP_smaller:begin next_state=Check_CMP_bigger; end
                           Check_CMP_bigger:begin next_state=Check_shift_right; end
                           Check_shift_right:begin next_state=Check_shift_left; end
                           Check_shift_left:begin next_state=IDLE; end
                           default:begin next_state=IDLE; end
                           endcase
                     end
                     else
                     next_state=Wait_busy_low;       
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
                     ALU_FUN=4'b0000;
                     ALU_Enable=1'b0; 
                     CLKG_EN=1'b0;
                     end
            Check_ADD:begin
                      if(ALU_Config0[0]==1)
                      begin
                      ALU_FUN=4'b0000;
                      ALU_Enable=1'b1;
                      CLKG_EN=1'b1;
                      end  
                      else
                      begin
                      ALU_FUN=4'b0000;
                      ALU_Enable=1'b0;
                      CLKG_EN=1'b1;
                      end  
                      end       
            Check_SUB:begin
                      if(ALU_Config0[1]==1)   
                      begin
                      ALU_FUN=4'b0001;
                      ALU_Enable=1'b1;
                      CLKG_EN=1'b1;
                      end
                      else
                      begin
                      ALU_FUN=4'b0000;
                      ALU_Enable=1'b0;
                      CLKG_EN=1'b1;
                      end  
                      end
            Check_MULT:begin
                       if(ALU_Config0[2]==1)   
                       begin
                       ALU_FUN=4'b0010;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end                     
            Check_DIV: begin
                       if(ALU_Config0[3]==1)   
                       begin
                       ALU_FUN=4'b0011;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end                 
            Check_AND: begin
                       if(ALU_Config0[4]==1)   
                       begin
                       ALU_FUN=4'b0100;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end 
                       end                 
            Check_OR: begin
                       if(ALU_Config0[5]==1)   
                       begin
                       ALU_FUN=4'b0101;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end 
                       end   
           Check_NAND: begin
                       if(ALU_Config0[6]==1)   
                       begin
                       ALU_FUN=4'b0110;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end                 
           Check_NOR:  begin
                       if(ALU_Config0[7]==1)   
                       begin
                       ALU_FUN=4'b0111;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end
           Check_XOR:  begin
                       if(ALU_Config1[0]==1)   
                       begin
                       ALU_FUN=4'b1000;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end                   
          Check_XNOR:  begin
                       if(ALU_Config1[1]==1)   
                       begin
                       ALU_FUN=4'b1001;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end 
                       end
     Check_CMP_equal:  begin
                       if(ALU_Config1[2]==1)   
                       begin
                       ALU_FUN=4'b1010;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end                   
     Check_CMP_smaller:begin
                       if(ALU_Config1[3]==1)   
                       begin
                       ALU_FUN=4'b1011;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end                        
     Check_CMP_bigger: begin
                       if(ALU_Config1[4]==1)   
                       begin
                       ALU_FUN=4'b1100;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end 
                       end 
     Check_shift_right:begin
                       if(ALU_Config1[5]==1)   
                       begin
                       ALU_FUN=4'b1101;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end  
                       end                   
     Check_shift_left: begin
                       if(ALU_Config1[6]==1)   
                       begin
                       ALU_FUN=4'b1110;
                       ALU_Enable=1'b1;
                       CLKG_EN=1'b1;
                       end
                       else
                       begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                       end 
                       end                                       
       Wait_busy_high:  begin
                        ALU_FUN=4'b0000;
                        ALU_Enable=1'b0;
                        CLKG_EN=1'b1;
                       end
      Wait_busy_low:  begin
                        ALU_FUN=4'b0000;
                        ALU_Enable=1'b0;
                        CLKG_EN=1'b0;
                        end                                       
           default:begin
                       ALU_FUN=4'b0000;
                       ALU_Enable=1'b0;
                       CLKG_EN=1'b1;
                   end             
            endcase
    
    end     
                  
                  

      
endmodule
