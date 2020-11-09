`timescale 1ns / 1ps

/* This module filters out any two transitions that are spaced less than
   'cnt_lim' + 1 cycles of 'clk' apart.
*/

module min_pulse_width #
(
    parameter COUNTER_WIDTH = 32
)
(
    input wire clk,
    input wire rst,
    input wire in_wire,
    input wire [COUNTER_WIDTH - 1:0] cnt_lim,
    output reg out_reg
);

reg in_z1;
reg [COUNTER_WIDTH - 1:0] cnt;
reg cnt_running;

always @(posedge clk)
begin
    in_z1 <= in_wire;

    if (rst)
    begin
        in_z1 <= 0;
        out_reg <= 0;
        cnt <= 0;
        cnt_running <= 0;
    end
    else if (cnt >= cnt_lim)
    begin
        out_reg <= in_z1;
        cnt <= 0;
        
        if (in_wire != in_z1)
            cnt_running <= 1;
        else
            cnt_running <= 0;
    end
    else if (in_wire != in_z1)
    begin
        cnt <= 0;
        cnt_running <= 1;
    end
    else if (cnt_running)
        cnt <= cnt + 1;
end

endmodule
