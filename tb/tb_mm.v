`timescale 1ns / 1ps

module tb_mm();

parameter CLK_MHZ = 100;
reg clk, reset_n;

initial
begin
    clk <= 0;
    repeat(CLK_MHZ*2000) #(500.0/CLK_MHZ) clk <= ~clk;
    $finish;
end

initial
begin
    reset_n <= 0;
    repeat(10) @(posedge clk);
    reset_n <= 1;
end

reg read, write;
reg [7:0] address;
wire [15:0] readdata;
reg [15:0] writedata;
wire waitrequest;

mm i_mm (
    .address(address),
    .read(read),
    .readdata(readdata),
    .write(write),
    .writedata(writedata),
    .waitrequest(waitrequest),
    .reset_n(reset_n),
    .clk(clk)
);

initial
begin
    address <= 0;
    read <= 0;
    write <= 0;
    writedata <= 0;
    @(posedge reset_n);

    while(waitrequest) @(posedge clk);
    address <= 1;
    read <= 1;
    write <= 0;
    @(posedge clk);
    while(waitrequest) @(posedge clk);
    if(address != readdata) $finish;
    address <= 1;
    read <= 0;
    write <= 1;
    @(posedge clk);
    while(waitrequest) @(posedge clk);
    read <= 0;
    write <= 0;

    repeat(4) @(posedge clk);

    while(waitrequest) @(posedge clk);
    address <= 2;
    read <= 1;
    write <= 0;
    @(posedge clk);
    while(waitrequest) @(posedge clk);
    if(address != readdata) $finish;
    address <= 3;
    read <= 1;
    write <= 0;
    @(posedge clk);
    while(waitrequest) @(posedge clk);
    if(address != readdata) $finish;
    address <= 3;
    read <= 1;
    write <= 0;
    @(posedge clk);
    while(waitrequest) @(posedge clk);
    if(address != readdata) $finish;
    read <= 0;
    write <= 0;

    repeat(4) @(posedge clk);

    $finish;
end

endmodule
