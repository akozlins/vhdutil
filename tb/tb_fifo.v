`timescale 1ns / 1ps

module tb_fifo();

reg clk, rst_n;
reg re, we;
reg [3:0] wd;

fifo_v1 #(.W(4),.N(2)) i_fifo (
    .re(re),
    .we(we),
    .wd(wd),
    .clk(clk),
    .rst_n(rst_n)
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
    @(posedge rst_n);

    re <= 0; we <= 1; wd <= 'h0;
    @(posedge clk);
    re <= 0; we <= 1; wd <= 'h1;
    @(posedge clk);
    re <= 0; we <= 1; wd <= 'h2;
    @(posedge clk);
    re <= 0; we <= 1; wd <= 'h3;
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
