module forwardingBoard(lastRd,rs1,rs2,encFB);
	input [4:0] lastRd,rs1,rs2;
	output encFB_1, encFB_2;
	
	assign encFB_1 = (lastRd == rs1 && rs1 != 0);
	assign encFB_2 = (lastRd == rs2 && rs2 != 0);
endmodule
