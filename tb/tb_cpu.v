`timescale 1ns / 1ps

module tb_cpu();

reg clk, areset;

cpu_v2 cpu_i (
    .clk(clk), .areset(areset)
);

initial
begin
    clk = 1'b1; areset = 1'b1;
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

endmodule
