class env extends uvm_env;
  `uvm_component_utils(env);
  function new(string name = "env", uvm_component parent = null);
    super.new(name,parent);
  endfunction 
  
  agent ag;
  top_reg top_reg_h;
  adap adap_h;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag = agent::type_id::create("ag",this);
    top_reg_h = top_reg::type_id::create("top_reg_h",this);
    top_reg_h.build();
    
    adap_h = adap::type_id::create("adap_h", , get_full_name());
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    top_reg_h.default_map.set_sequencer(.sequencer(ag.seqr),.adapter(adap_h));
    top_reg_h.default_map.set_base_addr(0);
  endfunction
endclass

    
    
