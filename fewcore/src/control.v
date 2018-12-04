// lastRD vem do Execute

module control (clk, reset, lastRD, curRS1, curRS2, ALU_forwarding_RS1, ALU_forwarding_RS2);

input clk, reset;
input [4:0] lastRD, curRS1, curRS2;
output ALU_forwarding_RS1, ALU_forwarding_RS2;

reg [4:0] i_lastRD;

// isso acontece na borda de subida
always @(negedge clk)
	if (reset) i_lastRD <= 5'b0;
	else i_lastRD <= lastRD;

// isso acontece na borda de descida
forwardingBoard forwarding_board_m(
	.lastRd(i_lastRD),
	.rs1(curRS1),
	.rs2(curRS2),
	.encFB({ALU_forwarding_RS1, ALU_forwarding_RS2})
);


endmodule
