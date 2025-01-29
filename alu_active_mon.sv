class alu_active_monitor extends uvm_monitor;
  `uvm_component_utils(alu_active_monitor)
 
  function new(string name = "alu_active_monitor", uvm_component parent=null);
    super.new(name,parent);
  endfunction
 
  virtual intf vif;
  alu_sequence_item txn;
  uvm_analysis_port#(alu_sequence_item) a_mon;
  uvm_analysis_port#(alu_sequence_item) a_cov;

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a_mon = new("a_mon",this);
    a_cov = new("a_cov",this);
    if(!(uvm_config_db#(virtual intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("Monitor","Unable to get the interface")
    end
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    txn = alu_sequence_item::type_id::create("txn");
    forever begin
      @(posedge(vif.clk));
      txn.ce=vif.ce;
      txn.opa = vif.opa;
      txn.opb = vif.opb;
      txn.cmd = vif.cmd;
      txn.mode = vif.mode;
      txn.cin = vif.cin;
      txn.inp_valid = vif.inp_valid;
      a_mon.write(txn);
      a_cov.write(txn);

    end
    `uvm_info(get_type_name(),$sformatf("opa=%0d,opb=%0d,cmd=%0d,mode=%0d,cin=%0d,inp_valid=%0d",vif.opa,vif.opb,vif.cmd,vif.mode,vif.cin,vif.inp_valid),UVM_NONE)
    
  endtask
 
endclass
