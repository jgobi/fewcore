module forwardingBoard(lastRd,rs1,rs2,encFB);
	input [4:0] lastRd,rs1,rs2;
	output [1:0] encFB;
	
	assign encFB[0] = (lastRd == rs1 && rs1 != 0);
	assign encFB[1] = (lastRd == rs2 && rs2 != 0);
endmodule
