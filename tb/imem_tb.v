`timescale 1ns/1ps

module imem_tb;

    reg [7:0] addr;
    wire [15:0] instr;

    imem uut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        $dumpfile("imem.vcd");
        $dumpvars(0, imem_tb);

        addr = 8'd0;  #10;
        $display("addr=%0d instr=%h", addr, instr);

        addr = 8'd1;  #10;
        $display("addr=%0d instr=%h", addr, instr);

        addr = 8'd2;  #10;
        $display("addr=%0d instr=%h", addr, instr);

        $finish;
    end

endmodule