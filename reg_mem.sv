class ram extends uvm_mem;
  `uvm_object_utils(ram)
  
  function new(string name = "ram");
    super.new(name,64,32,"RW",UVM_NO_COVERAGE);
  endfunction 
  
endclass


class dut_mem2 extends uvm_mem;
 
`uvm_object_utils(dut_mem2)
 
  function new(string name = "dut_mem2");
    super.new(name, 1024, 16, "RW", UVM_NO_COVERAGE);
endfunction
 
endclass
  
