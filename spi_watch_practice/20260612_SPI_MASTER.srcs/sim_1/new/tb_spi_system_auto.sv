`timescale 1ns / 1ps

module tb_spi_system_auto();

    logic clk;
    logic rst;

    logic btnR;
    logic btnL;
    logic btnU;
    logic btnD;

    logic sw;

    logic sclk;
    logic mosi;
    logic miso;
    logic ss_n;

    logic [7:0] fnd_data;
    logic [3:0] fnd_com;
    logic led;

    //--------------------------------------
    // Clock
    //--------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;   // 100MHz
    

    //--------------------------------------
    // DUT
    //--------------------------------------
    master_top U_MASTER (
        .clk(clk),
        .rst(rst),

        .btnR(btnR),
        .btnL(btnL),
        .btnU(btnU),
        .btnD(btnD),

        .sw(sw),

        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .ss_n(ss_n),

        .fnd_data(fnd_data),
        .fnd_com(fnd_com),
        .led(led)
    );
    watch_top U_SLAVE (
        .clk     (clk),
        .rst     (rst),
        .btnR    (1'b0),
        .btnL    (1'b0),
        .btnU    (1'b0),
        .btnD    (1'b0),
        .sw      (1'b0),
        .fnd_data(s_fnd_data),
        .fnd_com (s_fnd_com),
        .led     (s_led),
        .sclk    (sclk),
        .mosi    (mosi),
        .ss_n    (ss_n),
        .miso    (miso)
    );

    //--------------------------------------
    // Stimulus
    //--------------------------------------
    initial begin

        rst  = 1;
        btnR = 0;
        btnL = 0;
        btnU = 0;
        btnD = 0;
        sw   = 0;

        #100;
        rst = 0;

        // Hour
        #1000;
        btnR = 1;
        #100_000;
        btnR = 0;

        // Minute
        #200_000;
        btnL = 1;
        #100_000;
        btnL = 0;

        // Second
        #200_000;
        btnU = 1;
        #100_000;
        btnU = 0;

        // Msec
        #200_000;
        btnD = 1;
        #100_000;
        btnD = 0;

        #100000;
        $finish;
    end

endmodule
