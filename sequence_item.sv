`include "uvm_macros.svh"
import uvm_pkg::*;
 
class transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)
  
  rand bit wr;
  rand bit [3:0] addr;
  rand bit [7:0] din;
       bit [7:0] dout;
        
   function new(input string path = "transaction");
    super.new(path);
   endfunction
 
 
endclass
