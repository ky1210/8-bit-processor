`timescale 1ns/1ps

module dmem_tb;

    reg clk;
    reg we;
    reg [7:0] addr;
    reg [7:0] wd;
    wire [7:0] rd;

    dmem uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .wd(wd),
        .rd(rd)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dmem.vcd");
        $dumpvars(0, dmem_tb);

        clk = 0;
        we = 0;
        addr = 8'd0;
        wd = 8'd0;

        // Write 55 to address 10
        #10;
        addr = 8'd10;
        wd = 8'd55;
        we = 1;

        #10;
        we = 0;
        $display("Read at addr 10 = %d (expected 55)", rd);

        // Write 99 to address 20
        #10;
        addr = 8'd20;
        wd = 8'd99;
        we = 1;

        #10;
        we = 0;
        $display("Read at addr 20 = %d (expected 99)", rd);

        // Read back address 10
        addr = 8'd10;
        #10;
        $display("Read at addr 10 = %d (expected 55)", rd);

        $finish;
    end

endmodule