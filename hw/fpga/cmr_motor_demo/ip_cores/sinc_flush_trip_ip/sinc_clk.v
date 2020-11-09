`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2016 02:18:59 PM
// Design Name: 
// Module Name: sinc_mod_clk
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
module sinc_mod_clk(
input sys_clk, /* used to clk filter */
input [15:0] MDIV,
output reg MCLK,
input reset,
input enable
);
    
reg [15:0] clk_count;
   
always @ (posedge sys_clk)
begin
  if (reset)
  begin
    MCLK <= 1'b0;
    clk_count <= 16'b0;        
  end  
  else if(enable)
  begin      
    if (clk_count == MDIV-1)
    begin
      MCLK <= ~MCLK;
      clk_count <= 16'b0;
    end
    else 
      clk_count = clk_count+16'b1;  
  end
end
endmodule
