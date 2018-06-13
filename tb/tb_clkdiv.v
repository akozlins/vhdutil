`timescale 1ns / 1ps

module tb_clkdiv();

parameter FREQ = 100; // MHz

reg clk, rst_n;
wire [1:5] clkout;

clkdiv #(.P(1)) i_clkdiv1 (
    .clkout(clkout[1]),
    .rst_n(rst_n), .clk(clk)
);
clkdiv #(.P(2)) i_clkdiv2 (
    .clkout(clkout[2]),
    .rst_n(rst_n), .clk(clk)
);
clkdiv #(.P(3)) i_clkdiv3 (
    .clkout(clkout[3]),
    .rst_n(rst_n), .clk(clk)
);
clkdiv #(.P(4)) i_clkdiv4 (
    .clkout(clkout[4]),
    .rst_n(rst_n), .clk(clk)
);
clkdiv #(.P(5)) i_clkdiv5 (
    .clkout(clkout[5]),
    .rst_n(rst_n), .clk(clk)
);

initial
begin
    clk <= 1'b1;
    forever #(1000.0/2/FREQ) clk <= ~clk;
end

initial
begin
    rst_n <= 1'b0;
    #100;
    @(posedge clk);
    rst_n <= 1'b1;
end

initial
begin
    @(posedge rst_n);

    repeat(100) @(posedge clk);
    $finish;
end

endmodule
