class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_if s_if;

    uvm_analysis_port #(spi_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual spi_if)::get(this, "", "s_if", s_if))
            `uvm_fatal(get_type_name(), "virtual interface(s_if)를 config_db에서 찾지 못함")
    endfunction

    task run_phase(uvm_phase phase);

        spi_seq_item tr;

        forever begin

            // 실제 done 이벤트 대기
            @(posedge s_if.master_done);

            tr = spi_seq_item::type_id::create("tr");

            // done 시점의 tx 데이터 캡처
            tr.master_tx_data = s_if.master_tx_data;
            tr.slave_tx_data  = s_if.slave_tx_data;

            // rx 안정화용 1클럭 대기
            @(s_if.mon_cb);

            tr.master_rx_data = s_if.master_rx_data;
            tr.slave_rx_data  = s_if.slave_rx_data;

            `uvm_info("MON",
                $sformatf(
                    "TX=(%02h,%02h) RX=(%02h,%02h)",
                    tr.master_tx_data,
                    tr.slave_tx_data,
                    tr.master_rx_data,
                    tr.slave_rx_data
                ),
                UVM_LOW)

            ap.write(tr);

        end

    endtask
endclass