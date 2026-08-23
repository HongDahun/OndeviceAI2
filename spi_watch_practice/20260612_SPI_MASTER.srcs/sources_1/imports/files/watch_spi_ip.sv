`timescale 1ns / 1ps

module watch_spi_ip (
    input  logic       clk,
    input  logic       rst,

    // ── watch_datapath 연결 ──────────────────────────────────
    input  logic [6:0] i_msec,   // 0~99
    input  logic [5:0] i_sec,    // 0~59
    input  logic [5:0] i_min,    // 0~59
    input  logic [4:0] i_hour,   // 0~23

    // ── SPI 물리 핀 ─────────────────────────────────────────
    input  logic       sclk,
    input  logic       mosi,
    input  logic       ss_n,
    output logic       miso,

    // ── 상태 출력 (선택적 사용) ──────────────────────────────
    output logic       busy,
    output logic       done      // 1클럭 펄스: 수신 완료
);

    // ── SPI slave 내부 신호 ──────────────────────────────────
    logic [7:0] tx_data;
    logic [7:0] rx_data;

    // ── SPI Slave 인스턴스 ───────────────────────────────────
    spi_slave_top U_SPI_SLAVE (
        .clk     (clk),
        .rst     (rst),
        .sclk    (sclk),
        .mosi    (mosi),
        .ss_n    (ss_n),
        .miso    (miso),
        .tx_data (tx_data),
        .rx_data (rx_data),
        .busy    (busy),
        .done    (done)
    );

    // ── 명령어 디코더: done 펄스 시 tx_data 갱신 ────────────
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_data <= 8'h00;
        end else if (done) begin
            case (rx_data)
                8'hA1:   tx_data <= {3'b000, i_hour};  // 5비트 → 8비트 패딩
                8'hA2:   tx_data <= {2'b00,  i_min};   // 6비트 → 8비트 패딩
                8'hA3:   tx_data <= {2'b00,  i_sec};   // 6비트 → 8비트 패딩
                8'hA4:   tx_data <= {1'b0,   i_msec};  // 7비트 → 8비트 패딩
                default: tx_data <= 8'hFF;
            endcase
        end
    end

endmodule
