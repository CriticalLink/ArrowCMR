`timescale 1ns / 1ps

/* This module synchronizes different clock domains or reduces the likelihood
   of metastability issues from a non-clocked domain by routing the signal
   through a couple of flip-flops.
*/

module sync_domain
(
    input wire clk,
    input wire in_wire,
    output wire out_wire,
    input wire rst
);

reg in_z1;
reg in_z2;

assign out_wire = in_z2;

always @(posedge clk)
begin
    if (rst)
    begin
        in_z1 <= 0;
        in_z2 <= 0;
    end
    else
    begin
        in_z1 <= in_wire;
        in_z2 <= in_z1;
    end
end

endmodule
