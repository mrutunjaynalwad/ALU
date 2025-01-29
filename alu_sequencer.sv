class alu_sequencer extends uvm_sequencer#(alu_sequence_item);
  `uvm_component_utils(alu_sequencer)  
  function new(string name="alu_sequencer",uvm_component parent);  
    super.new(name,parent);
  endfunction
   
   virtual task body();
  `uvm_info(get_full_name(), "start of sequencer ",UVM_NONE)
    
  endtask:body

endclass
