`timescale 1ns/1ps

module control_unit_tb;

    reg [3:0] opcode;
    wire reg_write, mem_write, mem_to_reg, alu_src, branch, jump;
    wire [2:0] alu_op;

    control_unit uut (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    initial begin
        $dumpfile("control_unit.vcd");
        $dumpvars(0, control_unit_tb);

        opcode = 4'b0000; #10;
        opcode = 4'b0101; #10;
        opcode = 4'b0110; #10;
        opcode = 4'b0111; #10;
        opcode = 4'b1000; #10;
        opcode = 4'b1001; #10;
        opcode = 4'b1010; #10;
        opcode = 4'b1111; #10;

        $finish;
    end

endmodule