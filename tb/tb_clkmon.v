`timescale 1ns / 1ps

module tb_clkmon();

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

parameter TST_MHZ = 30;
reg tst_clk;

initial
begin
    tst_clk <= 0;
    repeat(TST_MHZ*1000) #(500.0/TST_MHZ) tst_clk <= ~tst_clk;
end

wire tst_ok;

clkmon #(.CLK_MHZ(CLK_MHZ), .TST_MHZ(TST_MHZ)) i_clkmon (
    .tst_clk(tst_clk),
    .tst_ok(tst_ok),
    .rst_n(rst_n),
    .clk(clk)
);

initial
begin
    @(posedge rst_n);
    @(tst_ok == 1);
    @(tst_ok == 0);
    repeat(1000) @(posedge clk);
    $finish;
end

endmodule
