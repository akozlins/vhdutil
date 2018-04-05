`timescale 1ns / 1ps

module tb_alu();

reg [2:0] mux;
reg [3:0] a, b;
reg ci;

alu #(.W(4)) alu_i (
    .mux(mux),
    .a(a),
    .b(b),
    .ci(ci)
);

integer i;

initial
begin
    // add
    mux = 3'b000; ci = 0;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // sub
    mux = 3'b100; ci = 1;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // and
    mux = 3'b001; ci = 0;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // or
    mux = 3'b010; ci = 0;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    // xor
    mux = 3'b011; ci = 0;
    for (i = 0; i < 16; i = i + 1) begin
        a = i % 4; b = i / 4;
        #10;
    end

    $finish;
end

endmodule
