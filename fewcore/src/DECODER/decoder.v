module decoder(
		input [31:0] inst,

		output reg [4:0] rs1i,
		output reg [4:0] rs2i,
		output reg [4:0] rdi,
		output reg [31:0] imm,
		output reg [11:0] code,

		output reg isLoad,
		output reg isBranch
	 );

	always @* begin
		rs2i      = 5'b1;
		rs1i      = 5'b1;
		rdi       = 5'b1;
		imm       = 32'b1;
		code      = 12'b1;

		isBranch  = 1'b0;
		isLoad    = 1'b0;
		case (inst[6:0])
			7'b0010111: begin                 // lui
				imm          <= {inst[31:12], {12{1'b0}}};
				rdi          <= inst[11:7];
				rs1i         <= {5{1'b0}};
				rs2i         <= {5{1'b0}};
				code         <= {{5{1'b0}} , inst[6:0]};

				isBranch     <= 1'b0;
				isLoad       <= 1'b0;
			end

			7'b0110111: begin                 // auipc
				imm          <= {inst[31:12], {12{1'b0}}};
				rdi          <= inst[11:7];
				rs1i         <= {5{1'b0}};
				rs2i         <= {5{1'b0}};
				code         <= {{5{1'b0}} , inst[6:0]};

				isBranch     <= 1'b0;
				isLoad       <= 1'b0;
			end

			7'b1101111: begin                             // jal
				imm          <= {{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
				rdi          <= inst[11:7];
				rs1i         <= {5{1'b0}};
				rs2i         <= {5{1'b0}};
				code         <= {{5{1'b0}} , inst[6:0]};

				isBranch     <= 1'b1;
				isLoad       <= 1'b0;
			end
			7'b1100111: begin                             // jalr
				if (inst[14:12] == 3'b000) begin
					imm      <= {{20{inst[31]}},inst[31:20]};
					rs1i     <= inst[19:15];
					rdi      <= inst[11:7];
					rs2i     <= {5{1'b0}};
					code     <= {{2{1'b0}} ,inst[14:12] , inst[6:0]};

					isBranch <= 1'b1;
					isLoad   <= 1'b0;
				end
			end
			7'b1100011: begin                             // bXX
				if((inst[14] == 1'b1)||(inst[14:13] == 2'b00)) begin
					imm      <= {{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
					rdi      <= {5{1'b0}};
					rs1i     <= inst[19:15];
					rs2i     <= inst[24:20];
					code     <= {{2{1'b0}} ,inst[14:12] , inst[6:0]};

					isBranch <= 1'b1;
					isLoad   <= 1'b0;
				end
			end
			7'b0000011: begin                             // lX
				if(((inst[14] == 1'b0)&&(inst[13:12] != 2'b11))||(inst[14:13] == 2'b10)) begin // lX
					imm      <= {{20{inst[31]}},inst[31:20]};
					rs1i     <= inst[19:15];
					rdi      <= inst[11:7];
					rs2i     <= {5{1'b0}};
					code     <= {{2{1'b0}} ,inst[14:12] , inst[6:0]};

					isBranch <= 1'b0;
					isLoad   <= 1'b1;
				end
			end
			7'b0100011: begin                             // sX
				if((inst[14] == 1'b0)&&(inst[13:12] != 2'b11)) begin    // sX
					imm      <= {{20{inst[31]}},inst[31:25],inst[11:7]} ;
					rs1i     <= inst[19:15];
					rs2i     <= inst[24:20];
					rdi      <= {5{1'b0}};
					code     <= {{2{1'b0}} ,inst[14:12] , inst[6:0]};

					isBranch <= 1'b0;
					isLoad   <= 1'b0;
				end
			end
			7'b0010011: begin // arith & logic imm
				if (inst[13:12] != 2'b01)begin // arith imm
					rdi      <= inst[11:7];
					rs1i     <= inst[19:15];
					rs2i     <= {5{1'b0}};
					imm      <= {{20{inst[31]}},inst[31:20]};
					code     <= {2'b00 ,inst[14:12] , inst[6:0]};

					isBranch <= 1'b0;
					isLoad   <= 1'b0;
				end else begin // sw & etc
					rdi      <= inst[11:7];
					rs1i     <= inst[19:15];
					rs2i     <= {5{1'b0}};
					imm      <= {{20{inst[31]}},inst[31:20]};
					code     <= {1'b0, inst[30] ,inst[14:12] , inst[6:0]};  // Diferentiation between SRLI and SRAI is implicit on code

					isBranch <= 1'b0;
					isLoad   <= 1'b0;
				end
			end
			7'b0110011: begin // arith and logic
				if({inst[31], inst[29:25]} == 6'b000000) begin //add,sllst,sltu,xor,srl,or,and,sub,sra
					rs2i     <= inst[24:20];
					rs1i     <= inst[19:15];
					rdi      <= inst[11:7];
					imm      <= {32{1'b0}};
					code     <= {inst[30],inst[25] ,inst[14:12] , inst[6:0]};

					isBranch <= 1'b0;
					isLoad   <= 1'b0;
				end
			end
		endcase
	end

endmodule
