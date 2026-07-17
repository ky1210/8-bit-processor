module regfile (
    input clk,
    input we,
    input [2:0] ra1,
    input [2:0] ra2,
    input [2:0] wa,
    input [7:0] wd,
    output [7:0] rd1,
    output [7:0] rd2
);

    reg [7:0] regs [0:7];
    integer i;

    initial begin
        for (i = 0; i < 8; i = i + 1)
            regs[i] = 8'h00;
    end

    always @(posedge clk) begin
        if (we)
            regs[wa] <= wd;
    end

    assign rd1 = regs[ra1];
    assign rd2 = regs[ra2];

endmodule