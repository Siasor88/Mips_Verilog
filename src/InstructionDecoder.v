`define OPCODE_BEGIN (IR_LEN - 1)
`define ADDR_BEGIN (`OPCODE_BEGIN - OPC_LEN)
`define RS_BEGIN (`OPCODE_BEGIN - OPC_LEN)
`define RT_BEGIN (`RS_BEGIN - REG_LEN)
`define IM_BEGIN (`RT_BEGIN - REG_LEN)
`define RD_BEGIN (`RT_BEGIN - REG_LEN)
`define SH_BEGIN (`RD_BEGIN - REG_LEN)
`define FUNC_BEGIN (`SH_BEGIN - SHIFT_LEN)


module InstructionDecoder(instruction, opcode, rd, rs, rt, fs, ft, fd, f_format, im, shamt, mem_addr, func);

parameter IR_LEN = 32;
parameter REG_LEN = 5;
parameter SHIFT_LEN = 5;
parameter FUNC_LEN = 6;
parameter IM_LEN = 16;
parameter MEM_LEN = 26;
parameter OPC_LEN = 6;


input [IR_LEN-1 : 0] instruction;


output  [REG_LEN - 1 : 0] rd, rs, rt = 0;
output  [REG_LEN - 1 : 0] fd, fs, ft = 0;
output  [REG_LEN - 1 : 0] f_format = 0;
output  [IM_LEN - 1 : 0] im = 0;
output  [SHIFT_LEN - 1 : 0] shamt = 0;
output  [MEM_LEN - 1 : 0] mem_addr = 0;
output  [OPC_LEN - 1 : 0] opcode = 0;
output  [FUNC_LEN - 1 : 0] func = 0;


localparam R = 2'b00;
localparam I = 2'b01;
localparam J = 2'b10;


assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign rd = instruction[15:11];
assign ft = instruction[20:16];
assign fs = instruction[15:11];
assign fd = instruction[10:6];
assign im = instruction[15:0];
assign mem_addr = instruction[25:0];
assign opcode = instruction[31:26];
assign shamt = instruction[10:6];
assign func = instruction[5:0];
assign f_format = instruction[31 - 6: 31 - 6 - 5 + 1];

endmodule
