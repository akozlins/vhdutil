`timescale 1ns / 1ps

module tb_clkdiv();

parameter CLK_MHZ = 100;
reg clk, rst_n;

initial
begin
    clk <= 0;
    repeat(CLK_MHZ*2000) #(500.0/CLK_MHZ) clk <= ~clk;
    $finish;
end

initial
begin
    rst_n <= 0;
    repeat(10) @(posedge clk);
    rst_n <= 1;
end

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
    @(posedge rst_n);
end

endmodule
