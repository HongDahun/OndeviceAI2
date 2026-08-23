class spi_driver extends uvm_driver #(spi_seq_item);

    `uvm_component_utils(spi_driver)

    virtual spi_if s_if;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual spi_if)::get(
            this, "", "s_if", s_if))
            `uvm_fatal(get_type_name(),
                "virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        // 초기화
        @(s_if.drv_cb);
        s_if.drv_cb.start          <= 0;
        s_if.drv_cb.master_tx_data <= 0;
        s_if.drv_cb.slave_tx_data  <= 0;

        //  수정: reset 상태 확인 후 대기
        if(s_if.reset) begin
            @(negedge s_if.reset);  // reset 중일 때만 대기
        end
        @(s_if.drv_cb);  // 한 클럭 여유

        forever begin
            spi_seq_item req;
            seq_item_port.get_next_item(req);

            @(s_if.drv_cb);
            s_if.drv_cb.master_tx_data <= req.master_tx_data;
            s_if.drv_cb.slave_tx_data  <= req.slave_tx_data;
            s_if.drv_cb.start          <= 1'b1;

            @(s_if.drv_cb);
            s_if.drv_cb.start <= 1'b0;

            //  master_done 직접 대기
            @(posedge s_if.master_done);

            seq_item_port.item_done();
        end
    endtask

endclass
