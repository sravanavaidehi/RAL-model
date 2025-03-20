class env extends uvm_env;
  `uvm_component_utils(env);
  function new(string name = "env", uvm_component parent = null);
    super.new(name,parent);
  endfunction 
  
  agent ag;
  top_reg top_reg_h;
  adap adap_h;
  
  //Adding explicit predictor
  uvm_reg_predictor #(transaction) predict_h; 
  
  //scoreboard
  sco sc_h;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag = agent::type_id::create("ag",this);
    top_reg_h = top_reg::type_id::create("top_reg_h",this);
    top_reg_h.build();
    
    adap_h = adap::type_id::create("adap_h", , get_full_name()); 
    
    predict_h = uvm_reg_predictor#(transaction)::type_id::create("predict_h",this);
    
    sc_h = sco::type_id::create("sc_h",this);
                                                   
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ag.mon_h.mon_ap.connect(sc_h.recv);
    
    top_reg_h.default_map.set_sequencer(.sequencer(ag.seqr), .adapter(adap_h));
    top_reg_h.default_map.set_base_addr(0);
    
    //connecting predictor the monitor analysis port 
    predict_h.map = top_reg_h.default_map;
    predict_h.adapter = adap_h;
    ag.mon_h.mon_ap.connect(predict_h.bus_in);
    
   
  endfunction
endclass

    
    
