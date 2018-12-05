module fewcore (reset);
	input reset;

	wire clk;
	clock clock_m(clk);

	//inout [31:0] pc;
	wire [31:0] pcBranch;

	// ====== CONTROLE
	wire originPc, isLoad, isBranch,  mem_read_enabled,fwd_rs1,fwd_rs2;
	// ======= FIM CONTROLE

	wire writeEnabled, isStore;
	reg banco_write_enabled, mem_write_enabled;

	wire [4:0] inst_rd_f, inst_rd_e, inst_rs1_f, inst_rs2_f;
	wire [31:0] inst_rs1_f_v, inst_rs2_f_v, inst_rs2_e_v, inst_imm_f_v, current_pc_v;
	wire [11:0] dec_code;

	wire [31:0] forwarding;

	wire [31:0] exec_out, mem_address_e, mem_address_w, reg_write_data, mem_write_data, mem_data_out;


	reg [31:0] exec_out_e, rs2_e_v; //, pcBranch_e;
	reg [4:0] rd_e;


	//reg [31:0] rs1_f_v, rs2_f_v, rd_f, imm_f_v, code_f, isLoad_f, isBranch_f, old_pc_v, FB;
	reg [31:0] rs1_f_v, rs2_f_v, imm_f_v, old_pc_v, FB;
	reg [11:0] code_f;
	reg [4:0] rd_f;
	reg isLoad_f, isBranch_f, fwd_rs1_f, fwd_rs2_f, writeEnabled_f;


	memData memData_m(
		.clk(clk),
		.writeAddress(mem_address_w),
		.readAddress(mem_address_e),
		.data(mem_write_data),
		.writeEnabled(mem_write_enabled),
		.readEnabled(isLoad_f),
		.out(mem_data_out)
	);

	bancoRegistrador bancoRegistrador_m(
		.clk(clk),
		.reset(reset),
		.rs1(inst_rs1_f[3:0]),
		.rs2(inst_rs2_f[3:0]),
		.data(reg_write_data),
		.rd(rd_e[3:0]),
		.wEn(banco_write_enabled),
		.r1(inst_rs1_f_v),
		.r2(inst_rs2_f_v)
	);

	control control_m(
		.clk(clk),
		.reset(reset),
		.lastRD(rd_e),
		.curRS1(inst_rs1_f),
		.curRS2(inst_rs2_f),
		.ALU_forwarding_RS1(fwd_rs1),
		.ALU_forwarding_RS2(fwd_rs2)
	);

	fetch fetch_m(
		.clk(clk),
		.reset(reset),
		//.pc(pc),
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
		rs1_f_v    <= inst_rs1_f_v;
		rs2_f_v    <= inst_rs2_f_v;
		rd_f       <= inst_rd_f;
		imm_f_v    <= inst_imm_f_v;
		code_f     <= dec_code;
		isLoad_f   <= isLoad;
		isBranch_f <= isBranch;
		old_pc_v   <= current_pc_v;
		fwd_rs1_f  <= fwd_rs1;
		fwd_rs2_f  <= fwd_rs2;
		writeEnabled_f <= writeEnabled;
	end


	execute execute_m(
		.clk(clk),
		.reset(reset),
		.memData(mem_data_out),
		.operation(code_f),
		.rs1(rs1_f_v),
		.rs2(rs2_f_v),
		.imm(imm_f_v),
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
		banco_write_enabled <= writeEnabled_f;
		mem_write_enabled <= writeEnabled_f & isStore;
		rd_e       <= rd_f;
		rs2_e_v    <= rs2_f_v;
		exec_out_e <= exec_out;
	end


	write write_m(
		.clk(clk),
		.dataAlu(exec_out_e),
		.rs2(rs2_e_v),
		.memAddress(mem_address_w),
		.dataOut_r(reg_write_data),
		.dataOut_m(mem_write_data)
	);

endmodule
