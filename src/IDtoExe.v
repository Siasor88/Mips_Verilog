module IDtoExe(
    ready,
    jump_in,
	branch_in,
	mem_read_in,
	mem_to_reg_in,
	mem_write_in,
	alu_src_in,
	reg_write_in,
	alu_op_in,
	extender_in,
	jal_in,
	is_byte_in,
	alu_stall_in,
	halted_in,
	cache_controller_enable_in,
	stall_in,
    jump_out,
	branch_out,
	mem_read_out,
	mem_to_reg_out,
	mem_write_out,
	alu_src_out,
	reg_write_out,
	alu_op_out,
	extender_out,
	jal_out,
	is_byte_out,
	alu_stall_out,
	halted_out,
	cache_controller_enable_out,
	stall_out,
    opcode_in,
	func_in,
	alu_op_in,
    shafal_out_in,
    alu_in_in,
    shamt_in,
    mem_ad_in,
    shefel_out_in,
    opcode_out,
	func_out,
	alu_op_out,
    shafal_out_out,
    alu_in_out,
    shamt_out,
    mem_ad_out,
    shefel_out_out);

input
    ready,
    jump_in,
	branch_in,
	mem_read_in,
	mem_to_reg_in,
	mem_write_in,
	alu_src_in,
	reg_write_in,
	alu_op_in,
	extender_in,
	jal_in,
	is_byte_in,
	alu_stall_in,
	halted_in,
	cache_controller_enable_in,
	stall_in;

input [5:0]
    opcode_in,
	func_in,
	alu_op_in;

input [31:0] shafal_out_in, alu_in_in;

input [4:0] shamt_in;

input [25:0] mem_ad_in;

input [27:0] shefel_out_in;


output reg jump_out,
	branch_out,
	mem_read_out,
	mem_to_reg_out,
	mem_write_out,
	alu_src_out,
	reg_write_out,
	alu_op_out,
	extender_out,
	jal_out,
	is_byte_out,
	alu_stall_out,
	halted_out,
	cache_controller_enable_out,
	stall_out;  

	output reg [5:0] 
	opcode_out,
	func_out,
	alu_op_out;
    
    output reg [31:0] shafal_out_out, alu_in_out;
    output reg [4:0] shamt_out;

    output reg [25:0] mem_ad_out;

    output reg [27:0] shefel_out_out;


    

    always@(posedge ready) begin
    jump_out <= jump_in;
	branch_out <= branch_in;
	mem_read_out <= mem_read_in;
	mem_to_reg_out <= mem_to_reg_in;
	mem_write_out <= mem_write_in;
	alu_src_out <= alu_src_in;
	reg_write_out <= reg_write_in;
	alu_op_out <= alu_op_in;
	extender_out <= extender_in;
	jal_out <= jal_in;
	is_byte_out <= is_byte_in;
	alu_stall_out <= alu_stall_in;
	halted_out <= halted_in;
	cache_controller_enable_out <= cache_controller_enable_in;
	stall_out <= stall_in;   
    opcode_out <= opcode_in;
	func_out <= func_in;
	alu_op_out <= alu_op_in;
    shafal_out_out <= shafal_out_in;
    alu_in_out <= alu_in_in;
    shamt_out <= shamt_in;
    mem_ad_out <= mem_ad_in;
    shefel_out_out <= shefel_out_in;
    end
	
endmodule