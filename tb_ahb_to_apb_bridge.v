`timescale 1ns / 1ps

module tb_ahb_to_apb_bridge;

    reg HCLK;
    reg HRESETn;

    reg [31:0] HADDR;
    reg [31:0] HWDATA;
    reg HWRITE;
    reg HSEL;
    reg HREADY;

    wire [31:0] PADDR;
    wire [31:0] PWDATA;
    wire PWRITE;
    wire PENABLE;
    wire PSEL;

    // DUT Instantiation
    ahb_to_apb_bridge dut (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HSEL(HSEL),
        .HREADY(HREADY),

        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .PENABLE(PENABLE),
        .PSEL(PSEL)

    );

    // Clock Generation
    always #5 HCLK = ~HCLK;

    initial begin

        HCLK    = 0;
        HRESETn = 0;

        HADDR   = 32'd0;
        HWDATA  = 32'd0;

        HWRITE  = 0;
        HSEL    = 0;
        HREADY  = 0;

        // Reset
        #20;
        HRESETn = 1;

        // AHB Write Transaction
        #10;

        HADDR   = 32'h00001000;
        HWDATA  = 32'hA5A5F0F0;

        HWRITE  = 1'b1;
        HSEL    = 1'b1;
        HREADY  = 1'b1;

        #50;

        $finish;

    end

endmodule