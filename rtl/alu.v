module alu (
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] alu_sel,
    output reg [7:0] y,
    output zero
);

    always @(*) begin
        case (alu_sel)
            3'b000: y = a + b;   // ADD
            3'b001: y = a - b;   // SUB
            3'b010: y = a & b;   // AND
            3'b011: y = a | b;   // OR
            3'b100: y = a ^ b;   // XOR
            default: y = 8'b00000000;
        endcase
    end

    assign zero = (y == 8'b00000000);

endmodule