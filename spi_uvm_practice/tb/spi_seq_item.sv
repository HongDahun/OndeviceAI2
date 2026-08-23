class spi_seq_item extends uvm_sequence_item;

    rand bit [7:0] master_tx_data;
    rand bit [7:0] slave_tx_data;
    bit [7:0] master_rx_data;
    bit [7:0] slave_rx_data;

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_int(master_tx_data, UVM_ALL_ON)
        `uvm_field_int(slave_tx_data, UVM_ALL_ON)
        `uvm_field_int(master_rx_data, UVM_ALL_ON)
        `uvm_field_int(slave_rx_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "spi_seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf(
            "master_tx_data = 0x%02h, slave_tx_data = 0x%02h, master_rx_data = 0x%02h, slave_rx_data = 0x%02h",
            master_tx_data,
            slave_tx_data,
            master_rx_data,
            slave_rx_data);
    endfunction
endclass