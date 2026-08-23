`timescale 1ns / 1ps
`include "define.vh"

module data_mem (
    input  logic        clk,
    input  logic        dwe,
    input  logic [ 2:0] mem_mode,
    input  logic [31:0] daddr,
    input  logic [31:0] dwdata,
    output logic [31:0] drdata
);

    logic [31:0] data_ram[0:63];

    assign drdata = data_ram[daddr[31:2]];

    // S_type
    //initial begin
    //    for (int i = 0; i < 64; i++) begin
    //        data_ram[i] = 32'hffff_ffff;
    //    end
    //end

    // IL_type
    //initial begin
    //    for (int i = 0; i < 64; i++) begin
    //        data_ram[i] = 32'h1234_5678;
    //    end
    //end

    always_ff @(posedge clk) begin
        if (dwe) begin
            case (mem_mode)
                `SB:  
                case (daddr[1:0])
                    2'b00: data_ram[daddr[31:2]][7:0] <= dwdata[7:0];
                    2'b01: data_ram[daddr[31:2]][15:8] <= dwdata[7:0];
                    2'b10: data_ram[daddr[31:2]][23:16] <= dwdata[7:0];
                    2'b11: data_ram[daddr[31:2]][31:24] <= dwdata[7:0];
                endcase
                `SH:  
                if (daddr[1] == 0)
                    data_ram[daddr[31:2]][15:0] <= dwdata[15:0];
                else data_ram[daddr[31:2]][31:16] <= dwdata[15:0];
                `SW:  
                data_ram[daddr[31:2]] <= dwdata;
            endcase
        end
    end

    always_comb begin
        drdata = 32'd0;
        case (mem_mode)
            `LB: begin
                case (daddr[1:0])
                    2'b00:
                    drdata = {
                        {24{data_ram[daddr[31:2]][7]}},
                        data_ram[daddr[31:2]][7:0]
                    };
                    2'b01:
                    drdata = {
                        {24{data_ram[daddr[31:2]][15]}},
                        data_ram[daddr[31:2]][15:8]
                    };
                    2'b10:
                    drdata = {
                        {24{data_ram[daddr[31:2]][23]}},
                        data_ram[daddr[31:2]][23:16]
                    };
                    2'b11:
                    drdata = {
                        {24{data_ram[daddr[31:2]][31]}},
                        data_ram[daddr[31:2]][31:24]
                    };
                endcase
            end
            `LH: begin
                if (daddr[1] == 0) begin
                    drdata = {
                        {16{data_ram[daddr[31:2]][15]}},
                        data_ram[daddr[31:2]][15:0]
                    };
                end else begin
                    drdata = {
                        {16{data_ram[daddr[31:2]][31]}},
                        data_ram[daddr[31:2]][31:16]
                    };
                end
            end
            `LW: begin
                drdata = data_ram[daddr[31:2]];
            end
            `LBU: begin
                case (daddr[1:0])
                    2'b00: drdata = {24'b0, data_ram[daddr[31:2]][7:0]};
                    2'b01: drdata = {24'b0, data_ram[daddr[31:2]][15:8]};
                    2'b10: drdata = {24'b0, data_ram[daddr[31:2]][23:16]};
                    2'b11: drdata = {24'b0, data_ram[daddr[31:2]][31:24]};
                endcase
            end
            `LHU: begin
                if (daddr[1] == 0) begin
                    drdata = {16'b0, data_ram[daddr[31:2]][15:0]};
                end else begin
                    drdata = {16'b0, data_ram[daddr[31:2]][31:16]};
                end
            end
        endcase
    end

endmodule
