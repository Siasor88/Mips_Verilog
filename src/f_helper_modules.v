
module Ceq (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

always @(a or b) begin
    if (a == b) result = 1;
    else result = 0;
end

endmodule

module Clt (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

always @(a or b) begin
    result = 0;
    if (a[31] > b[31])        // a < 0 and b > 0
        result = 1;         
    else if (a[31] < b[31])       // a > 0 and b < 0 
        result = 0;      
    else if (a[31] == 0) begin              // a > 0 and b > 0
        if (a[30:23] < b[30:23]) result = 1;
        else if (a[30:23] > b[30:23]) result = 0;
        else begin
            if (a[22:0] < b[22:0]) result = 1;
            else result = 0;
        end
    end else begin                          // a < 0 and b <0
        if (a[30:23] > b[30:23]) result = 1;
        else if (a[30:23] < b[30:23]) result = 0;
        else begin
            if (a[22:0] > b[22:0]) result = 1;
            else result = 0;
        end
    end                       
end

endmodule

module Cvt (
    input [31:0] a,
    output reg [31:0] result
);

reg [7:0] exp;

reg [24:0] num;
reg [31:0] carry;

/* verilator lint_off WIDTH */

always @(a) begin
    exp = a[30:23] - 127;
    num = {2'b01, a[22:0]};
    carry[0] = num[22 - exp];
    result = num >> (23 - exp);
    result = result + carry;
    if (a[31]) result = -result;
end

endmodule

module F_AddSub (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

/* verilator lint_off LATCH */
/* verilator lint_off SELRANGE */

reg sign_a, sign_b;
reg [7:0] exp_a, exp_b;

reg [24:0] num_a, num_b, num_c, carry;

reg [31:0] carry_prime;
integer i;

always @(a or b) begin
    if (a[30:23] > b[30:23]) begin
        sign_a = a[31];
        sign_b = b[31];
        exp_a = a[30:23];
        exp_b = b[30:23];
        num_a = {2'b01, a[22:0]};
        num_b = {2'b01, b[22:0]};
    end else if (a[30:23] < b[30:23]) begin
        sign_a = b[31];
        sign_b = a[31];
        exp_a = b[30:23];
        exp_b = a[30:23];
        num_a = {2'b01, b[22:0]};
        num_b = {2'b01, a[22:0]};
    end else if (a[22:0] > b[22:0]) begin
        sign_a = a[31];
        sign_b = b[31];
        exp_a = a[30:23];
        exp_b = b[30:23];
        num_a = {2'b01, a[22:0]};
        num_b = {2'b01, b[22:0]};
    end else begin
        sign_a = b[31];
        sign_b = a[31];
        exp_a = b[30:23];
        exp_b = a[30:23];
        num_a = {2'b01, b[22:0]};
        num_b = {2'b01, a[22:0]};
    end

    if (sign_a ^ sign_b == 0) begin // same sign
        carry[0] = num_b[exp_a - exp_b - 1];
        num_b = num_b >> exp_a - exp_b;
        num_c = num_a + num_b + carry;
        result[31] = sign_a;
        if (num_c[24] == 0) begin
            result[30:23] = exp_a;
            result[22:0] = num_c[22:0]; 
        end
        else begin
            result[30:23] = exp_a + 1;
            result[22:0] = num_c[23:1];
            carry_prime[0] = num_c[0]; 
            result = result + carry_prime;
        end
    end else begin // opposite sign
        carry[0] = num_b[exp_a - exp_b - 1];
        num_b = num_b >> exp_a - exp_b;
        num_c = num_a - num_b - carry;
        result[31] = sign_a;
        i = 23;
        while(i >= 0 && num_c[23] == 0) begin
            num_c = num_c << 1;
            exp_a = exp_a - 1;
            i = i - 1;
        end
        result[30:23] = exp_a;
        result[22:0] = num_c[22:0];     
    end
end

endmodule

module F_Div (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

/* verilator lint_off LATCH */
/* verilator lint_off SELRANGE */
/* verilator lint_off WIDTH */

reg sign_a, sign_b;
reg [7:0] exp_a, exp_b;

reg [23:0] num_b, num_c;
reg [46:0] num_a;

always @(a or b) begin
    sign_a = a[31];
    sign_b = b[31];
    exp_a = a[30:23];
    exp_b = b[30:23];
    num_a = {1'b1, a[22:0], 23'd0};
    num_b = {1'b1, b[22:0]};
    num_c = num_a / num_b;
    result[31] = a[31] ^ b[31];
    if (num_c[23] == 1) begin
        result[22:0] = num_c[22:0];
        result[30:23] = exp_a - exp_b + 127;
    end else begin
        num_c = num_c << 1;
        result[22:0] = num_c[22:0];
        result[30:23] = exp_a - exp_b + 127 - 1;

    end

end

endmodule

module F_Mult (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

/* verilator lint_off LATCH */
/* verilator lint_off SELRANGE */

reg sign_a, sign_b;
reg [7:0] exp_a, exp_b;

reg [23:0] num_a, num_b, carry;
reg [47:0] num_c;

reg [31:0] carry_prime;
integer i;

always @(a or b) begin
    sign_a = a[31];
    sign_b = b[31];
    exp_a = a[30:23];
    exp_b = b[30:23];
    num_a = {1'b1, a[22:0]};
    num_b = {1'b1, b[22:0]};
    num_c = num_a * num_b;
    result[31] = a[31] ^ b[31];
    if (num_c[47] == 0) begin
        result[22:0] = num_c[45:23];
        result[30:23] = exp_a + exp_b - 127;
    end else begin
        result[22:0] = num_c[46:24];
        result[30:23] = exp_a + exp_b + 1 - 127;
    end
end

endmodule
