class temp_reg extends uvm_reg;
  `uvm_object_utils(temp_reg)
  
  rand uvm_reg_field temp;
  
  function void build();
    temp = uvm_reg_field::type_id::create("temp");
    temp.configure(this,8,0,"RW",0,0,1,1,1);
  endfunction
  
  //-----------covergroup-----------------
  covergroup cg;
    
   option.per_instance = 1;
    
    coverpoint temp.value[7:0]
    {
      bins low  = {[0:63]};
      bins mid  = {[64:127]};
      bins high = {[128:255]};
    }
  endgroup
  
  //----checking coverage and adding new method to covergroup----------------
  function new(string name = "temp_reg");
    super.new(name,8,UVM_CVR_FIELD_VALS);
    
    cg = new();
    
  endfunction
  
  //------------implementation of sample and sample_Values  ---------------
  virtual function void sample(uvm_reg_data_t data,
                               uvm_reg_data_t byte_en, 
                               bit is_read,
                               uvm_reg_map map); //defualt for all cover implementation
    cg.sample();
  endfunction
  
  virtual function void sample_values(); // default for all sampel values 
    super.sample_values();    
    
    cg.sample();   //both functions needed for sampling values 
  endfunction
  
  
endclass

//-------------------top reg---------------

class top_reg extends uvm_reg_block;
  `uvm_object_utils(top_reg)
  function new(string name = "top_reg");
    super.new(name,(UVM_NO_COVERAGE)); //for all registers no coverage is selected and if the coverage is needed for paticular coverage for register then it is given in the build function 
  endfunction
  
  temp_reg temp_reg_h;
  
  function void build();
    
    //including coverage
    uvm_reg::include_coverage("*", UVM_CVR_ALL);
   
   //----- building tem_reg
    temp_reg_h = temp_reg::type_id::create("temp_reg_h");
    temp_reg_h.build();
    temp_reg_h.configure(this);
    
    //Enabling coverage for specific reg instance
    temp_reg_h.set_coverage(UVM_CVR_FIELD_VALS);   
    
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


      
      
