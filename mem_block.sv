class mem extends uvm_mem;
  `uvm_object_utils(mem)
  function new(string name = "mem");
    super.new(name, 16, 8, "RW", UVM_NO_COVERAGE);
  endfunction 
endclass

//----------------top mem block-----------------
class top_mem extends uvm_reg_block;
  `uvm_object_utils(top_mem)
  function new(string name = "top_mem");
    super.new(name,UVM_NO_COVERAGE);
  endfunction
  
  mem mem_h;
  
  function void build();
    
    add_hdl_path("dut", "RTL");
    
    mem_h = new("mem_h");
    mem_h.add_hdl_path_slice("mem_h", 0 ,8);
    mem_h.configure(this);
   
    
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN, 1); //// name, base, nBytes,byte_addressing 
    //byte addressing means consider 32bit wide to be written in the memory but memory can only store 8 bits per location then bits are located as (0 - 7) - Location 1 (8-15) - Location 2 (16-23) in Location3 (24-32) in Location4 then the Byte addressing is 4. In this example since we are writting 8 bits and the memory is of 8 bit wide "1" is used.
    
    default_map.add_mem(mem_h, 'h0);// reg, offset, access
    
    lock_model();
  endfunction
endclass

//-----------------reg model sequence-----------
class top_seq extends uvm_sequence;
  `uvm_object_utils(top_seq)
  function new(string name = "top_seq");
    super.new(name);
  endfunction 
  
  top_mem top_mem_h;
  
  task body();
    uvm_status_e status;
    bit [7:0] data,rdata;
    
    //-------------single frontdoor and backdoor access
    top_mem_h.mem_h.write(status, 'h0, 'h4); //status,location,value
    top_mem_h.mem_h.read(status, 'h0, rdata);
    `uvm_info("SEQ", $sformatf("Data read : %0h", rdata), UVM_NONE);
    $display("-----------------------------------------");
    
    top_mem_h.mem_h.poke(status, 'h1, 'h12); //status,location,value
    top_mem_h.mem_h.peek(status, 'h1, rdata);
    `uvm_info("SEQ", $sformatf("Data read : %0h", rdata), UVM_NONE);
    $display("-----------------------------------------");
  endtask
endclass

    
