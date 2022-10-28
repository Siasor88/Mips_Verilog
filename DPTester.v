module SHIFT_TESTER(); 

wire[5:0] shifter_out1; 
reg [3:0] shifter_in1;

wire[5:0] shifter_out2;  
reg [5:0] shifter_in2;

Shifter #(.INPUT_LEN(4), .OUTPUT_LEN(6))
shifter1( .in(shifter_in1), .out(shifter_out1) );

Shifter #(.INPUT_LEN(6), .OUTPUT_LEN(6))
shifter2(.in(shifter_in2), .out(shifter_out2) );

initial 
	begin
	shifter_in1 = 'b0011; 
	#10
	$display("%d || %d", shifter_out1, shifter_in1 << 2);
	shifter_in1 = 'b1010; 
	#10
	$display("%d || %d", shifter_out1, shifter_in1 << 2);
	shifter_in2 = 'b101100; 
	#10
	$display("%d || %d", shifter_out2, shifter_in2 << 2);
	shifter_in2 = 'b111100; 
	#10
	$display("%d || %d", shifter_out2, shifter_in2 << 2);
	end
endmodule


module ADDER_TESTER();

reg  [3 : 0] r1, r2;
reg cin; 
wire cout; 
wire [3:0] out_adder; 

Adder #(.DATA_LEN(4)) addr( .in1(r1), .in2(r2), .c_in(cin), .c_out(cout), .sum(out_adder)); 


initial
	begin
	r1 = 0; 
	r2 = 0; 
	cin = 0; 
	$monitor("in1 : %d , in2: %d , cin: %d , cout: %d, sum: %d ", r1, r2, cin, cout, out_adder);
	r1 = 3; 
	#1
	r2 = 12; 
	#1
	cin = 1;
	#1
	r1 = 12; 
	#1
	cin = 0;

	end



endmodule


module INSTDECODER_TEST(); 


reg enable;
reg [1:0] typeee; 

reg [0 : 32 - 1] instruction;


wire  [5 - 1 : 0] rd, rs, rt; 
wire  [16 - 1 : 0] im;
wire  [5 - 1 : 0] shamt;
wire  [26 - 1 : 0] mem_addr;
wire  [6 - 1 : 0] opcode;
wire  [6 - 1 : 0] func;

InstructionDecoder ID (
	.instruction(instruction),
	.rs(rs),
	.rd(rd),
	.rt(rt),
	.func(func),
	.opcode(opcode),
	.mem_addr(mem_addr),
	.im(im),
	.shamt(shamt),
	.enable(enable),
	.typeee(typeee)
);




initial 
	begin
	$monitor("instruction : %b , %b | %b | %b | %b | %b | %b | %b | %b ", instruction, opcode, rs, rt, rd, shamt, func, im, mem_addr );

	instruction = 'b000000_11111_10101_00001_10000_011011;
	typeee = 0;
	enable = 0;
	#10
	enable = 1;
	#10
	enable = 0;
	
	#10
	instruction = 'b001100_11001_11001_00001_10110011011;
	typeee = 1;
	enable = 1;

	#10
	enable = 0;
	
	#10
	instruction = 'b111000_11111111111110000000000000;
	typeee = 2;
	enable = 1;
	#10

	enable = 0;
	
	#10
	instruction = 'b111000_11111111111110000000000000;
	typeee = 2;
	enable = 1;
	end

endmodule 



module SGNEXT_TESTER();


reg [3 : 0]in; 
wire[ 7:0] out;


SignExtender #(.IN_LEN(4), .OUT_LEN(8)) sg(.in(in), .out(out));


initial 
	begin
	in = 0; 
	$monitor("in : %b, out : %b", in, out);
	in = 4'b0011;
	#1
	in = 4'b1011;

	end




endmodule



module MUX_TESTER(); 

reg[3:0] in0, in1;
reg select; 

wire[3:0] out;

MUX2_1 #(.INPUT_LEN(4)) mux(.in0(in0), .in1(in1), .out(out), .select(select) );


initial 
	begin 
	in0 = 0;
	in1 = 12; 
	select = 0;
	$monitor("selected line : %d, in0: %d, in1: %d, out: %d", select, in0, in1, out );

	select = 1; 
	#1
	select = 0;
	#1
	in1 = 2;
	#1 
	in0 = 4;
	#1
	select = 1;
	end

endmodule