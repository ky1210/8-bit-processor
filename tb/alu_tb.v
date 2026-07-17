`timescale 1ns/1ps

module alu_tb;

    reg  [7:0] a;
    reg  [7:0] b;
    reg  [2:0] alu_sel;
    wire [7:0] y;
    wire zero;

    alu uut (
        .a(a),
        .b(b),
        .alu_sel(alu_sel),
        .y(y),
        .zero(zero)
    );

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // ADD
        a = 8'd5;  b = 8'd3;  alu_sel = 3'b000; #10;
        $display("time=%0t a=%0d b=%0d sel=%b y=%0d zero=%b", $time, a, b, alu_sel, y, zero);

        // SUB
        a = 8'd9;  b = 8'd4;  alu_sel = 3'b001; #10;
        $display("time=%0t a=%0d b=%0d sel=%b y=%0d zero=%b", $time, a, b, alu_sel, y, zero);

        // AND
        a = 8'b1100; b = 8'b1010; alu_sel = 3'b010; #10;
        $display("time=%0t a=%0d b=%0d sel=%b y=%0d zero=%b", $time, a, b, alu_sel, y, zero);

        // OR
        a = 8'b1100; b = 8'b1010; alu_sel = 3'b011; #10;
        $display("time=%0t a=%0d b=%0d sel=%b y=%0d zero=%b", $time, a, b, alu_sel, y, zero);

        // XOR
        a = 8'b1100; b = 8'b1010; alu_sel = 3'b100; #10;
        $display("time=%0t a=%0d b=%0d sel=%b y=%0d zero=%b", $time, a, b, alu_sel, y, zero);

        // Zero check
        a = 8'd7; b = 8'd7; alu_sel = 3'b001; #10;
        $display("time=%0t a=%0d b=%0d sel=%b y=%0d zero=%b", $time, a, b, alu_sel, y, zero);

        $finish;
    end

endmodule