`timescale 1ns / 1ps

module tb_gray_counter();

wire [3:0] cnt;
reg clk, ena, areset;

gray_counter #(.W(4)) gray_counter_i (
    .cnt(cnt),
    .clk(clk), .ena(ena), .areset(areset)
);

initial
begin
    clk = 1'b1; ena = 1'b1; areset = 1'b1;
    repeat(4) #5 clk = ~clk;
    areset = 1'b0;
    forever #5 clk = ~clk;
end

initial
begin
    @(negedge areset);
    repeat(256) @(posedge clk);
    $finish;
end

initial begin
    $monitor("%d\t%b", $time, cnt);
end

endmodule
