module fewcore (clk, reset, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	wire [31:0] register15;

	input clk, reset;
	wire [31:0] pcBranch;

	// ====== CONTROLE
	wire originPc, isLoad, isBranch, fwd_rs1,fwd_rs2;
	// ======= FIM CONTROLE

	wire writeEnabled, isStore;
	reg banco_write_enabled, mem_write_enabled;

	wire [4:0] inst_rd_f, inst_rs1_f, inst_rs2_f;
	wire [31:0] inst_rs1_f_v, inst_rs2_f_v, inst_imm_f_v, current_pc_v;
	wire [11:0] dec_code;

	wire [31:0] exec_out, mem_address_e, mem_address_w, reg_write_data, mem_write_data, mem_data_out;


	reg [31:0] exec_out_e, rs2_e_v;
	reg [4:0] rd_e;


	reg [31:0] rs1_f_v, rs2_f_v, imm_f_v, old_pc_v;
	reg [11:0] code_f;
	reg [4:0] rd_f;
	reg isLoad_f, isBranch_f, fwd_rs1_f, fwd_rs2_f, writeEnabled_f;


	memData memData_m(
		.clk(clk),
		.writeAddress(exec_out_e),
		.readAddress(mem_address_e),
		.data(rs2_e_v),
		.writeEnabled(mem_write_enabled),
		.readEnabled(isLoad_f),
		.out(mem_data_out)
	);

	bancoRegistrador bancoRegistrador_m(
		.clk(clk),
		.reset(reset),
		.rs1(inst_rs1_f),
		.rs2(inst_rs2_f),
		.data(exec_out_e),
		.rd(rd_e),
		.wEn(banco_write_enabled),
		.r1(inst_rs1_f_v),
		.r2(inst_rs2_f_v),
		.reg15(register15)
	);

	control control_m(
		.clk(clk),
		.reset(reset),
		.lastRD(rd_f),
		.curRS1(inst_rs1_f),
		.curRS2(inst_rs2_f),
		.ALU_forwarding_RS1(fwd_rs1),
		.ALU_forwarding_RS2(fwd_rs2)
	);

	fetch fetch_m(
		.clk(clk),
		.reset(reset),
		.pcBranch(pcBranch),
		.originPc(originPc),
		.rs1(inst_rs1_f),
		.rs2(inst_rs2_f),
		.rd(inst_rd_f),
		.imm(inst_imm_f_v),
		.code(dec_code),
		.isLoad(isLoad),
		.isBranch(isBranch),
		.pcOut(current_pc_v),
		.writeEnabled(writeEnabled)
	);


	always @(posedge clk) begin
		if (reset) begin
			rs1_f_v             <= 0;
			rs2_f_v             <= 0;
			rd_f                <= 0;
			imm_f_v             <= 0;
			code_f              <= 0;
			isLoad_f            <= 0;
			isBranch_f          <= 0;
			old_pc_v            <= 0;
			fwd_rs1_f           <= 0;
			fwd_rs2_f           <= 0;
			writeEnabled_f      <= 0;
		end else begin
			rs1_f_v             <= inst_rs1_f_v;
			rs2_f_v             <= inst_rs2_f_v;
			rd_f                <= inst_rd_f;
			imm_f_v             <= inst_imm_f_v;
			code_f              <= dec_code;
			isLoad_f            <= isLoad;
			isBranch_f          <= isBranch;
			old_pc_v            <= current_pc_v;
			fwd_rs1_f           <= fwd_rs1;
			fwd_rs2_f           <= fwd_rs2;
			writeEnabled_f      <= writeEnabled;
		end
	end


	execute execute_m(
		.clk(clk),
		.reset(reset),
		.memData(mem_data_out),
		.operation(code_f),
		.rs1(rs1_f_v),
		.rs2(rs2_f_v),
		.imm(imm_f_v),
		.fwd(exec_out_e),
		.rs1_fwd(fwd_rs1_f),
		.rs2_fwd(fwd_rs2_f),
		.isBranch(isBranch_f),
		.resultALU(mem_address_e),
		.pc(old_pc_v),
		.new_pc(pcBranch),
		.execOut(exec_out),
		.originPc(originPc),
		.isStore(isStore)
	);


	always @(posedge clk) begin
		if (reset) begin
			banco_write_enabled <= 0;
			mem_write_enabled   <= 0;
			rd_e                <= 0;
			rs2_e_v             <= 0;
			exec_out_e          <= 0;
		end else begin
			banco_write_enabled <= writeEnabled_f;
			mem_write_enabled   <= writeEnabled_f & isStore;
			rd_e                <= rd_f;
			rs2_e_v             <= fwd_rs2_f ? exec_out_e : rs2_f_v;
			exec_out_e          <= exec_out;
		end
	end

	// O write está implícito aqui

	hexDisplay hexDisplay0(.in(register15[3:0]  ), .out(HEX0));
	hexDisplay hexDisplay1(.in(register15[7:4]  ), .out(HEX1));
	hexDisplay hexDisplay2(.in(register15[11:8] ), .out(HEX2));
	hexDisplay hexDisplay3(.in(register15[15:12]), .out(HEX3));
	hexDisplay hexDisplay4(.in(register15[19:16]), .out(HEX4));
	hexDisplay hexDisplay5(.in(register15[23:20]), .out(HEX5));
	hexDisplay hexDisplay6(.in(register15[27:24]), .out(HEX6));
	hexDisplay hexDisplay7(.in(register15[31:28]), .out(HEX7));
endmodule
