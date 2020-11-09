`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Analog Devices
// Engineer: Jens Sorensen
// 
// Create Date: 12/17/2019 01:04:41 PM
// Design Name: 
// Module Name: sinc_trip
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

module sinc_trip(
input clk_trip,
input mclk_trip, /* used to clk filter */
input reset_trip, /* used to reset filter */
input mdata_trip, /* input data to be filtered */
input [15:0] dec_rate_trip,
input en_trip,
input [15:0] lmax_trip,
input [15:0] lmin_trip,
input [3:0] lcnt_trip,
input [3:0] lwin_trip,
output wire [15:0] filter_out_trip, /* filtered output */
output reg trip_status,
output reg trip_pin
);

reg [15:0] input_data;
wire [15:0] int_n;
reg [15:0] int_n_1;
reg [15:0] int_n_2;
reg [15:0] int_n_3;
reg [15:0] u_n;
reg [15:0] word_count;
reg word_clk;
reg [15:0] int_n_zoh;
wire [15:0] diff_1;
wire [15:0] diff_2;
wire [15:0] diff_3;
reg [15:0] dd_1;
reg [15:0] dd_2;
reg [15:0] dd_3;
reg lim_exceed;
reg [7:0] window;

integer i;
integer number_of_trips;

/*Perform the Sinc action*/
always @ (mdata_trip)
//always @ (posedge mclk)
  if(mdata_trip==0)
    input_data <= 16'd0; 
  else
    input_data <= 16'd1;

/*Accumulator (Integrator) Perform the accumulation (IIR) at the speed of the modulator. Z = one sample delay MCLKOUT = modulators conversion bit rate */
always @ (negedge mclk_trip, posedge reset_trip)
begin
  if(reset_trip)
  begin /* initialize acc registers on reset */
    int_n_1 <= 16'd0;
    int_n_2 <= 16'd0;
    int_n_3 <= 16'd0;
    u_n <= 16'd0;
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
always @ (posedge mclk_trip, posedge reset_trip)
begin
  if (reset_trip)
    word_count <= 16'd0;
  else
  begin
    if ( word_count == dec_rate_trip - 1)
      word_count <= 16'd0;
    else
      word_count <= word_count + 16'b1;
  end
end

always @ ( posedge mclk_trip, posedge reset_trip) 
begin
  if ( reset_trip )
  begin
    word_clk <= 1'b0;
  end    
  else
  begin    
    if ( word_count == dec_rate_trip/2 - 1 )
      word_clk <= 1'b1;  
    else if ( word_count == dec_rate_trip - 1 )
      word_clk <= 1'b0;  
  end
end

/*Differentiator (including decimation stage) Perform the differentiation stage (FIR) at a lower speed. Z = one sample delay WORD_CLK = output word rate */
always @ (negedge word_clk, posedge reset_trip)
begin
  if(reset_trip)
  begin
    int_n_zoh <= 16'd0;
    dd_1 <= 16'd0;
    dd_2 <= 16'd0;
    dd_3 <= 16'd0;
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
 assign filter_out_trip = diff_3;
 
always @ ( posedge word_clk, posedge reset_trip) 
  if(reset_trip)
  begin
    lim_exceed <= 1'b0;
  //         trip<=1'b1;
  end
  else 
  begin
     if(filter_out_trip > lmax_trip | filter_out_trip < lmin_trip)
     begin
       lim_exceed <= 1'b1;
//     if(en_trip)
//       begin
  //       trip<=1'b0;
//       end
     end
     else
     begin
       lim_exceed <= 1'b0;
  //            trip<=1'b1;
     end
 end
 
 always @ (negedge word_clk, posedge reset_trip)
 begin
   if(reset_trip)
   begin
     window <= 8'b0;     
   end
   else
   begin
     window <= window<<1;
     window[0] <= lim_exceed;
   end
 end
 
 always @ (negedge word_clk, posedge reset_trip)
 begin
   if(reset_trip)
   begin
     number_of_trips <= 0;
   end
   
   else
   begin
     //number_of_trips = 0;
     //for(i=0; i<lwin_trip; i=i+1)
     //begin
//       number_of_trips = number_of_trips + window[i];
//     end
    if(lwin_trip==1)        
    begin
        number_of_trips <= window[0];
    end
    else if(lwin_trip==2)        
    begin
        number_of_trips <= window[0] + window[1];
    end
    else if(lwin_trip==3)        
    begin
        number_of_trips <= window[0] + window[1] + window[2];
    end
    else if(lwin_trip==4)
    begin
        number_of_trips <= window[0] + window[1] + window[2] + window[3];
    end
    else if(lwin_trip==5)
    begin
        number_of_trips <= window[0] + window[1] + window[2] + window[3] + window[4];
    end
    else if(lwin_trip==6)
    begin
        number_of_trips <= window[0] + window[1] + window[2] + window[3] + window[4] + window[5];
    end
    else if(lwin_trip==7)
    begin
        number_of_trips <= window[0] + window[1] + window[2] + window[3] + window[4] + window[5] + window[6];
    end
    else if(lwin_trip==8)
    begin
       number_of_trips <= window[0] + window[1] + window[2] + window[3] + window[4] + window[5] + window[6] + window[7];
    end
    else
    begin
       number_of_trips <= 0;
    end

   end
 end
   
 always @ ( posedge mclk_trip, posedge reset_trip) 
 begin 
  if(reset_trip)
  begin
    trip_status<=1'b0;
    trip_pin<=1'b1;
  end

  else
  begin 
     if((number_of_trips>=lcnt_trip) & en_trip)
     begin
       trip_status<=1'b1;
       trip_pin<=1'b0;
     end
  end
 end

endmodule

