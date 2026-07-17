`timescale 1ns/1ps

module pc_tb;

    reg clk;
    reg rst;
    reg pc_we;
    reg [7:0] pc_next;
    wire [7:0] pc;

    pc uut (
        .clk(clk),
        .rst(rst),
        .pc_we(pc_we),
        .pc_next(pc_next),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("pc.vcd");
        $dumpvars(0, pc_tb);

        clk = 0;
        rst = 1;
        pc_we = 0;
        pc_next = 8'd0;

        // Reset PC to 0
        #10;
        rst = 0;

        // Load PC = 1
        pc_we = 1;
        pc_next = 8'd1;
        #10;
        $display("PC = %d (expected 1)", pc);

        // Load PC = 2
        pc_next = 8'd2;
        #10;
        $display("PC = %d (expected 2)", pc);

        // Hold PC, no write
        pc_we = 0;
        pc_next = 8'd9;
        #10;
        $display("PC = %d (expected 2)", pc);

        // Load PC = 20
        pc_we = 1;
        pc_next = 8'd20;
        #10;
        $display("PC = %d (expected 20)", pc);

        // Reset again
        rst = 1;
        #10;
        $display("PC = %d (expected 0)", pc);

        $finish;
    end

endmodule