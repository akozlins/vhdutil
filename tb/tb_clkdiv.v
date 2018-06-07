`timescale 1ns / 1ps

module tb_clkdiv();

parameter FREQ = 100; // MHz

reg clk, rst_n;

clkdiv #(.P(5)) i_clkdiv (
    .rst_n(rst_n),
    .clk(clk)
);

initial
begin
    clk <= 1'b1;
    forever #(1000.0/2/FREQ) clk <= ~clk;
end

initial
begin
    rst_n <= 1'b0;
    #100
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
