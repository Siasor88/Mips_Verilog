module ALU(a, b, alu_control, result, zero, overflow, ishift, shamt);

// ALU_control signals:
// 0: Add
// 1: Subtract
// 2: And
// 3: Or
// 4: Nor
// 5: XOr
// 6: Shift left
// 7: Shift right
// 8: Shift right signed
// 9: Signed comparison (both ALU outputs zero and ALU result: 1 if a<b, 0 otherwise.)
// 10: Mult
// 11: Div
// 12: Forward (outputs a.)
// 13: BLEZ (both ALU outputs zero and result: 1 if a<=0, 0 otherwise.)
// 14: BGTZ (both ALU outputs zero and result: 1 if a>0, 0 otherwise.)
// 15: BGEZ (both ALU outputs zero and result: 1 if a>=0, 0 otherwise.)

input [31:0] a;
input [31:0] b;
input [4:0] alu_control, shamt;
input ishift;
output reg [31:0] result;
output reg zero;
output reg overflow;

//initial $monitor("shamt: %d, ishift: %d, a: %d, b: %d, result: %d, alu_control: %d", shamt, ishift, a, b, result, ALU_control);
/* verilator lint_off LATCH */
always @(a or b or alu_control) begin
	overflow = 0;
	zero = 0;
	case (alu_control)
		5'd0: begin
			result = a + b;
			overflow = ~(a[31] ^ b[31]) & (a[31] ^ result[31]);
		end
		5'd1: begin
			result = a - b;
			overflow = (a[31] ^ b[31]) & (a[31] ^ result[31]);
		end
		5'd2: result = a & b;
		5'd3: result = a | b;
		5'd4: result = ~(a | b);
		5'd5: result = a ^ b;
		5'd6: begin
			result = ishift ? b << shamt :b << a;
		end
		5'd7: result = ishift ? b >> shamt : b >> a;
		5'd8: result = ishift ? $signed(b) >>> shamt : $signed(b) >>> a;
		5'd9: begin
			if ($signed(a) < $signed(b)) begin
				result = 1;
				zero = 1;
			end
			else begin
				result = 0;
				zero = 0;
			end
			end
		5'd10: result = a * b;
		5'd11: result = a / b;
		5'd12: result = a;
		5'd13: begin
			if (a[31] == 1'b1 || a == 0) begin
				result = 1;
				zero = 1;
			end
			else begin
				result = 0;
				zero = 0;
			end
			end
		5'd14: begin
			if (a[31] == 1'b0 || a != 0) begin
				result = 1;
				zero = 1;
			end
			else begin
				result = 0;
				zero = 0;
			end
			end
		5'd15: begin
			if (a[31] == 1'b0 || a == 0) begin
				result = 1;
				zero = 1;
			end
			else begin
				result = 0;
				zero = 0;
			end
			end
		5'd17: begin
			result = {b[15:0], 16'b0};
		end
		5'd18: begin // beq
			if (a == b)
			begin
				zero = 1;
				result = 0;
			end
			else begin
				zero = 0;
				result = 1;
			end
		end
		5'd19: begin // bne
			if (a != b)
			begin
				zero = 1;
				result = 0;
			end
			else begin
				zero = 0;
				result = 1;
			end
		end

	default:  begin
		result = a;
		if (result == 0) zero = 1;
		else zero = 0;
		overflow = 0;
	end
	endcase
end

endmodule

