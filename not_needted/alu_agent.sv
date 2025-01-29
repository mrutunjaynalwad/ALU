class alu_agent extends uvm_agent;
 `uvm_component_utils(alu_agent)
 
  alu_sequencer seqr_h;
  alu_driver    drv_h;
  alu_monitor   mon_h;


  function new(string name="alu_agent", uvm_component parent=null);
   super.new(name,parent);
  endfunction

  
  function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   drv_h    = alu_driver::type_id::create("drv_h",this);
   seqr_h = alu_sequencer::type_id::create("seqr_h",this);
   mon_h   = alu_monitor::type_id::create("mon_h",this);
  endfunction

  function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   drv_h.seq_item_port.connect(seqr_h.seq_item_export);
  endfunction

 
endclass
 
 
