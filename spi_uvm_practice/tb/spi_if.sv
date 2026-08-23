interface spi_if(input logic clk);
    logic start;
    logic reset;
    logic [7:0] master_tx_data;
    logic [7:0] slave_tx_data;
    logic [7:0] master_rx_data;
    logic [7:0] slave_rx_data;
    logic master_busy;
    logic master_done;
    logic slave_busy;
    logic slave_done;

    clocking drv_cb @(posedge clk);
        default input #1step output #0;
            output start;
            output reset;
            output master_tx_data;
            output slave_tx_data;
            input master_rx_data;
            input slave_rx_data;
            input master_busy;
            input master_done;
            input slave_busy;
            input slave_done;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
            input start;
            input reset;
            input master_tx_data;
            input slave_tx_data;
            input master_rx_data;
            input slave_rx_data;
            input master_busy;
            input master_done;
            input slave_busy;
            input slave_done;
    endclocking

    modport DRV(clocking drv_cb, input clk);
    modport MON(clocking mon_cb, input clk);
endinterface