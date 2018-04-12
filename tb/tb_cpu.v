`timescale 1ns / 1ps

module tb_cpu();

reg clk, areset;

cpu_v3 cpu_i (
    .clk(clk), .areset(areset)
);

initial
begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial
begin
    areset = 1'b1;
    #100
    areset = 1'b0;
end

initial
begin
    @(negedge areset);
    repeat(1000*1000) @(posedge clk);
    $finish;
end

endmodule
