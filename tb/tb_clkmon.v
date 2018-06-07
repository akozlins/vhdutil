`timescale 1ns / 1fs

module tb_clkmon();

reg clk, rst_n, tst_clk;

parameter CLK_MHZ = 50;
parameter TST_MHZ = 125;

clkmon #(.CLK_MHZ(CLK_MHZ), .TST_MHZ(TST_MHZ)) i_clkmon (
    .tst_clk(tst_clk),
    .rst_n(rst_n),
    .clk(clk)
);

initial
begin
    clk <= 1'b1;
    forever #(1000.0/2/CLK_MHZ) clk <= ~clk;
end

initial
begin
    tst_clk <= 1'b1;
    repeat(5*1000*2*TST_MHZ) #(1000.0/2/TST_MHZ) tst_clk <= ~tst_clk;
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

    repeat(10*1000*CLK_MHZ) @(posedge clk);
    $finish;
end

endmodule
