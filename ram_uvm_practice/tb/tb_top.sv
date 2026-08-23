import uvm_pkg::*;
import ram_pkg::*;

module tb_top ();
    logic clk;

    initial clk = 0;
    always #5 clk = ~clk;

    ram_if r_if(.clk(clk));

    ram dut (
        .clk(r_if.clk),
        .write(r_if.write),
        .addr(r_if.addr),
        .wdata(r_if.wdata),
        .rdata(r_if.rdata)
    );

    initial begin
        uvm_config_db#(virtual ram_if)::set(null, "*", "r_if", r_if); // 항상 제일 처음에 시작되어야함
        run_test("ram_test");
    end

    initial begin
        $fsdbDumpfile("ram_tb.fsdb");
        $fsdbDumpvars(0);
        $fsdbDumpMDA(); // 메모리 배열(mem) 덤프
    end
endmodule