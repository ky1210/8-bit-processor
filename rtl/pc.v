module pc (
    input clk,
    input rst,
    input pc_we,
    input [7:0] pc_next,
    output reg [7:0] pc
);

    always @(posedge clk) begin
        if (rst)
            pc <= 8'b00000000;
        else if (pc_we)
            pc <= pc_next;
    end

endmodule