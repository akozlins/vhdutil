`timescale 1ns / 1ps

module tb_gray_counter();

wire [3:0] cnt;
reg clk, ce, areset;

gray_counter #(.W(4)) gray_counter_i (
    .cnt(cnt),
    .ce(ce), .areset(areset), .clk(clk)
);

initial
begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial
begin
    ce = 1'b1;
    areset = 1'b1;
    #100;
    areset = 1'b0;
end

initial
begin
    @(negedge areset);
    repeat(1000) @(posedge clk);
    $finish;
end

initial
begin
    $monitor("%d\t%b", $time, cnt);
end

endmodule
