`timescale 1ns / 1ps

`include "define.vh"

module control_unit (
    input  logic [31:0] instr_code,
    output logic        rf_we,
    output logic        branch,
    output logic        jal,
    output logic        jalr,
    output logic        alusrc_sel,
    output logic [ 3:0] alu_control,
    output logic [ 2:0] rfsrc_sel,
    output logic [ 2:0] mem_mode,
    output logic        dwe
);
    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;

    assign funct3 = instr_code[14:12];
    assign funct7 = instr_code[31:25];
    assign opcode = instr_code[6:0];

    //[DEBUG]
    typedef enum logic [6:0] {
        DBG_R_TYPE  = `R_TYPE,
        DBG_S_TYPE  = `S_TYPE,
        DBG_IL_TYPE = `IL_TYPE,
        DBG_I_TYPE  = `I_TYPE,
        DBG_B_TYPE  = `B_TYPE,
        DBG_UL_TYPE = `UL_TYPE,
        DBG_UA_TYPE = `UA_TYPE,
        DBG_J_TYPE  = `J_TYPE,
        DBG_JL_TYPE = `JL_TYPE
    } opcode_dbg_e;
    opcode_dbg_e opcode_dbg;
    assign opcode_dbg = opcode_dbg_e'(opcode);

    always_comb begin
        rf_we       = 0;
        branch      = 0;
        jal         = 0;
        jalr        = 0;
        alusrc_sel  = 0;
        alu_control = 0;
        rfsrc_sel   = 0;
        mem_mode    = 3'b0;
        dwe         = 0;
        case (opcode)
            `R_TYPE: begin
                rf_we       = 1'b1;
                branch      = 0;
                jal         = 0;
                jalr        = 0;
                alusrc_sel  = 0;
                alu_control = {funct7[5], funct3};
                rfsrc_sel   = 0;
                mem_mode    = 3'b0;
                dwe         = 0;
            end
            `S_TYPE: begin
                rf_we       = 1'b0;
                branch      = 0;
                jal         = 0;
                jalr        = 0;
                alusrc_sel  = 1'b1;
                alu_control = `ADD;
                rfsrc_sel   = 0;
                mem_mode    = funct3;
                dwe         = 1'b1;
            end
            `IL_TYPE: begin
                rf_we       = 1'b1;  // rs1 + imm
                branch      = 0;
                jal         = 0;
                jalr        = 0;
                alusrc_sel  = 1'b1;
                alu_control = `ADD;
                rfsrc_sel   = 1;  // from data memory
                mem_mode    = funct3;
                dwe         = 1'b0;
            end
            `I_TYPE: begin
                rf_we      = 1'b1;  // rs1 + imm
                branch     = 0;
                jal        = 0;
                jalr       = 0;
                alusrc_sel = 1'b1;
                if (funct3 == 3'b101) begin
                    alu_control = {funct7[5], funct3};
                end else begin
                    alu_control = {1'b0, funct3};
                end
                rfsrc_sel = 0;  // alu_result
                mem_mode  = 0;
                dwe       = 1'b0;
            end
            `B_TYPE: begin
                rf_we       = 1'b0;
                branch      = 1;
                jal         = 0;
                jalr        = 0;
                alusrc_sel  = 1'b0;
                alu_control = {1'b0, funct3};
                rfsrc_sel   = 0;
                mem_mode    = 0;
                dwe         = 0;
            end
            `UL_TYPE, `UA_TYPE: begin
                rf_we       = 1'b1;
                branch      = 0;
                jal         = 0;
                jalr        = 0;
                alusrc_sel  = 1'b0;
                alu_control = 4'b0;
                if (opcode == `UL_TYPE) begin
                    rfsrc_sel = 3'b010;
                end else begin
                    rfsrc_sel = 3'b011;
                end
                mem_mode  = 0;
                dwe       = 0;
            end
            `J_TYPE, `JL_TYPE: begin
                rf_we  = 1'b1;
                branch = 0;
                jal    = 1;
                if (opcode == `J_TYPE) begin
                    jalr = 0;
                end else begin
                    jalr = 1;
                end
                alusrc_sel  = 1'b0;
                alu_control = 4'b0;
                rfsrc_sel   = 3'b100;
                mem_mode    = 0;
                dwe         = 0;
            end
        endcase
    end
endmodule
