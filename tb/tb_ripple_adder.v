`timescale 1ns / 1ps

module tb_ripple_adder();

reg [3:0] a, b;
wire [3:0] s;
wire c;

ripple_adder #(.W(4)) ripple_adder_i (
    .a(a),
    .b(b),
    .s(s),
    .ci(0),
    .co(c)
);

integer i;

initial
begin
    for (i = 0; i < 256; i = i + 1)
    begin
        a = i % 16;
        b = i / 16;
        #10;
    end

    $finish;
end

endmodule
