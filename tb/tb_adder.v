`timescale 1ns / 1ps

module tb_adder();

reg [4:0] a, b;
wire [4:0] s;
wire co;

adder #(.W(5)) i_adder (
    .a(a),
    .b(b),
    .ci(1'b0),
    .s(s),
    .co(co)
);

integer i;

initial
begin
    for (i = 0; i < 1024; i = i + 1)
    begin
        a <= i % 32;
        b <= i / 32;
        #10;
    end

    $finish;
end

initial begin
    $monitor("%b + %b = (%b)%b", a, b, co, s);
end

endmodule
