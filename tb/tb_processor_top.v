`timescale 1ns/1ps

module tb_processor_top;

    reg clk;
    reg rst;

    // Instantiate DUT
    processor_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Waveform dump
        $dumpfile("processor_top.vcd");
        $dumpvars(0, tb_processor_top);

        // Initialize inputs
        clk = 0;
        rst = 1;

        // Hold reset for a few cycles
        #12;
        rst = 0;

        // Let CPU run
        #200;

        $finish;
    end

    // Optional monitor
    initial begin
        $monitor("time=%0t rst=%b pc=%h instr=%h alu_result=%h",
                 $time, rst,
                 dut.pc_current,
                 dut.instr,
                 dut.alu_result);
    end

endmodule
