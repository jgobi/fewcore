module fewcore (clk, reset);
	input clk, reset;

	reg [31:0] pc;
	reg [4:0] lastRd;
	wire [31:0] pcBranch;

	// ====== CONTROLE
	wire originPc, isLoad, isBranch, mem_write_enabled, banco_write_enabled;
	wire [1:0] mini_scoreboard
	// ======= FIM CONTROLE

	wire [4:0] inst_rd_f, inst_rd_e, inst_rs1, inst_rs2;
	wire [31:0] inst_rs1_v, inst_rs2_v_f, inst_rs2_v_e, isnt_imm_v, current_pc_v;
	wire [11:0] dec_code;

	wire [31:0] rd_v_w;
	wire [4:0] rd_w;

	wire [31:0] forwarding;

	wire [31:0] exec_out, mem_address_e, mem_address_w, write_data, mem_data_out;

	control control_m(
		.mem_write_enabled(mem_write_enabled),
		.banco_write_enabled(banco_write_enabled),
		.mini_scoreboard(mini_scoreboard),
	);

	memDataInterface memDataInterface_m(
		.clk(clk),
		.read_address(mem_address_e),
		.write_address(mem_address_w),
		.data_write(write_data),
		.write_enabled(mem_write_enabled),
		.data_out(mem_data_out)
	);

	bancoRegistrador bancoRegistrador_m(
		.clk(clk),
		.reset(reset),
		.rs1(inst_rs1)
		.rs2(inst_rs2),
		.data(write_data),
		.rd(rd_w),
		.wEn(banco_write_enabled),
		.r1(inst_rs1_v),
		.r2(inst_rs2_v_f)
	);

	fetch fetch_m(
		.clk(clk),
		.reset(reset),
		.pc(pc),
		.pcBranch(pcBranch),
		.originPc(originPc),
		.lastRd(lastRd),
		.rs1_v(inst_rs1_v),
		.rs2_v(inst_rs2_v_f),
		.rs1(inst_rs1),
		.rs2(inst_rs2),
		.rd(inst_rd_f),
		.imm(inst_imm_v),
		.code(dec_code),
		.isLoad(isLoad),
		.isBranch(isBranch),
		.pcOut(current_pc_v),
		.encSB(mini_scoreboard)
	);

	execute execute_m(
		.clk(clk),
		.reset(reset),
		.operation(dec_code),
		.rs1(inst_rs1_v),
		.rs2(inst_rs2_v_f),
		.imm(inst_imm_v),
		.rd(inst_rd_f),
		.forward(forwarding),
		.need_forward(mini_scoreboard),
		.pc(current_pc_v),
		.new_pc(pcBranch),
		.exec_out(exec_out),
		.address_rd(inst_rd_e),
		.content_rs2(inst_rs2_v),
		.originPc(originPc)
	);

	write write_m(
		.clk(clk),
		.writeEnabled,
		.code(dec_code),
		.rd(rd_w),
		.dataAlu(exec_out),
		.memAddress(mem_address_w),
		.rdAddress(rd_w),
		.dataOut(write_data)
	);

endmodule

