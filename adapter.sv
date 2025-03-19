class adap extends uvm_reg_adapter;
  `uvm_object_utils(adap)
  function new(string name = "adap");
    super.new(name);
  endfunction
  
  transaction tr;
  
  //--------------reg2bus-----------------
  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    
    tr = transaction::type_id::create("tr");
    
    tr.wr = (rw.kind == UVM_WRITE) ? 1 : 0;
    tr.addr = rw.addr;
  
    if(tr.wr)
      tr.din = rw.data;
    
    return tr;
  endfunction 
  
  //--------------bus2reg-----------------
  function void bus2reg(uvm_sequence_item  bus_item, ref uvm_reg_bus_op rw);
   
    transaction tr;
    
    assert($cast(tr,bus_item));
    
    rw.kind = tr.wr ? UVM_WRITE : UVM_READ;
    rw.data = (tr.wr ==1) ? tr.din : tr.dout;
    rw.addr = tr.addr;
    rw.status = UVM_IS_OK;
    
  endfunction
endclass

          
