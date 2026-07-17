module control_unit (
    input  [3:0] opcode,
    output reg       reg_write,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       alu_src,
    output reg       branch,
    output reg       jump,
    output reg       pc_we,
    output reg [2:0] alu_op
);

    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR  = 3'b011;
    localparam ALU_XOR = 3'b100;

    always @(*) begin
        reg_write  = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 1'b0;
        alu_src    = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        pc_we      = 1'b1;
        alu_op     = ALU_ADD;

        case (opcode)
            4'h0: begin reg_write = 1'b1; alu_src = 1'b0; alu_op = ALU_ADD; end
            4'h1: begin reg_write = 1'b1; alu_src = 1'b0; alu_op = ALU_SUB; end
            4'h2: begin reg_write = 1'b1; alu_src = 1'b0; alu_op = ALU_AND; end
            4'h3: begin reg_write = 1'b1; alu_src = 1'b0; alu_op = ALU_OR;  end
            4'h4: begin reg_write = 1'b1; alu_src = 1'b0; alu_op = ALU_XOR; end
            4'h5: begin reg_write = 1'b1; alu_src = 1'b1; alu_op = ALU_ADD; end
            4'h6: begin reg_write = 1'b1; mem_to_reg = 1'b1; alu_src = 1'b1; alu_op = ALU_ADD; end
            4'h7: begin mem_write = 1'b1; alu_src = 1'b1; alu_op = ALU_ADD; end
            4'h8: begin branch = 1'b1; alu_src = 1'b0; alu_op = ALU_SUB; end
            4'h9: begin branch = 1'b1; alu_src = 1'b0; alu_op = ALU_SUB; end
            4'hA: begin jump = 1'b1; alu_op = ALU_ADD; end
            4'hF: begin pc_we = 1'b0; end
            default: begin end
        endcase
    end

endmodule