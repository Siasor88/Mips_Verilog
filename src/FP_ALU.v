module FP_ALU(input [31:0] a,
              input [31:0] b,
              input [4:0] alu_control,
              output reg [31:0] result,
              output reg division_by_zero,
              output reg qNaN,
              output reg sNaN,
              output reg inexact,
              output reg underflow,
              output reg zero,
              output reg overflow);


//initial $monitor("shamt: %d, ishift: %d, a: %d, b: %d, result: %d, alu_control: %d", shamt, ishift, a, b, result, ALU_control);
/* verilator lint_off LATCH */

wire [31:0] add_res, sub_res, mult_res, div_res, cvt_res, ceq_res, clt_res;
reg [31:0] neg_b;
F_AddSub f_adder(a, b, add_res);
F_AddSub f_subtractor(a, neg_b, sub_res);
F_Mult f_multiplier(a, b, mult_res);
F_Div f_divider(a, b, div_res);
Cvt cvt(a, cvt_res);
Ceq ceq(a, b, ceq_res);
Clt Clt(a, b, clt_res);

always @(a or b or alu_control) begin
	overflow = 0;
	zero = 0;
	case (alu_control)
		5'd16: begin  // add.s
			result = add_res;
		end
		5'd17: begin // SUB.S
			neg_b = b;
			neg_b[31] = !b[31];
			result = sub_res;
		end
		5'd18: begin // MUL.S
			result = mult_res;
		end
		5'd19: begin // DIV.S
			result = div_res;
		end
		5'd20: begin // NEG.S
			result = a;
			result[31] = !a[31];
		end
		5'd21: begin // ROUND.W.S, fd = round(fs)
			result = cvt_res;
		end
		5'd22: begin // MOVZ.S --> Compare equal in slt format
			result = ceq_res;
		end
		5'd23: begin // MOVN.S --> Compare less than in slt format
			result = clt_res;
		end
	default:  begin
		assign result = a;
		if (result == 0) zero = 1;
		else zero = 0;
		overflow = 0;
    qNaN = 0;
    sNaN = 0;
    inexact = 0;
    underflow = 0;
    zero = 0;
	end
	endcase
end

endmodule
