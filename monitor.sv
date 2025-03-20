class monitor extends uvm_monitor;
    `uvm_component_utils( monitor )
 
    uvm_analysis_port   #(transaction)  mon_ap;
    virtual     top_if              tif;
    transaction tr;
    
    function new(string name="my_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase (phase);
        mon_ap = new("mon_ap", this);
      if(! uvm_config_db#(virtual top_if)::get (this, "", "tif", tif))
        `uvm_error("MON", "Error getting Interface Handle")
    endfunction : build_phase
  
    virtual task run_phase(uvm_phase phase);
     tr = transaction::type_id::create("tr");
            forever begin
              repeat(3) @(posedge tif.clk);
                  tr.wr    = tif.wr;
                  tr.addr  = tif.addr;
                  tr.din   = tif.din;
                  tr.dout  = tif.dout;
                  `uvm_info("MON", $sformatf("Wr :%0b  Addr : %0d Din:%0d  Dout:%0d", tr.wr, tr.addr, tr.din, tr.dout), UVM_NONE)         
                  mon_ap.write(tr);
               
                end 
    endtask 
 
      
endclass
      
//----------------------------scoreboard--------------------------
      
 class sco extends uvm_scoreboard;
`uvm_component_utils(sco)
 
  uvm_analysis_imp#(transaction,sco) recv;
   bit [7:0] temp_data;
  bit [31:0] temp;
 
 
    function new(input string inst = "sco", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
    endfunction
    
    
  virtual function void write(transaction tr);
    `uvm_info("SCO", $sformatf("Wr :%0b  Addr : %0d Din:%0d  Dout:%0d", tr.wr, tr.addr, tr.din, tr.dout), UVM_NONE) 
 
    if(tr.wr == 1'b1)
        begin
          if(tr.addr == 1'b0) 
            begin
             temp_data = tr.din;
            `uvm_info("SCO", $sformatf("Data Stored : %0d", tr.din), UVM_NONE) 
            end
          else
            begin
              `uvm_info("SCO", "No Such Addr", UVM_NONE)
            end
        end
    else
       begin
          if(tr.addr == 1'b0) 
            begin
              if(tr.dout == temp_data)
                `uvm_info("SCO", "Test Passed", UVM_NONE) 
            end
          else
            begin
              `uvm_info("SCO", "No Such Addr", UVM_NONE);
            end
        end
    
    
        
  endfunction
 
endclass      
      
  
  
  
  
