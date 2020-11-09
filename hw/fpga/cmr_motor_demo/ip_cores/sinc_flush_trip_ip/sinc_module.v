`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2016 03:00:06 PM
// Design Name: 
// Module Name: sinc_module
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

module sinc_module(
input clk,
input mclk, /* used to clk filter */
input reset, /* used to reset filter */
input mdata, /* input data to be filtered */
output wire [15:0] DATA_LATEST, /* filtered output */
output reg [15:0] DATA_SYNCED, /* filtered output */
input [15:0] dec_rate,
input [7:0] S,
input [31:0] fclk_en_cnt,
input pwm_sync,
input sinc_mode,
input [15:0] irq_rate,
output reg data_ready_irq
);

localparam CONT_MODE = 0,
           FLUSH_MODE = 1;

localparam IRQ_WIDTH = 8;
localparam CLOCK_EXPIRED = 32'hFFFFFFFF;

/* Data is read on positive clk edge */
reg [36:0] input_data;
reg [36:0] int_n_zoh;
wire [36:0] diff_1;
wire [36:0] diff_2;
wire [36:0] diff_3;
reg [36:0] dd_1;
reg [36:0] dd_2;
reg [36:0] dd_3;
reg [15:0] word_count;
reg word_clk;
wire [36:0] int_n;
reg [36:0] int_n_1;
reg [36:0] int_n_2;
reg [36:0] int_n_3;
reg [36:0] u_n;

reg [31:0] clk_cnt;
reg [31:0] dec_cycle_cnt;
reg [7:0] irq_clk_cnt;
reg filter_flush;
reg sync_active;
reg pwm_sync_old;

always @ (posedge clk )
begin
  if (reset)
  begin
    clk_cnt <= 32'd0;
    data_ready_irq <= 1'b0;
     filter_flush <= 1'b1;
    irq_clk_cnt <= IRQ_WIDTH;   
    DATA_SYNCED <= 16'b0; 
    pwm_sync_old <= 1'b0;
    sync_active <= 1'b0;
  end
  else
  begin  
    pwm_sync_old <= pwm_sync;  

    if (~pwm_sync_old & pwm_sync)
    begin            
      sync_active <= 1'b1;  // Indicate that first rising edge on sync has been detected
      if (sinc_mode==FLUSH_MODE)
        clk_cnt <= 32'd0;
    end
    else 
    begin
      if ((clk_cnt < fclk_en_cnt) & sync_active) // Only increment timer if counter is not expited and first sync has been detected 
        clk_cnt <= clk_cnt + 32'b1;
    
      if ( dec_cycle_cnt == irq_rate)
      begin
        irq_clk_cnt <= 0;
        DATA_SYNCED <= DATA_LATEST;
      end       
      else if ( clk_cnt == fclk_en_cnt )  
      begin
        filter_flush <= 1'b0;
        clk_cnt <= CLOCK_EXPIRED;
      end
    
      if(irq_clk_cnt < IRQ_WIDTH)
      begin      
        if (irq_clk_cnt == 0)
        begin
          //DATA_SYNCED <= DATA_LATEST;
          data_ready_irq <= 1'b1;
          if(sinc_mode==FLUSH_MODE)
            filter_flush <= 1'b1;
        end
                
        irq_clk_cnt <= irq_clk_cnt + 1;
      end
      else
        data_ready_irq <= 1'b0;
    end
  end
end

/*Perform the Sinc action*/
always @ (mdata)
//always @ (posedge mclk)
  if(mdata==0)
    input_data <= 37'd0; 
  else
    input_data <= 37'd1;

/*Accumulator (Integrator) Perform the accumulation (IIR) at the speed of the modulator. Z = one sample delay MCLKOUT = modulators conversion bit rate */
always @ (negedge mclk, posedge reset, posedge filter_flush)
begin
  if(reset | filter_flush)
  begin /* initialize acc registers on reset */
    int_n_1 <= 37'd0;
    int_n_2 <= 37'd0;
    int_n_3 <= 37'd0;
    u_n <= 37'd0;
  end
  else
  begin /*perform accumulation process */  
    u_n <= input_data;      
    int_n_1 <= int_n;
    int_n_2 <= int_n_1;
    int_n_3 <= int_n_2;        
  end
end

assign int_n = u_n + int_n_1 + int_n_1 + int_n_1 - int_n_2 - int_n_2 - int_n_2 + int_n_3;

/*decimation stage (MCLKOUT/WORD_CLK) */
always @ (posedge mclk, posedge reset, posedge filter_flush)
begin
  if (reset | filter_flush)
    word_count <= 16'd0;
  else
  begin
    if ( word_count == dec_rate - 1)
      word_count <= 16'd0;
    else
      word_count <= word_count + 16'b1;
  end
end

always @ ( posedge mclk, posedge reset) 
begin
  if ( reset )
  begin
    word_clk <= 1'b0;
  end    
  else
  begin    
    if ( word_count == dec_rate/2 - 1 )
      word_clk <= 1'b1;  
    else if ( word_count == dec_rate - 1 )
      word_clk <= 1'b0;  
  end
end

always @ ( negedge word_clk, posedge reset, posedge data_ready_irq )
begin
  if ( reset | data_ready_irq )
  begin  
    dec_cycle_cnt <= 1'b0;
  end
  else
  begin
    dec_cycle_cnt <= dec_cycle_cnt + 1'b1;  
  end   
end

/*Differentiator (including decimation stage) Perform the differentiation stage (FIR) at a lower speed. Z = one sample delay WORD_CLK = output word rate */
always @ (negedge word_clk, posedge reset, posedge filter_flush)
begin
  if(reset | filter_flush)
  begin
    int_n_zoh <= 37'd0;
    dd_1 <= 37'd0;
    dd_2 <= 37'd0;
    dd_3 <= 37'd0;
  end
  else
  begin
    int_n_zoh <= int_n;
    dd_1 <= int_n_zoh;
    dd_2 <= diff_1;
    dd_3 <= diff_2;    
  end
end

 assign diff_1 = int_n_zoh - dd_1;
 assign diff_2 = diff_1 - dd_2;
 assign diff_3 = diff_2 - dd_3;
 assign DATA_LATEST = (diff_3>>S > 16'hFFFF) ? 16'hFFFF : diff_3>>S;

endmodule