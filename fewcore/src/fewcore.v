module fewcore (clk, reset);
	input clk, reset;

	reg [31:0] pc;
	reg [4:0] lastRd;
	wire [31:0] pcBranch;

	// ====== CONTROLE
	wire originPc, isLoad, isBranch, mem_write_enabled, banco_write_enabled;
	wire [1:0] mini_scoreboard;
	// ======= FIM CONTROLE

	wire [4:0] inst_rd_f, inst_rd_e, inst_rs1_f, inst_rs2_f;
	wire [31:0] inst_rs1_f_v, inst_rs2_f_v, inst_rs2_e_v, inst_imm_f_v, current_pc_v;
	wire [11:0] dec_code;

	wire [31:0] rd_v_w;
	wire [4:0] rd_w;

	wire [31:0] forwarding;

	wire [31:0] exec_out, mem_address_e, mem_address_w, write_data, mem_data_out;

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
		.curRD(inst_rd_f),
		.curRS1(inst_rs1_f),
		.curRS2(inst_rs2_f)
	);

	fetch fetch_m(
		.clk(clk),
		.reset(reset),
		.pc(pc),
		.pcBranch(pcBranch),
		.originPc(originPc),
		.lastRd(lastRd),
		.rs1_v(inst_rs1_f_v),
		.rs2_v(inst_rs2_f_v),
		.rs1(inst_rs1_f),
		.rs2(inst_rs2_f),
		.rd(inst_rd_f),
		.imm(inst_imm_f_v),
		.code(dec_code),
		.isLoad(isLoad),
		.isBranch(isBranch),
		.pcOut(current_pc_v),
		.encSB(mini_scoreboard)
	);


	reg [31:0] rs1_f_v, rs2_f_v, rd_f, imm_f_v, code_f, isLoad_f, isBranch_f, old_pc, FB;

	always @(posedge clk) begin
		rs1_f_v    <= inst_rs1_f_v;
		rs2_f_v    <= inst_rs2_f_v;
		rd_f       <= inst_rd_f;
		imm_f_v    <= inst_imm_f_v;
		code_f     <= dec_code;
		isLoad_f   <= isLoad;
		isBranch_f <= isBranch;
		old_pc_v   <= current_pc_v;
		FB         <= mini_scoreboard;
	end


	execute execute_m(
		.clk(clk),
		.reset(reset),
		.operation(code_f),
		.rs1(rs1_f_v),
		.rs2(rs2_f_v),
		.imm(imm_f_v),
		.need_forward(FB),
		.pc(old_pc_v),
		.new_pc(pcBranch),
		.exec_out(exec_out),
		.originPc(originPc)
	);


	reg [31:0] pcBranch_e, exec_out_e, rs2_e_v;
	reg [4:0] rd_e;

	always @(posedge clk) begin
		rd_e       <= rd_f;
		rs2_e_v    <= rs2_f_v;
		pcBranch_e <= pcBranch;
		exec_out_e <= exec_out;
	end


	write write_m(
		.clk(clk),
		.writeEnabled(clk), // TODO.
		.rd(rd_e),
		.dataAlu(exec_out_e),
		.memAddress(mem_address_w),
		.rdAddress(rd_w),
		.dataOut(write_data)
	);

endmodule

