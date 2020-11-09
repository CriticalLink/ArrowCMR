`timescale 1ns / 1ps

module sync_gen(
    input clock_sync,
    input wire reset,    
    input wire enable,           
    input wire [31:0] cnt_max,
    input wire network_sync,
    output reg master_sync,
    output reg interrupt_sig
    );

    reg signed [15:0] master_cnt;   
    reg network_sync_old;
    
    initial
    begin
       master_cnt<=0;
       master_sync <= 1'b0;
       interrupt_sig <= 1'b0;
    end
        
    always @(posedge clock_sync)
    begin      
       if (reset==1'b1)
       begin
         master_sync <= 1'b0;  
         master_cnt <= 0;   
         interrupt_sig <= 1'b0;  
       end
       else if(enable==1'b1)
       begin 
         master_cnt <= master_cnt+1; 
         if ( (master_cnt>=cnt_max-1) || (network_sync==1'b1 && network_sync_old==1'b0))
         begin
           master_sync <= 1'b1;  
           master_cnt <= 0;    
           interrupt_sig <= 1'b1;  
         end
         else 
        if (master_cnt==20) // Make sure sync pulse is 2 clocks wide
         begin
           master_sync <= 1'b0;
           interrupt_sig <= 1'b0;
         end
                  
         network_sync_old=network_sync;
       end   
    end               
     
    endmodule
