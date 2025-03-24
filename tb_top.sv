// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "mem_block.sv"
`include "adapter.sv"
`include "sc.sv"
`include "env.sv"
`include "test.sv"

module tb;
  
    import uvm_pkg::*;
    
  top_if vif();
    
  top dut (vif.clk, vif.wr, vif.addr, vif.din, vif.dout);
 
  
  initial begin
   vif.clk <= 0;
  end
 
  always #10 vif.clk = ~vif.clk;
 
  
  
  initial begin
    uvm_config_db#(virtual top_if)::set(null, "*", "vif", vif);
    run_test("test");
   end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
  
endmodule
