`timescale 1ns / 1ps

module tb_fifo();

reg clk, rst_n;
reg re, we;
reg [3:0] wd;

fifo_dc #(.W(4),.N(2)) i_fifo (
    .re(re),
    .rclk(clk),
    .rrst_n(rst_n),
    .we(we),
    .wd(wd),
    .wclk(clk),
    .wrst_n(rst_n)
);

initial
begin
    clk <= 1'b1;
    forever #5 clk <= ~clk;
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
    re <= 0; we <= 0;
    @(posedge rst_n);

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

    repeat(4) @(posedge clk);
    $finish;
end

endmodule
