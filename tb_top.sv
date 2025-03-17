// Code your testbench here
// or browse Examples

`include "uvm_macros.svh"
`include "sequence.sv"
`include "driver.sv"
`include "reg_block.sv"
`include "adapter.sv"
`include "agent.sv"
`include "env.sv"
`include "test.sv"

module tb;
  import uvm_pkg::*;
    
  top_if tif();
    
  top dut (tif.clk, tif.rst, tif.wr, tif.addr, tif.din, tif.dout);
 
  
  initial begin
   tif.clk <= 0;
  end
 
  always #10 tif.clk = ~tif.clk;
 
  
  
  initial begin
    uvm_config_db#(virtual top_if)::set(null, "*", "tif", tif);
    
    uvm_config_db#(int)::set(null,"*","include_coverage", 0); //to remove include coverage message
 
    run_test("test");
   end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
  
endmodule
