`timescale 1ns / 1ps

module dedicated_cpu_counter (
    input        clk,
    input        rst,
    output [7:0] out
);
    logic eq9;
    logic asrc_sel;
    logic areg_load;
    logic out_sel;
    control_unit U_CONTROL_UNIT (.*);
    data_path U_DATA_PATH (.*);
endmodule

module data_path (
    input        clk,
    input        rst,
    input        asrc_sel,
    input        areg_load,
    input        out_sel,
    output       eq9,
    output [7:0] out
);
    logic [7:0] mux_out, reg_out, alu_result;

    mux_2x1 U_MUX_2x1 (
        .in0    (8'h00),
        .in1    (alu_result),
        .sel    (asrc_sel),
        .mux_out(mux_out)
    );

    a_reg U_A_REG (
        .clk     (clk),
        .rst     (rst),
        .load    (areg_load),
        .data_in (mux_out),
        .data_out(reg_out)
    );

    alu U_ALU (
        .a         (reg_out),
        .b         (8'h01),
        .alu_result(alu_result)
    );

    comp_eq9 U_COMP_EQ9 (
        .in     (reg_out),
        .compare(8'h09),
        .eq_9   (eq9)
    );

    assign out = (out_sel) ? reg_out : 8'hzz;

endmodule

module mux_2x1 (
    input  logic [7:0] in0,
    input  logic [7:0] in1,
    input  logic       sel,
    output logic [7:0] mux_out
);
    //assign mux_out = (sel == 0) ? in0 : in1;
    always_comb begin
        if (sel == 0) mux_out = in0;
        else mux_out = in1;
    end
endmodule

module a_reg (
    input  logic       clk,
    input  logic       rst,
    input  logic       load,
    input  logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] a_register;

    assign data_out = a_register;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            a_register <= 0;
        end else begin
            if (load) begin
                a_register <= data_in;
            end
        end
    end

endmodule

module alu (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] alu_result
);

    assign alu_result = a + b;

endmodule

module comp_eq9 (
    input [7:0] in,
    input [7:0] compare,
    output eq_9
);
    assign eq_9 = (in == compare);
endmodule

module control_unit (
    input  logic clk,
    input  logic rst,
    input  logic eq9,
    output logic asrc_sel,
    output logic areg_load,
    output logic out_sel
);
    typedef enum {
        S0 = 0,
        S1,
        S2
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
        n_state   = c_state;
        asrc_sel  = 0;
        areg_load = 1;
        out_sel   = 0;
        case (c_state)
            S0: begin
                asrc_sel  = 0;
                areg_load = 1;
                out_sel   = 0;
                n_state   = S1;
            end
            S1: begin
                if (eq9) begin
                    asrc_sel  = 0;
                    areg_load = 0;
                    out_sel   = 0;
                    n_state   = S2;
                end else begin
                    asrc_sel  = 1;
                    areg_load = 1;
                    out_sel   = 0;
                    n_state   = S1;
                end
            end
            S2: begin
                asrc_sel  = 0;
                areg_load = 0;
                out_sel   = 1;
            end
        endcase
    end
endmodule
