module refreshSB(clk,lastRd,rs1,rs2,encSB);
	input clk;
	input [4:0] lastRd,rs1,rs2;
	output reg [1:0] encSB;
	always @(negedge clk) begin
		if(lastRd == rs1) begin
			encSB[1] <= 1'b1;
		end else begin
			encSB[1] <= 1'b0;
		end
		
		if(lastRd == rs2) begin 
			encSB[0] <= 1'b1;
		end else begin
			encSB[0] <= 1'b0;
		end	
	end
endmodule 