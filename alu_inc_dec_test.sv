class alu_incr_dec_test extends alu_test;
  `uvm_component_utils(alu_incr_dec_test)

  function new(string name="alu_inc_dec_test",uvm_component parent);
	    super.new(name,parent);
    endfunction

    function void end_of_elobartion_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
      // uvm_test_done.set_drain_time(this,300ns);
     endfunction
    
     task run_phase(uvm_phase phase);
      `uvm_info(get_full_name(), "start of run phase",UVM_NONE)
	      phase.raise_objection(this);
      begin
          inc_dec_op_seq_h.start(env_h.agent_a_h.seqr_h);
      end 
        #50;
	      phase.drop_objection(this);
        `uvm_info(get_full_name(), "end of run phase",UVM_NONE)
    endtask

 
endclass
