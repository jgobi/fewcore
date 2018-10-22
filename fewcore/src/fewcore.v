module fewcore (
	pc
);
	output reg [31:0] pc;
	
	reg clk;
	
	initial begin
		pc <= 0;
		clk <= 0;
	end
	
	always #5 clk <= ~clk;
	
	always @(posedge clk) pc <= pc+4;
	
endmodule

	