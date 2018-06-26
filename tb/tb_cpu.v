`timescale 1ns / 1ps

module tb_cpu();

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

wire [15:0] dbg_out;

cpu16_v4 i_cpu (
    .dbg_out(dbg_out),
    .rst_n(rst_n),
    .clk(clk)
);

initial
begin
    @(posedge rst_n);
end

endmodule
