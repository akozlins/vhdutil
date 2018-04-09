`timescale 1ns / 1ps

module tb_alu();

reg [2:0] op;
reg [3:0] a, b;

alu_v2 #(.W(4)) alu_i (
    .op(op),
    .a(a),
    .b(b),
    .ci(1'b0)
);

integer i;

initial
begin
    // add
    op = 3'b001;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // sub
    op = 3'b010;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // and
    op = 3'b100;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // or
    op = 3'b101;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // xor
    op = 3'b110;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    $finish;
end

endmodule
