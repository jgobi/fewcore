// lastRD vem do Execute

module control (clk, reset, lastRD, curRS1, curRS2, ALU_forwarding_RS1, ALU_forwarding_RS2);

input clk, reset;
input [4:0] lastRD, curRS1, curRS2;
output reg ALU_forwarding_RS1, ALU_forwarding_RS2;

wire i_FB_1;
wire i_FB_2;

// isso acontece na borda de subida
always @(negedge clk) begin
	ALU_forwarding_RS1 <= i_FB_1;
	ALU_forwarding_RS2 <= i_FB_2;
end
// isso acontece na borda de descida
forwardingBoard forwarding_board_m(
	.lastRd(lastRD),
	.rs1(curRS1),
	.rs2(curRS2),
	.encFB_1(i_FB_1),
	.encFB_2(i_FB_2)
);

endmodule
