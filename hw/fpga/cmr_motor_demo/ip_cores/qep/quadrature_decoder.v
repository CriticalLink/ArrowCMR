`timescale 1ns / 1ps

// This module provides a fairly standard quadrature decoder.

module quadrature_decoder #
(
    parameter COUNTER_WIDTH = 32    
)
(
    input wire clk,
    input wire rst,
    input wire en,
    input wire A,
    input wire B,
    input wire Z,
    input wire latch_strobe,
    input wire A_neg,
    input wire B_neg,
    input wire Z_neg,
    input wire [1:0] idx_mode,
    input wire strobe_en,
    input wire cnt_dir,
    input wire [COUNTER_WIDTH - 1:0] cnt_wrap,
    input wire [COUNTER_WIDTH - 1:0] M,
    
    output reg idx_strobe,
    output reg trans_err_strobe,
    
    output reg dir_status,
    output reg dir_strobe_latch,
    output reg [COUNTER_WIDTH - 1:0] cnt,
    output reg [COUNTER_WIDTH - 1:0] cnt_idx_latch,
    output reg [COUNTER_WIDTH - 1:0] cnt_strobe_latch,
    output reg [COUNTER_WIDTH - 1:0] N_by_M,
    output reg [COUNTER_WIDTH - 1:0] N_by_1,
    output reg [COUNTER_WIDTH - 1:0] N_by_M_strobe_latch,
    output reg [COUNTER_WIDTH - 1:0] N_by_1_strobe_latch,
    output reg [COUNTER_WIDTH - 1:0] tcnt_N_by_M,
    output reg [COUNTER_WIDTH - 1:0] tcnt_N_by_1
);

wire cnt_en;
wire dir;

wire xA;
wire xB;
wire xZ;

reg xA_z1;
reg xB_z1;
reg xZ_z1;

reg tcnt_run;
reg [COUNTER_WIDTH - 1:0] trans_cnt;

assign xA = A^A_neg;
assign xB = B^B_neg;
assign xZ = Z^Z_neg;

assign cnt_en = xA^xA_z1^xB^xB_z1;
assign dir = cnt_dir^(xA^xB_z1);

always @(posedge clk)
begin
    xA_z1 <= xA;
    xB_z1 <= xB;
    xZ_z1 <= xZ;
    
    if (rst)
    begin
        xA_z1 <= 0;
        xB_z1 <= 0;
        xZ_z1 <= 0;
    end
end

always @(posedge clk)
begin
    if (tcnt_run && tcnt_N_by_1 != {COUNTER_WIDTH{1'b1}})
      tcnt_N_by_1 <= tcnt_N_by_1 + 1;
    
    if (tcnt_run && tcnt_N_by_M != {COUNTER_WIDTH{1'b1}})
      tcnt_N_by_M <= tcnt_N_by_M + 1;    

    if (rst)
    begin
        cnt <= 0;
        dir_status <= 0;
        tcnt_N_by_M <= 1;
        tcnt_N_by_1 <= 1;
        tcnt_run <= 0;        
        N_by_M <= 32'hFFFFFFFF;
        N_by_1 <= 32'hFFFFFFFF;
        trans_cnt <= -1;
    end
    else if (en && cnt_en)
    begin
        if (dir)
            if (cnt == 0)
                cnt <= cnt_wrap;
            else
                cnt <= cnt - 1;
        else
            if (cnt == cnt_wrap)
                cnt <= 0;
            else
                cnt <= cnt + 1;                

        dir_status <= dir;                
        if(tcnt_run != 0) // Check if we the is first pass (tcnt=0). If yes, we do not have a valid cnt to assign to N_by_1
          N_by_1 <= tcnt_N_by_1;
        tcnt_N_by_1 <= 1;
        tcnt_run <= 1;        
        
        if(trans_cnt == M-1)
        begin         
          N_by_M <= tcnt_N_by_M;
          tcnt_N_by_M <= 1;          
          trans_cnt <= 0;
        end
        else
          begin
          trans_cnt <= trans_cnt+1;
        end
          
    end
end

always @(posedge clk)
begin
    idx_strobe <= 0;

    if (rst)
        cnt_idx_latch <= 0;    
    else if (en && ((idx_mode == 'b01 && xZ && !xZ_z1) || (idx_mode == 'b10 && !xZ && xZ_z1)))
    begin
        cnt_idx_latch <= cnt;
        idx_strobe <= 1;
    end
end

always @(posedge clk)
begin
    trans_err_strobe <= 0;

    if (en && xA != xA_z1 && xB != xB_z1)
        trans_err_strobe <= 1;
end

always @(posedge clk)
begin
    if (rst)
    begin        
        cnt_strobe_latch <= 0;
        N_by_M_strobe_latch <= 32'hFFFFFFFF;
        N_by_1_strobe_latch <= 32'hFFFFFFFF;
        dir_strobe_latch<=0;
    end
    else if (en && strobe_en && latch_strobe)
    begin
        cnt_strobe_latch <= cnt;
        N_by_M_strobe_latch <= N_by_M;
        N_by_1_strobe_latch <= N_by_1;
        dir_strobe_latch<=dir_status;
    end
end

endmodule
