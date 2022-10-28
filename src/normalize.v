module normalize (
    input [23:0] mantissa,
    input carry,
    input operand,
    output reg [22:0] mantissa_normalized,
    output reg [4:0] shift
);

reg [23:0] temp;
always @(*)
begin
    if(!operand & carry)
    begin
        mantissa_normalized = mantissa[23:1] + {22'b0, mantissa[0]};
        shift = 0;
    end
    else
    begin
        casex(mantissa)
			24'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				mantissa_normalized = mantissa[22:0];
				shift = 5'd0;
			end
			24'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 1;
				mantissa_normalized = temp[22:0];
				shift = 5'd1;
			end
			24'b001x_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 2;
				mantissa_normalized = temp[22:0];
				shift = 5'd2;
			end			
			24'b0001_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 3;
				mantissa_normalized = temp[22:0];
				shift = 5'd3;
			end			
			24'b0000_1xxx_xxxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 4;
				mantissa_normalized = temp[22:0];
				shift = 5'd4;
			end			
			24'b0000_01xx_xxxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 5;
				mantissa_normalized = temp[22:0];
				shift = 5'd5;
			end			
			24'b0000_001x_xxxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 6;
				mantissa_normalized = temp[22:0];
				shift = 5'd6;
			end			
			24'b0000_0001_xxxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 7;
				mantissa_normalized = temp[22:0];
				shift = 5'd7;
			end			
			24'b0000_0000_1xxx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 8;
				mantissa_normalized = temp[22:0];
				shift = 5'd8;
			end			
			24'b0000_0000_01xx_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 9;
				mantissa_normalized = temp[22:0];
				shift = 5'd9;
			end			
			24'b0000_0000_001x_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 10;
				mantissa_normalized = temp[22:0];
				shift = 5'd10;
			end			
			24'b0000_0000_0001_xxxx_xxxx_xxxx:
			begin
				temp = mantissa << 11;
				mantissa_normalized = temp[22:0];
				shift = 5'd11;
			end			
			24'b0000_0000_0000_1xxx_xxxx_xxxx:
			begin
				temp = mantissa << 12;
				mantissa_normalized = temp[22:0];
				shift = 5'd12;
			end			
			24'b0000_0000_0000_01xx_xxxx_xxxx:
			begin
				temp = mantissa << 13;
				mantissa_normalized = temp[22:0];
				shift = 5'd13;
			end			
			24'b0000_0000_0000_001x_xxxx_xxxx:
			begin
				temp = mantissa << 14;
				mantissa_normalized = temp[22:0];
				shift = 5'd14;
			end			
			24'b0000_0000_0000_0001_xxxx_xxxx:
			begin
				temp = mantissa << 15;
				mantissa_normalized = temp[22:0];
				shift = 5'd15;
			end			
			24'b0000_0000_0000_0000_1xxx_xxxx:
			begin
				temp = mantissa << 16;
				mantissa_normalized = temp[22:0];
				shift = 5'd16;
			end			
			24'b0000_0000_0000_0000_01xx_xxxx:
			begin
				temp = mantissa << 17;
				mantissa_normalized = temp[22:0];
				shift = 5'd17;
			end			
			24'b0000_0000_0000_0000_001x_xxxx:
			begin
				temp = mantissa << 18;
				mantissa_normalized = temp[22:0];
				shift = 5'd18;
			end			
			24'b0000_0000_0000_0001_0001_xxxx:
			begin
				temp = mantissa << 19;
				mantissa_normalized = temp[22:0];
				shift = 5'd19;
			end			
			24'b0000_0000_0000_0000_0000_1xxx:
			begin
				temp = mantissa << 20;
				mantissa_normalized = temp[22:0];
				shift = 5'd20;
			end			
			24'b0000_0000_0000_0000_0000_01xx:
			begin
				temp = mantissa << 21;
				mantissa_normalized = temp[22:0];
				shift = 5'd21;
			end			
			24'b0000_0000_0000_0000_0000_001x:
			begin
				temp = mantissa << 22;
				mantissa_normalized = temp[22:0];
				shift = 5'd22;
			end			
			24'b0000_0000_0000_0000_0000_0001:
			begin
				temp = mantissa << 23;
				mantissa_normalized = temp[22:0];
				shift = 5'd23;
			end			
			default:
			begin
				mantissa_normalized = 23'b0;
				shift = 5'd0;
			end			
		endcase	
    end    
end
    
endmodule