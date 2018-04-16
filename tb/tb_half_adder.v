`timescale 1ns / 1ps

module tb_half_adder();

reg a, b;
wire s, c;

half_adder i_adder (
    .a(a),
    .b(b),
    .s(s),
    .c(c)
);

initial
begin
    a = 0;
    b = 0;
    #10;
    a = 1;
    b = 0;
    #10;
    a = 0;
    b = 1;
    #10;
    a = 1;
    b = 1;
    #10;
    $finish;
end

initial begin
    $monitor("%b + %b = (%b)%b", a, b, c, s);
end

endmodule
