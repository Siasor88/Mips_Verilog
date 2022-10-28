	module Signal_control(
		input clk,
		input [31:0] inst,
		input [5:0] opcode,
		output reg reg_dst,
		output reg branch,
		output reg mem_read,
		output reg mem_to_reg,
		output reg mem_write,
		output reg alu_src,
		output reg reg_write,
		output [5:0] alu_op,
		output reg extend,
		output reg is_byte,
		output reg jump,
		output reg f_to_w,
		output reg w_to_f,
		output reg jal,
		output reg f_reg_write,
		output reg is_f,
		output reg halted
	);

		assign alu_op = opcode;
		parameter ADDI = 6'b001000;
		parameter ADDIU = 6'b001001;
		parameter ANDI = 6'b001100;
		parameter XORI = 6'b001110;
		parameter ORI = 6'b001101;
		parameter BEQ = 6'b000100;
		parameter BNE = 6'b000101;
		parameter BLEZ = 6'b000110;
		parameter BGTZ = 6'b000111;
		parameter LW = 6'b100011;
		parameter SW = 6'b101011;
		parameter LB = 6'b100000;
		parameter SB = 6'b101000;
		parameter SLTI = 6'b001010;
		parameter LUI = 6'b001111;
		parameter J = 6'b000010;
		parameter JAL = 6'b000011;
		parameter FTYPE = 6'b010001;
		parameter divisor = 4;
		reg [2:0] state = 0;


		integer counter = 0;




/* verilator lint_off LATCH */
always@(opcode, inst)
begin
	jump = 0;
	reg_dst = 1;
	reg_write = 1;
	branch = 0;
	mem_read = 0;
	mem_to_reg = 0;
	mem_write = 0;
	alu_src = 0;
	extend = 1;
	is_byte = 0;
	jal = 0;
	is_f = 0;
	w_to_f = 0;
	f_to_w = 0;
	f_reg_write = 0;

	if (inst == 32'h000c) begin
		halted = 1;
	end

	case(opcode)
		FTYPE:
		begin
			is_f = 1;
			f_reg_write = 1;

		end
		ADDI:
		begin
			reg_dst = 0;
			alu_src = 1;
		end
		ADDIU:
		begin
			alu_src = 1;
			extend = 0;
			reg_dst = 0;
		end
		ANDI:
		begin
			reg_dst = 0;
			alu_src = 1;
			extend = 0;
		end
		XORI:
		begin
			reg_dst = 0;
			alu_src = 1;
			extend = 0;
		end
		ORI:
		begin
			reg_dst = 0;
			alu_src = 1;
			extend = 0;
		end
		BEQ:
		begin
			branch = 1;
			reg_write = 0;
		end
		BNE:
		begin
			branch = 1;
			reg_write = 0;
		end
		BLEZ:
		begin
			branch = 1;
			reg_write = 0;
		end
		BGTZ:
		begin
			branch = 1;
			reg_write = 0;
		end
		LW:
		begin
			reg_dst = 0;
			mem_to_reg = 1;
			alu_src = 1;
			mem_read = 1;
		end
		SW:
		begin
			mem_write = 1;
			alu_src = 1;
			reg_write = 0;
		end
		LB:
		begin
			mem_read = 1;
			reg_dst = 0;
			mem_to_reg = 1;
			alu_src = 1;
			is_byte = 1;
		end
		SB:
		begin
			mem_write = 1;
			alu_src = 1;
			reg_write = 0;
			is_byte = 1;
		end
		SLTI:
		begin
			reg_dst = 0;
			alu_src = 1;
		end
		LUI:
		begin
			reg_dst = 0;
			alu_src = 1;
		end
		J:
		begin
			jump = 1;
		end
        JAL:
		begin
			reg_write = 1;
			jal = 1;
			jump = 1;
		end
		default:
		begin
			reg_dst = 1;
			reg_write = 1;
			branch = 0;
			mem_read = 0;
			mem_to_reg = 0;
			mem_write = 0;
			alu_src = 0;
			extend = 1;
			is_byte = 0;
			is_f = 0;
		end
	endcase

	if (inst[31:31 - 6 + 1] == 6'h11 && inst[31 - 6:31 - 6 - 5 + 1] == 4 && inst[10:0] == 0)
	begin
		w_to_f = 1;
		f_reg_write = 1;
	end
	if (inst[31:31 - 6 + 1] == 6'h11 && inst[31 - 6:31 - 6 - 5 + 1] == 0 && inst[10:0] == 0)
	begin
		f_to_w = 1;
		reg_write = 1;
		f_reg_write = 0;
	end

end
endmodule
