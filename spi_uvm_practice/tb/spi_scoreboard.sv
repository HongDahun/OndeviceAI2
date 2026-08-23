class spi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(spi_scoreboard)

    uvm_analysis_imp #(spi_seq_item, spi_scoreboard) imp;

    int pass_count;
    int fail_count;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);

        pass_count = 0;
        fail_count = 0;
    endfunction

    function void write(spi_seq_item tr);

        bit master_ok;
        bit slave_ok;

        // Master가 받은 데이터는 Slave가 보낸 데이터
        master_ok = (tr.master_rx_data == tr.slave_tx_data);

        // Slave가 받은 데이터는 Master가 보낸 데이터
        slave_ok  = (tr.slave_rx_data  == tr.master_tx_data);

        if(master_ok && slave_ok) begin
            pass_count++;

            `uvm_info(
                get_type_name(),
                $sformatf(
                    "PASS : TX=(%02h,%02h) RX=(%02h,%02h)",
                    tr.master_tx_data,
                    tr.slave_tx_data,
                    tr.master_rx_data,
                    tr.slave_rx_data
                ),
                UVM_HIGH
            );
        end
        else begin
            fail_count++;

            `uvm_error(
                get_type_name(),
                $sformatf(
                    "FAIL : TX=(%02h,%02h) RX=(%02h,%02h) EXP=(%02h,%02h)",
                    tr.master_tx_data,
                    tr.slave_tx_data,
                    tr.master_rx_data,
                    tr.slave_rx_data,
                    tr.slave_tx_data,
                    tr.master_tx_data
                )
            );
        end

    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("SCB",
            "=====================================", UVM_LOW)

        `uvm_info("SCB",
            "======= Scoreboard 최종 리포트 =======", UVM_LOW)

        `uvm_info("SCB",
            $sformatf("  pass count : %0d", pass_count), UVM_LOW)

        `uvm_info("SCB",
            $sformatf("  fail count : %0d", fail_count), UVM_LOW)

        `uvm_info("SCB",
            "=====================================", UVM_LOW)
    endfunction

endclass