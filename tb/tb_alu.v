`timescale 1ns / 1ps

module tb_alu();

reg s0, s1, s2, ci;
reg [3:0] a, b;
wire [3:0] z;
wire co;

alu #(.W(4)) adder_i (
    .s0(s0), .s1(s1), .s2(s2),
    .a(a),
    .b(b),
    .z(z),
    .ci(ci),
    .co(co)
);

integer i;

initial
begin
    s0 = 1; s1 = 1; s2 = 0;
    ci = 0;
    for (i = 0; i < 16; i = i + 1)
    begin
        a = i % 4;
        b = i / 4;
        #10;
    end

    $finish;
end

endmodule
