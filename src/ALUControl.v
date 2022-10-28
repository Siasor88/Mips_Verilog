module ALUControl(alu_op, func, f_format, alu_control, ishift);

// alu_op: instruction[31:26]
// Function: instruction[5:0]
// alu_control: a 5-bit signal that tells ALU what to do.

// alu_control signals:
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
// 13: BLEZ (both ALU outputs zero and ALU result: 1 if a<=0, 0 otherwise.)
// 14: BGTZ (both ALU outputs zero and ALU result: 1 if a>0, 0 otherwise.)
// 15: BGEZ (both ALU outputs zero and ALU result: 1 if a>=0, 0 otherwise.)

input [5:0] alu_op;
input [5:0] func;
input [4:0] f_format;
output reg[4:0] alu_control;
output ishift;
assign ishift = ( !(|func) || (func == 6'b000010) || (func == 6'b000011));
initial $monitor("%d", alu_control);

always @(alu_op or func or f_format) begin
	if (alu_op == 6'b000000) begin // R-format instructions
     		case (func)
        		6'b100110: alu_control = 5'd5; // XOR
        		6'b000000: alu_control = 5'd6; // SLL
        		6'b000100: alu_control = 5'd6; // SLLV
        		6'b000010: alu_control = 5'd7; // SRL
        		6'b100010: alu_control = 5'd1; // SUB
        		6'b000110: alu_control = 5'd7; // SRLV
        		6'b101010: alu_control = 5'd9; // SLT
        		6'b001100: alu_control = 5'd12; // syscall (ALU outputs rs reg.)
        		6'b100011: alu_control = 5'd1; // SUBU
        		6'b100101: alu_control = 5'd3; // OR
        		6'b100111: alu_control = 5'd4; // NOR
        		6'b100001: alu_control = 5'd0; // ADDU
        		6'b011000: alu_control = 5'd10; // MULT
        		6'b011010: alu_control = 5'd11; // DIV
        		6'b100100: alu_control = 5'd2; // AND
        		6'b100000: alu_control = 5'd0; // ADD
        		6'b001000: alu_control = 5'd12; // JR (ALU outputs rs reg.)
        		6'b000011: alu_control = 5'd8; // SRA
        		default: alu_control = 5'd12;
     		endcase
   	end
	else if (alu_op == 6'b010001) begin // F-format instructions
		if (f_format == 5'b10000)
		begin
			case(func)
				6'd0:  alu_control = 5'd16; // ADD.S
				6'd1:  alu_control = 5'd17; // SUB.S
				6'd2:  alu_control = 5'd18; // MUL.S
				6'd3:  alu_control = 5'd19; // DIV.S
				6'd7:  alu_control = 5'd20; // NEG.S
				6'd12: alu_control = 5'd21; // ROUND.W.S
				default: alu_control = 5'd12;
			endcase
		end
		else if (f_format == 5'b10001)
		begin
			case(func)
				6'd0: alu_control = 5'd22; // ADD.D --> Compare equal in slt format
				6'd1: alu_control = 5'd23; // SUB.D --> Compare less than in slt format
				default: alu_control = 5'd12;
			endcase
		end
		else
			alu_control = 5'd12;
   	end
   	else begin
     		case (alu_op)
        		6'b001000: alu_control = 5'd0; // ADDi
        		6'b001001: alu_control = 5'd0; // ADDiU
        		6'b001100: alu_control = 5'd2; // ANDi
        		6'b001110: alu_control = 5'd5; // XORi
        		6'b001101: alu_control = 5'd3; // ORi
        		6'b000100: alu_control = 5'd18; // BEQ (zero in ALU is 1 if a == b.)
       			6'b000101: alu_control = 5'd19; // BNE (zero in ALU is 0 if a != b.)
        		6'b000110: alu_control = 5'd13; // BLEZ
        		6'b000111: alu_control = 5'd14; // BGTZ
        		6'b000001: alu_control = 5'd15; // BGEZ
        		6'b100011: alu_control = 5'd0; // LW
        		6'b101011: alu_control = 5'd0; // SW
        		6'b100000: alu_control = 5'd0; // LB
        		6'b101000: alu_control = 5'd0; // SB
        		6'b001010: alu_control = 5'd9; // SLTi
        		6'b001111: alu_control = 5'd17; // LUi (16 should be entered to ALU as b)
        		6'b000010: alu_control = 5'd12; //
        		6'b000011: alu_control = 5'd12; //
        	default: alu_control = 5'd12;
      		endcase
    	end
end
endmodule
