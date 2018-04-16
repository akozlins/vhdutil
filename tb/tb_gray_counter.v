`timescale 1ns / 1ps

module tb_gray_counter();

reg clk, rst_n, ce;
wire [3:0] cnt;

gray_counter #(.W(4)) i_counter (
    .cnt(cnt),
    .ce(ce), .rst_n(rst_n), .clk(clk)
);

initial
begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial
begin
    ce = 1'b1;
    rst_n = 1'b0;
    #100;
    @(posedge clk);
    rst_n = 1'b1;
end

initial
begin
    @(posedge rst_n);
    repeat(1000) @(posedge clk);
    $finish;
end

initial
begin
    $monitor("%d\t%b", $time, cnt);
end

endmodule
