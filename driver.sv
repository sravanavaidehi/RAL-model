class drv extends uvm_driver#(transaction);
  `uvm_component_utils(drv)
 
  transaction tr;
  virtual top_if vif;
 
  function new(input string path = "drv", uvm_component parent = null);
    super.new(path,parent);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    if(!uvm_config_db#(virtual top_if)::get(this,"","vif",vif))//uvm_test_top.env.agent.drv.aif
      `uvm_error("drv","Unable to access Interface");
  endfunction
  
   virtual task run_phase(uvm_phase phase);
      tr = transaction::type_id::create("tr");
     forever begin
        seq_item_port.get_next_item(tr);
               if(tr.wr == 1'b1)
                    begin
                    @(posedge vif.clk);
                    vif.wr   <= tr.wr;
                    vif.addr <= tr.addr;
                    vif.din  <= tr.din;
      `uvm_info("DRV", $sformatf("wr : %0b  addr : %0d  din : %0d dout : %0d", tr.wr, tr.addr, tr.din, tr.dout), UVM_NONE);
        
                   repeat(2) @(posedge vif.clk);  
                    end
                else
                  begin
                    @(posedge vif.clk);
                    vif.wr   <= tr.wr;
                    vif.addr <= tr.addr;
                    @(posedge vif.clk);
      `uvm_info("DRV", $sformatf("wr : %0b  addr : %0d  din : %0d dout : %0d", tr.wr, tr.addr, tr.din, vif.dout), UVM_NONE);
                    tr.dout   = vif.dout;
                     @(posedge vif.clk);
                   end
      seq_item_port.item_done();
      
      end
   endtask
 
 
endclass
 
