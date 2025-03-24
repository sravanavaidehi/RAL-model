  class env extends uvm_env;
  
  agent          agent_inst;
  top_mem        top_mem_h;   
  top_adapter    adapter_inst;
  sco s;
  uvm_reg_predictor   #(transaction)  predictor_inst;
    
    
  `uvm_component_utils(env)
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  //---------------------------------------
  // build_phase - create the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    predictor_inst = uvm_reg_predictor#(transaction)::type_id::create("predictor_inst", this);
    
    s = sco::type_id::create("s", this);
 
    agent_inst = agent::type_id::create("agent_inst", this);
    top_mem_h   = top_mem::type_id::create("top_mem_h", this);
    top_mem_h.build();
    
    
    adapter_inst = top_adapter::type_id::create("adapter_inst",, get_full_name());
  endfunction 
  
 
  function void connect_phase(uvm_phase phase);
    
    predictor_inst.map       = top_mem_h.default_map;
    predictor_inst.adapter   = adapter_inst;
    
    agent_inst.m.mon_ap.connect(predictor_inst.bus_in);
 
    
    agent_inst.m.mon_ap.connect(s.recv);
  
    top_mem_h.default_map.set_sequencer( .sequencer(agent_inst.seqr), .adapter(adapter_inst) );
    top_mem_h.default_map.set_base_addr(0);        
  endfunction 
 
endclass
 
