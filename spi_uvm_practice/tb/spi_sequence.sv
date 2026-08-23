class spi_base_seq extends uvm_sequence #(spi_seq_item);

    `uvm_object_utils(spi_base_seq)

    function new(string name = "spi_base_seq");
        super.new(name);
    endfunction

    task send_spi(
        bit [7:0] master_tx,
        bit [7:0] slave_tx
    );

        spi_seq_item item;
        `uvm_info("SEQ", $sformatf("SEND (%02h,%02h)", master_tx, slave_tx), UVM_LOW)

        item = spi_seq_item::type_id::create("item");

        start_item(item);

        item.master_tx_data = master_tx;
        item.slave_tx_data  = slave_tx;

        finish_item(item);

    endtask

endclass

class spi_fixed_seq extends spi_base_seq;
    `uvm_object_utils(spi_fixed_seq)

    function new(string name = "spi_fixed_seq");
        super.new(name);
    endfunction

    task body();
        `uvm_info(get_type_name(), "SPI Fixed Pattern Test Start", UVM_LOW)

        // All Zero
        send_spi(8'h00, 8'h00);

        // All One
        send_spi(8'hFF, 8'hFF);

        // Checker Pattern
        send_spi(8'hAA, 8'h55);
        send_spi(8'h55, 8'hAA);

        // Single Bit
        send_spi(8'h01, 8'h80);
        send_spi(8'h80, 8'h01);

        // Existing
        send_spi(8'h00, 8'hFF);
        send_spi(8'hFF, 8'h00);

        send_spi(8'hAA, 8'hFF);
        send_spi(8'hFF, 8'hAA);
        send_spi(8'h00, 8'hAA);
        send_spi(8'hAA, 8'h00);
        send_spi(8'hAA, 8'hAA);

        `uvm_info(get_type_name(), "SPI Fixed Pattern Test End", UVM_LOW)
    endtask
endclass

class spi_random_seq extends spi_base_seq;

    `uvm_object_utils(spi_random_seq)

    rand int num;

    constraint c_num { num inside {[10:30]};}

    function new(string name = "spi_random_seq");
        super.new(name);
    endfunction

    task body();

        spi_seq_item item;
        `uvm_info("SEQ","Sequence Start",UVM_LOW)

        `uvm_info( get_type_name(), $sformatf( "SPI Random Test Start (%0d)", num), UVM_LOW)

        repeat(num) begin
            item = spi_seq_item::type_id::create("item");
            start_item(item);

            if(!item.randomize()) 
                `uvm_error( "SEQ", "Randomize Failed")
            finish_item(item);
        end

        `uvm_info(
            get_type_name(), "SPI Random Test End", UVM_LOW)
    endtask

endclass