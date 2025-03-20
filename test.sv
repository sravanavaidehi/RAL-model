class test extends uvm_test;
`uvm_component_utils(test)
 
function new(input string inst = "test", uvm_component c);
super.new(inst,c);
endfunction
 
env e;
reg_seq trseq;
 
 
  
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
   e      = env::type_id::create("env",this);
   trseq  = reg_seq::type_id::create("trseq");
  
  // e.set_config_int( "*", "include_coverage", 0 );
endfunction
 
virtual task run_phase(uvm_phase phase);
  
  phase.raise_objection(this);
  
  trseq.top_reg_h = e.top_reg_h;
  trseq.start(e.ag.seqr);
  phase.drop_objection(this);
  
  phase.phase_done.set_drain_time(this, 200);
endtask
endclass
