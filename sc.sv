
 class sco extends uvm_scoreboard;
`uvm_component_utils(sco)
 
  uvm_analysis_imp#(transaction,sco) recv;
   bit [7:0] arr [16]; 
 
    function new(input string inst = "sco", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
    endfunction
    
    
  virtual function void write(transaction tr);
    `uvm_info("SCO", $sformatf("Wr :%0b  Addr : %0d Din:%0d  Dout:%0d", tr.wr, tr.addr, tr.din, tr.dout), UVM_NONE)                   if(tr.wr == 1'b1)
        begin
          arr[tr.addr] = tr.din;
          `uvm_info("SCO", $sformatf("Data Stored -> addr : %0d data : %0d", tr.addr, tr.din), UVM_NONE);             
        end
    else
       begin
         if(arr[tr.addr] == tr.dout)
           `uvm_info("SCO","Test Passed", UVM_NONE)
         else
           `uvm_info("SCO","Test Failed", UVM_NONE)
       end
           
   $display("---------------------------------------------");          
  endfunction
 
endclass    
