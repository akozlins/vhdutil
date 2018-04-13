`timescale 1ns / 1ps

module tb_cpu();

reg clk, areset;

cpu_v4 cpu_i (
    .areset(areset),
    .clk(clk)
);

initial
begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial
begin
    areset = 1'b1;
    #105;
    areset = 1'b0;
end

initial
begin
    @(negedge areset);
    repeat(1000*1000) @(posedge clk);
    $finish;
end

endmodule
