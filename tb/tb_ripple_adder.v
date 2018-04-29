`timescale 1ns / 1ps

module tb_ripple_adder();

reg [3:0] a, b;
wire [3:0] s;
wire co;

ripple_adder #(.W(4)) i_adder (
    .a(a),
    .b(b),
    .ci(1'b0),
    .s(s),
    .co(co)
);

integer i;

initial
begin
    for (i = 0; i < 256; i = i + 1)
    begin
        a <= i % 16;
        b <= i / 16;
        #10;
    end

    $finish;
end

initial begin
    $monitor("%b + %b = (%b)%b", a, b, co, s);
end

endmodule
