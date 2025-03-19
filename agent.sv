class agent extends uvm_agent;
`uvm_component_utils(agent)
  
 
function new(input string inst = "agent", uvm_component parent = null);
super.new(inst,parent);
endfunction
 
 driver d;
 uvm_sequencer#(transaction) seqr;
 monitor mon_h;
 
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
   d = driver::type_id::create("d",this);
   seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this); 
  mon_h = monitor::type_id::create("mon_h",this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
   d.seq_item_port.connect(seqr.seq_item_export);
endfunction
 
endclass
