module write(clk,writeEnable,code,rd,dataAlu,memAddress,rdAddress,dataOut);
	input clk,writeEnable;
	input [11:0] code;
	input [4:0] rd;
	input [31:0] dataAlu,memAddress;
	
	output [4:0] rdAddress;	
	output reg [31:0] dataOut;
	
	assign rdAddress = rd;
	
	clk,address,data,iWrite,out);
	
	// Execute já devolve o valor pronto para ser gravado
	
	memData memData_m(
		.clk(clk),
		.address(memAddress),
		.data(dataAlu),
		.iWrite(writeEnable),
		.out(dataOut)
	);
	
	
	
		
endmodule 