//////////////////////////////////////////////////////////////////////////////////////////////////
 
 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new(input string inst = "test", uvm_component c);
super.new(inst,c);
endfunction
 
env e;
top_seq trseq;
 
 
  
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
   e      = env::type_id::create("env",this);
   trseq  = top_seq::type_id::create("trseq");
endfunction
 
virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  assert(trseq.randomize());
  trseq.top_mem_h = e.top_mem_h;
  trseq.start(e.agent_inst.seqr);
  phase.drop_objection(this);
  phase.phase_done.set_drain_time(this, 50);
endtask
  
  
  
endclass
