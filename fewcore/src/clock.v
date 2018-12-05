module clock (output reg clk);
	initial begin
		clk = 0;
	end
	always #5 begin
		clk = ~clk;
	end
endmodule
