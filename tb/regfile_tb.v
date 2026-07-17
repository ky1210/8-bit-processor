`timescale 1ns/1ps

module regfile_tb;

    reg clk;
    reg we;
    reg [2:0] ra1;
    reg [2:0] ra2;
    reg [2:0] wa;
    reg [7:0] wd;
    wire [7:0] rd1;
    wire [7:0] rd2;

    regfile uut (
        .clk(clk),
        .we(we),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, regfile_tb);

        clk = 0;
        we  = 0;
        ra1 = 3'b000;
        ra2 = 3'b000;
        wa  = 3'b000;
        wd  = 8'b00000000;

        // Write 42 into R3
        #10;
        we = 1;
        wa = 3'b011;
        wd = 8'd42;

        #10;
        we = 0;

        // Read R3
        ra1 = 3'b011;

        #10;
        $display("Read rd1 = %d (expected 42)", rd1);

        // Write 15 into R5
        we = 1;
        wa = 3'b101;
        wd = 8'd15;

        #10;
        we = 0;

        // Read R3 and R5 together
        ra1 = 3'b011;
        ra2 = 3'b101;

        #10;
        $display("Read rd1 = %d (expected 42), rd2 = %d (expected 15)", rd1, rd2);

        $finish;
    end

endmodule