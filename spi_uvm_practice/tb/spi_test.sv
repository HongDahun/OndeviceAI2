class spi_base_test extends uvm_test;
    `uvm_component_utils(spi_base_test)

    spi_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = spi_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

endclass

class spi_random_test extends spi_base_test;
    `uvm_component_utils(spi_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    task run_phase(uvm_phase phase);

        spi_random_seq seq;

        phase.raise_objection(this);

        seq = spi_random_seq::type_id::create("seq");

        assert(seq.randomize());
        seq.num = 1000;
        seq.start(env.agt.sqr);

        #100;

        phase.drop_objection(this);

    endtask

endclass

class spi_full_test extends spi_base_test;
    `uvm_component_utils(spi_full_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);

        spi_fixed_seq  fixed_seq;
        spi_random_seq random_seq;

        phase.raise_objection(this);

        // Corner Case
        fixed_seq = spi_fixed_seq::type_id::create("fixed_seq");
        fixed_seq.start(env.agt.sqr);

        // Random Case
        random_seq = spi_random_seq::type_id::create("random_seq");
        random_seq.num = 5000;
        random_seq.start(env.agt.sqr);

        #100;

        phase.drop_objection(this);

    endtask
endclass