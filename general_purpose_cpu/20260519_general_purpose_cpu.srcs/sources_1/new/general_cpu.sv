`timescale 1ns / 1ps

module general_cpu (
    input logic clk,
    input logic rst,
    output logic [7:0] out
);
    logic       ag10;
    logic [1:0] ra0;
    logic [1:0] ra1;
    logic [1:0] wa;
    logic       we;
    logic       rf_src_sel;

    control_unit U_CONTROL_UNIT (.*);
    datapath U_DATAPATH (.*);

endmodule

module datapath (
    input  logic       clk,
    input  logic       rst,
    input  logic       rf_src_sel,
    input  logic [1:0] ra0,
    input  logic [1:0] ra1,
    input  logic [1:0] wa,
    input  logic       we,
    output logic       ag10,
    output logic [7:0] out

);
    logic [7:0] alu_result, alusrc_mux_out, rd0_out;

    mux_2x1 U_MUX_2x1 (
        .in0(alu_result),
        .in1(8'h01),
        .sel(rf_src_sel),
        .mux_out(alusrc_mux_out)
    );

    alu U_ALU (
        .a(rd0_out),
        .b(out),
        .alu_result(alu_result)
    );

    register U_REGISTER (
        .clk(clk),
        .rst(rst),
        .ra0(ra0),
        .ra1(ra1),
        .wa (wa),
        .we (we),
        .wd (alusrc_mux_out),
        .rd0(rd0_out),
        .rd1(out)
    );

    comparator U_AG10 (
        .in(rd0_out),
        .compare(8'h09),
        .comp_out(ag10)
    );

endmodule

module mux_2x1 (
    input  logic [7:0] in0,
    input  logic [7:0] in1,
    input  logic       sel,
    output logic [7:0] mux_out
);
    assign mux_out = sel ? in0 : in1;
endmodule

module alu (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] alu_result
);
    assign alu_result = a + b;
endmodule

module register (
    input  logic       clk,
    input  logic       rst,
    input  logic [1:0] ra0,
    input  logic [1:0] ra1,
    input  logic [1:0] wa,
    input  logic       we,
    input  logic [7:0] wd,
    output logic [7:0] rd0,
    output logic [7:0] rd1
);
    logic [7:0] register_file[0:3];
    integer i;

    assign rd0 = (ra0 == 0) ? 0 : register_file[ra0];
    assign rd1 = register_file[ra1];

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                register_file[i] <= 0;
            end
        end else if (we) begin
            register_file[wa] <= wd;
        end
    end
endmodule

module comparator (
    input [7:0] in,
    input [7:0] compare,
    output comp_out
);
    assign comp_out = (in > compare);
endmodule

module control_unit (
    input  logic       clk,
    input  logic       rst,
    input  logic       ag10,
    output logic       rf_src_sel,
    output logic [1:0] ra0,
    output logic [1:0] ra1,
    output logic       we,
    output logic [1:0] wa
);

    typedef enum {
        S0 = 0,
        S1,
        S2,
        S3,
        S4,
        S5,
        S6,
        S7
    } state_t;

    state_t c_state, n_state;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    always_comb begin
        n_state = c_state;
        rf_src_sel = 0;
        ra0 = 0;
        ra1 = 0;
        wa = 0;
        we = 0;
        case (c_state)
            S0: begin
                rf_src_sel = 1;
                ra0 = 0;
                ra1 = 0;
                wa = 3;
                we = 1;
                n_state = S1;
            end
            S1: begin
                rf_src_sel = 1;
                ra0 = 0;
                ra1 = 0;
                wa = 2;
                we = 1;
                n_state = S2;
            end
            S2: begin
                rf_src_sel = 0;
                ra0 = 0;
                ra1 = 0;
                wa = 1;
                we = 1;
                n_state = S3;
            end
            S3: begin
                rf_src_sel = 0;
                ra0 = 3;
                ra1 = 0;
                wa = 0;
                we = 0;
                if (!ag10) begin
                    n_state = S4;
                end else begin
                    n_state = S7;
                end
            end
            S4: begin
                rf_src_sel = 0;
                ra0 = 0;
                ra1 = 2;
                wa = 0;
                we = 0;
                n_state = S5;
            end
            S5: begin
                rf_src_sel = 1;
                ra0 = 3;
                ra1 = 1;
                wa = 3;
                we = 1;
                n_state = S6;
            end
            S6: begin
                rf_src_sel = 1;
                ra0 = 2;
                ra1 = 3;
                wa = 2;
                we = 1;
                n_state = S3;
            end
            S7: begin
                rf_src_sel = 0;
                ra0 = 0;
                ra1 = 2;
                wa = 0;
                we = 0;
            end
        endcase
    end
endmodule
