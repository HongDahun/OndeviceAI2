class spi_coverage extends uvm_subscriber #(spi_seq_item);
    `uvm_component_utils(spi_coverage)

    spi_seq_item tr;

    covergroup spi_cg;
        option.per_instance = 1;

        cp_master_tx : coverpoint tr.master_tx_data {
            bins zero = {8'h00};
            bins aa   = {8'hAA};
            bins ff   = {8'hFF};
            bins etc  = {[8'h01:8'hFE]};
        }

        cp_slave_tx : coverpoint tr.slave_tx_data {
            bins zero = {8'h00};
            bins aa   = {8'hAA};
            bins ff   = {8'hFF};
            bins etc  = {[8'h01:8'hFE]};
        }

        cp_master_rx : coverpoint tr.master_rx_data {
            bins zero = {8'h00};
            bins aa   = {8'hAA};
            bins ff   = {8'hFF};
            bins etc  = {[8'h01:8'hFE]};
        }

        cp_slave_rx : coverpoint tr.slave_rx_data {
            bins zero = {8'h00};
            bins aa   = {8'hAA};
            bins ff   = {8'hFF};
            bins etc  = {[8'h01:8'hFE]};
        }

        cx_tx : cross cp_master_tx, cp_slave_tx;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        spi_cg = new();
    endfunction

    function void write(spi_seq_item t);
        tr = t;
        `uvm_info("COV", $sformatf( "Sample TX=(%02h,%02h)", tr.master_tx_data, tr.slave_tx_data ), UVM_LOW)
        spi_cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COV", "==============================", UVM_LOW)
        `uvm_info("COV", "=== Functional Coverage ===", UVM_LOW)
        `uvm_info("COV", $sformatf("전체      : %6.2f %%", spi_cg.get_inst_coverage()), UVM_LOW)
        `uvm_info("COV", $sformatf("Master TX : %6.2f %%", spi_cg.cp_master_tx.get_inst_coverage()), UVM_LOW)
        `uvm_info("COV", $sformatf("Slave TX  : %6.2f %%", spi_cg.cp_slave_tx.get_inst_coverage()), UVM_LOW)
        `uvm_info("COV", $sformatf("Master RX : %6.2f %%", spi_cg.cp_master_rx.get_inst_coverage()), UVM_LOW)
        `uvm_info("COV", $sformatf("Slave RX  : %6.2f %%", spi_cg.cp_slave_rx.get_inst_coverage()), UVM_LOW)
        `uvm_info("COV", $sformatf("TX Cross  : %6.2f %%", spi_cg.cx_tx.get_inst_coverage()), UVM_LOW)
        `uvm_info("COV", "==============================", UVM_LOW)

        if (spi_cg.get_inst_coverage() < 100.0) begin
            `uvm_warning( "COV", "Coverage 100% 미달. 시나리오 추가 필요")
        end
    endfunction

endclass