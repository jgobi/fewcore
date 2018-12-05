module fewcore (clk,reset);
	input clk, reset;

	//inout [31:0] pc;
	reg [4:0] lastRd;
	wire [31:0] pcBranch;

	// ====== CONTROLE
	wire originPc, isLoad, isBranch, mem_write_enabled, mem_read_enabled, banco_write_enabled,fwd_rs1,fwd_rs2;
	// ======= FIM CONTROLE

	wire [4:0] inst_rd_f, inst_rd_e, inst_rs1_f, inst_rs2_f;
	wire [31:0] inst_rs1_f_v, inst_rs2_f_v, inst_rs2_e_v, inst_imm_f_v, current_pc_v;
	wire [11:0] dec_code;

	wire [31:0] rd_v_w;
	wire [4:0] rd_w;

	wire [31:0] forwarding;

	wire [31:0] exec_out, mem_address_e, mem_address_w, write_data, mem_data_out, lastRd_v;

	reg isLoad_f_to_mem;

	always @(posedge clk) begin
		isLoad_f_to_mem <= isLoad;
	end

	memData memData_m(
		.clk(clk),
		.writeAddress(mem_address_w),
		.readAddress(mem_address_e),
		.data(write_data),
		.writeEnabled(mem_write_enabled),
		.readEnabled(isLoad_f_to_mem),
		.out(mem_data_out)
	);

	bancoRegistrador bancoRegistrador_m(
		.clk(clk),
		.reset(reset),
		.rs1(inst_rs1_f),
		.rs2(inst_rs2_f),
		.data(write_data),
		.rd(rd_w),
		.wEn(banco_write_enabled),
		.r1(inst_rs1_f_v),
		.r2(inst_rs2_f_v)
	);

	control control_m(
		.clk(clk),
		.reset(reset),
		.lastRD(lastRd_v),
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
		.writeEnabled(writeEnabled_f)
	);


	//reg [31:0] rs1_f_v, rs2_f_v, rd_f, imm_f_v, code_f, isLoad_f, isBranch_f, old_pc_v, FB;
	reg [31:0] rs1_f_v, rs2_f_v, imm_f_v, old_pc_v, FB;
	reg [11:0] code_f;
	reg [4:0] rd_f;
	reg isLoad_f, isBranch_f, fwd_rs1_r, fwd_rs2_r;

	always @(posedge clk) begin
		rs1_f_v    <= inst_rs1_f_v;
		rs2_f_v    <= inst_rs2_f_v;
		rd_f       <= inst_rd_f;
		imm_f_v    <= inst_imm_f_v;
		code_f     <= dec_code;
		isLoad_f   <= isLoad;
		isBranch_f <= isBranch;
		old_pc_v   <= current_pc_v;
		fwd_rs1_r  <= fwd_rs1;
		fwd_rs2_r  <= fwd_rs2;
	end


	execute execute_m(
		.clk(clk),
		.reset(reset),
		.memData(mem_data_out),
		.operation(code_f),
		.rs1(rs1_f_v),
		.rs2(rs2_f_v),
		.imm(imm_f_v),
		.rs1_fwd(fwd_rs1),
		.rs2_fwd(fwd_rs2),
		.isBranch(isBranch_f),
		.resultALU(mem_address_e),
		.pc(old_pc_v),
		.new_pc(pcBranch),
		.execOut(exec_out),
		.lastRd(lastRd_v),
		.originPc(originPc)
	);


	reg [31:0] pcBranch_e, exec_out_e, rs2_e_v;
	reg [4:0] rd_e;
	reg writeEnabled_e;

	always @(posedge clk) begin
		writeEnabled_e <= writeEnabled_f;
		rd_e       <= rd_f;
		rs2_e_v    <= rs2_f_v;
		pcBranch_e <= pcBranch;
		exec_out_e <= exec_out;
	end


	write write_m(
		.clk(clk),
		.writeEnabled(writeEnabled_e), // TODO.
		.rd(rd_e),
		.dataAlu(exec_out_e),
		.memAddress(mem_address_w),
		.rdAddress(rd_w),
		.dataOut(write_data)
	);

endmodule
