`timescale 1ns / 1ps

module tb_cpu();

reg clk, rst_n;

cpu_v4 i_cpu (
    .rst_n(rst_n),
    .clk(clk)
);

initial
begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial
begin
    rst_n = 1'b0;
    #100
    @(posedge clk);
    rst_n = 1'b1;
end

initial
begin
    @(posedge rst_n);
    repeat(1000*1000) @(posedge clk);
    $finish;
end

endmodule
