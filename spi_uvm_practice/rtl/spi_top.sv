module spi_top (

    input  logic clk,
    input  logic reset,

    input  logic start,
    input  logic cpol,
    input  logic cpha,
    input  logic [7:0] clk_div,
    input  logic [7:0] master_tx_data,
    input  logic [7:0] slave_tx_data,

    output logic [7:0] master_rx_data,
    output logic [7:0] slave_rx_data,
    output logic master_busy,
    output logic master_done,
    output logic slave_busy,
    output logic slave_done

);

    logic sclk;
    logic ss_n;
    logic mosi;
    logic miso;

    spi_master U_MASTER (
        .clk(clk),
        .reset(reset),
        .start(start),
        .cpol(cpol),
        .cpha(cpha),
        .clk_div(clk_div),
        .tx_data(master_tx_data),
        .rx_data(master_rx_data),
        .done(master_done),
        .busy(master_busy),
        .sclk(sclk),
        .ss_n(ss_n),
        .mosi(mosi),
        .miso(miso)
    );

    spi_slave_top U_SLAVE (
        .clk(clk),
        .rst(reset),
        .tx_data(slave_tx_data),
        .rx_data(slave_rx_data),
        .done(slave_done),
        .busy(slave_busy),
        .sclk(sclk),
        .ss_n(ss_n),
        .mosi(mosi),
        .miso(miso)
    );

endmodule