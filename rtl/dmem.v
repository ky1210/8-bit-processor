module dmem (
    input clk,
    input we,
    input [7:0] addr,
    input [7:0] wd,
    output [7:0] rd
);

    reg [7:0] mem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 8'h00;
    end

    assign rd = mem[addr];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= wd;
    end

endmodule