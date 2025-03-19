class temp_reg extends uvm_reg;
  `uvm_object_utils(temp_reg)
  function new(string name = "temp_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction
  
  rand uvm_reg_field temp;
  
  function void build();
    temp = uvm_reg_field::type_id::create("temp");
    temp.configure(this,8,0,"RW",0,0,1,1,1);
  endfunction
endclass

//-------------------top reg---------------

class top_reg extends uvm_reg_block;
  `uvm_object_utils(top_reg)
  function new(string name = "top_reg");
    super.new(name,UVM_NO_COVERAGE);
  endfunction
  
  temp_reg temp_reg_h;
  
  function void build();
   //----- building tem_reg
    temp_reg_h = temp_reg::type_id::create("temp_reg_h");
    temp_reg_h.build();
    temp_reg_h.configure(this);
    
    //---------creating memory map
    
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN); 
    // name, base, nBytes
    
    //adding memory to the registers
    default_map.add_reg(temp_reg_h, 0, "RW");// reg, offset, access
    
   // default_map.set_auto_predict(1); //setting implicit predictor
    
    lock_model();
    
  endfunction
endclass

//-----------------reg sequence ------------------
class reg_seq extends uvm_sequence;
  `uvm_object_utils(reg_seq)
  function new(string name = "reg_seq");
    super.new(name);
  endfunction
  
  top_reg top_reg_h;
  
  task body();
    uvm_status_e status;
    bit [7:0] array1;
    bit [7:0] array2;
    bit [7:0] dout_t;
    
    for(int i = 1; i < 11; i++) begin
     //------------write--------------
     
      top_reg_h.temp_reg_h.write(status, i**2); //write into the register
      array1 = top_reg_h.temp_reg_h.get();     //get the desired value
      array2 = top_reg_h.temp_reg_h.get_mirrored_value();
      `uvm_info("SEQ", $sformatf("Write Tx to DUT -> Des : %0d and Mir : %0d ", array1, array2), UVM_NONE);
      
      //---------------read --------------
      top_reg_h.temp_reg_h.read(status,dout_t);
      array1 = top_reg_h.temp_reg_h.get();
      array2 = top_reg_h.temp_reg_h.get_mirrored_value();
      `uvm_info("SEQ", $sformatf("Read Tx from DUT -> Des : %0d and Mir : %0d Data read : %0d", array1, array2, dout_t), UVM_NONE);
      
      $display("-----------------------------------------------------------");
      
    end
  endtask
endclass


      
      
