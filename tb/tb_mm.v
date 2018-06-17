`timescale 1ns / 1fs

module tb_mm();

reg clk, rst_n, read, write;
reg [7:0] address;
wire [15:0] readdata;
reg [15:0] writedata;
wire waitrequest;

parameter CLK_MHZ = 80;

mm i_mm (
    .address(address),
    .read(read),
    .readdata(readdata),
    .write(write),
    .writedata(writedata),
    .waitrequest(waitrequest),
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
    rst_n <= 1'b0;
    #100;
    @(posedge clk);
    rst_n <= 1'b1;
end

initial
begin
    address <= 0;
    read <= 0;
    write <= 0;
    writedata <= 0;
    @(posedge rst_n);

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
