`timescale 1ns / 1ps

module instruction_mem (
    input  logic [31:0] instr_addr,
    output logic [31:0] instr_code
);

    logic [31:0] instr_rom[0:127];
`ifdef TEST_SIMULATION
    initial begin
        //R_type
        //instr_rom[0] = 32'h0031_0233; // add x4, x2, x3
        //instr_rom[1] = 32'h4040_02b3; // sub x5, x0, x4
        //instr_rom[2] = 32'h0012_1333; // sll x6, x4, x1
        //instr_rom[3] = 32'h0013_53b3; // srl x7, x6, x1
        //instr_rom[4] = 32'h4012_d433; // sra x8, x5, x1
        //instr_rom[5] = 32'h0014_24b3; // slt x9, x8, x1
        //instr_rom[6] = 32'h0014_3533; // sltu x10, x8, x1
        //instr_rom[7] = 32'h00a4_c5b3; // xor x11, x9, x10
        //instr_rom[8] = 32'h0025_e633; // or x12, x11, x2
        //instr_rom[9] = 32'h0036_76b3; // or x13, x12, x3
        // I_type
        //instr_rom[0] = 32'hffd0_0093; // addi x1, x0, -3
        //instr_rom[1] = 32'hfff0_c113; // xori x2, x1, -1
        //instr_rom[2] = 32'hfff1_6193; // ori x3, x2, -1
        //instr_rom[3] = 32'hffe1_f213; // andi x4, x3, -2
        //instr_rom[4] = 32'h0012_1293; // slli x5, x4, 1
        //instr_rom[5] = 32'h01e2_d313; // srli x6, x5, 30
        //instr_rom[6] = 32'h4013_5393; // srai x7, x6, 1
        //instr_rom[7] = 32'hffe3_a413; // slti x8, x7, -2
        //instr_rom[8] = 32'hfff4_3493; // sltiU x9, x8, -1
        // S_type
        //instr_rom[0] = 32'h0054_0023; // sb x5, 0(x8)
        //instr_rom[1] = 32'h0054_1223; // sh x5, 4(x8)
        //instr_rom[2] = 32'h0054_2423; // sw x5, 8(x8)
        // IL_type
        //instr_rom[0] = 32'h0004_0103; // lb x2, 0(x8)
        //instr_rom[1] = 32'h0044_1183; // lh x3, 4(x8)
        //instr_rom[2] = 32'h0084_2203; // lw x4, 8(x8)
        //instr_rom[3] = 32'h0004_4283; // lbu x5, 0(x8)
        //instr_rom[4] = 32'h0044_5303; // lhu x6, 4(x8)
        //B_type
        //instr_rom[0] = 32'h0010_8863; // beq x1, x1, 16
        //instr_rom[4] = 32'h0020_9863; // bne x1, x2, 16
        //instr_rom[8] = 32'h0011_4863; // blt x2, x1, 16
        //instr_rom[12] = 32'h0020_5863; // bge x0, x2, 16
        //instr_rom[16] = 32'h0071_6863; // bltu x2, x7, 16
        //instr_rom[17] = 32'h0023_f863; // bgeu x7, x2, 16
        // UL-type, UA-type
        //instr_rom[0] = 32'h0000_40b7; // lui x1, 4
        //instr_rom[1] = 32'h0000_4097; // auipc x1, 4
        // J_type, JL_type
        //instr_rom[0] = 32'h0100_00ef; // jal x1, 16
        //instr_rom[4] = 32'h0103_81e7; // jalr x3, 16(x7)

        //instr_rom[0] = 32'h0031_02b3;  // x5 = x2 + x3
        //instr_rom[1] = 32'h0041_82b3;  // x5 = x4 + x3
        //instr_rom[2] = 32'h0031_2123;  // sw x2, x3, 2 : rs1, rs2, imm
        //instr_rom[2] = 32'h0031_1123;  // sh x2, x3, 2 : rs1, rs2, imm
        //instr_rom[3] = 32'h0021_2403;  // lw x8, x2, 2 : rd, rs1, imm
        //instr_rom[4] = 32'h0043_8413;  // addi x8, x7, 4 : rd, rs1, imm
        // BEQ :  ex) if treu then pc = pc - 8
        //instr_rom[5] = 32'hFE84_0CE3;  // BEQ x8, x8, -8 : rs1, rs2, imm, PC = PC + imm

        //instr_rom[0] = 32'h0073_0533;
        //instr_rom[1] = 32'h4073_05b3;
        //instr_rom[2] = 32'h4052_5633;
        //instr_rom[3] = 32'h0052_56b3;
        //instr_rom[4] = 32'h0052_1733;
        //instr_rom[5] = 32'h0031_27b3;
        //instr_rom[6] = 32'h0031_3833;
        //instr_rom[7] = 32'h0094_48b3;
        //instr_rom[8] = 32'h0094_6933;
        //instr_rom[9] = 32'h0094_79b3;
    end
`endif
    initial begin
        //$readmemh("instruction_code.mem", instr_rom);
        $readmemh("instruction_mem_sort.mem", instr_rom);
    end
    assign instr_code = instr_rom[instr_addr[31:2]];

endmodule
