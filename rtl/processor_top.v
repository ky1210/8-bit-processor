module processor_top (
    input clk,
    input rst
);

    wire [7:0] pc_current;
    wire [7:0] pc_plus_1;
    wire [7:0] pc_next;
    wire       pc_we;

    wire [15:0] instr;

    wire [3:0] opcode;
    wire [2:0] rd_field;
    wire [2:0] rs_field;
    wire [2:0] rt_field;
    wire [5:0] imm6;
    wire [7:0] addr8;
    wire [11:0] target12;
    wire [7:0] imm6_ext;

    wire       reg_write;
    wire       mem_write;
    wire       mem_to_reg;
    wire       alu_src;
    wire       branch;
    wire       jump;
    wire [2:0] alu_op;

    wire [2:0] ra1;
    wire [2:0] ra2;
    wire [2:0] wa;

    wire [7:0] rf_rd1;
    wire [7:0] rf_rd2;
    wire [7:0] rf_wd;

    wire [7:0] alu_in2;
    wire [7:0] alu_result;
    wire       alu_zero;

    wire [7:0] dmem_rd;

    wire [7:0] branch_target;
    wire [7:0] jump_target;
    wire       branch_taken;

    assign opcode   = instr[15:12];
    assign rd_field = instr[11:9];
    assign rs_field = instr[8:6];
    assign rt_field = instr[5:3];
    assign imm6     = instr[5:0];
    assign addr8    = instr[7:0];
    assign target12 = instr[11:0];

    assign imm6_ext = {{2{imm6[5]}}, imm6};

    assign pc_plus_1 = pc_current + 8'd1;

    assign ra1 =
        (opcode == 4'h0 || opcode == 4'h1 || opcode == 4'h2 ||
         opcode == 4'h3 || opcode == 4'h4 || opcode == 4'h5) ? rs_field :
        (opcode == 4'h8 || opcode == 4'h9) ? rd_field :
        3'b000;

    assign ra2 =
        (opcode == 4'h0 || opcode == 4'h1 || opcode == 4'h2 ||
         opcode == 4'h3 || opcode == 4'h4) ? rt_field :
        (opcode == 4'h7) ? rd_field :
        (opcode == 4'h8 || opcode == 4'h9) ? rs_field :
        3'b000;

    assign wa =
        (opcode == 4'h0 || opcode == 4'h1 || opcode == 4'h2 ||
         opcode == 4'h3 || opcode == 4'h4 || opcode == 4'h5 ||
         opcode == 4'h6) ? rd_field :
        3'b000;

    assign alu_in2 =
        (opcode == 4'h5) ? imm6_ext :
        rf_rd2;

    assign rf_wd = (mem_to_reg) ? dmem_rd : alu_result;

    assign branch_target = pc_plus_1 + imm6_ext;
    assign jump_target   = target12[7:0];

    assign branch_taken =
        branch && (
            ((opcode == 4'h8) &&  alu_zero) ||
            ((opcode == 4'h9) && !alu_zero)
        );

    assign pc_next = jump         ? jump_target   :
                     branch_taken ? branch_target :
                                    pc_plus_1;

    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_we(pc_we),
        .pc_next(pc_next),
        .pc(pc_current)
    );

    imem imem_inst (
        .addr(pc_current),
        .instr(instr)
    );

    control_unit control_inst (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .pc_we(pc_we),
        .alu_op(alu_op)
    );

    regfile regfile_inst (
        .clk(clk),
        .we(reg_write),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(rf_wd),
        .rd1(rf_rd1),
        .rd2(rf_rd2)
    );

    alu alu_inst (
        .a(rf_rd1),
        .b(alu_in2),
        .alu_sel(alu_op),
        .y(alu_result),
        .zero(alu_zero)
    );

    dmem dmem_inst (
        .clk(clk),
        .we(mem_write),
        .addr((opcode == 4'h6 || opcode == 4'h7) ? addr8 : alu_result),
        .wd(rf_rd2),
        .rd(dmem_rd)
    );

endmodule