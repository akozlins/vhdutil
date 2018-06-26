`timescale 1ns / 1ps

module tb_fifo();

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

reg re, we;
reg [3:0] wd;

fifo_dc #(.W(4),.N(2)) i_fifo (
    .we(we),
    .wd(wd),
    .wrst_n(rst_n),
    .wclk(clk),
    .re(re),
    .rrst_n(rst_n),
    .rclk(clk)
);

initial
begin
    re <= 0; we <= 0;
    @(posedge rst_n);

    @(posedge clk);
    re <= 0; we <= 1; wd <= 4'b0001;

    @(posedge clk);
    re <= 0; we <= 1; wd <= 4'b0010;

    @(posedge clk);
    re <= 0; we <= 1; wd <= 4'b0100;

    @(posedge clk);
    re <= 0; we <= 1; wd <= 4'b1000;

    @(posedge clk);
    re <= 1; we <= 0;

    @(posedge clk);
    re <= 1; we <= 0;

    @(posedge clk);
    re <= 1; we <= 0;

    @(posedge clk);
    re <= 1; we <= 0;

    @(posedge clk);
    re <= 0; we <= 0;

    repeat(10) @(posedge clk);
    $finish;
end

endmodule
