module newPc(clk,pc,pcBranch,originPc,pcOut);
	//nca mude originPc durante o clock alto
	parameter PCLEN = 32;

	input clk,originPc;
	input [PCLEN-1:0] pcBranch;

	inout [PCLEN-1:0] pc;

	output reg [PCLEN-1:0] pcOut;

	reg [PCLEN-1:0] pcPlus4, _pcBranch, lastPc;

	assign pc = originPc ? _pcBranch : pcPlus4;

	always @(posedge clk) begin
		lastPc <= pc;
	end

	always @(negedge clk) begin
		pcOut     <= lastPc;
		_pcBranch <= pcBranch;
		pcPlus4   <= pc + 10'b100;
	end

endmodule
