class alu_test extends uvm_test;
 
   
    `uvm_component_utils(alu_test)
    alu_env env_h;
    add_op_sequence add_op_seq_h;
    sub_op_sequence sub_op_seq_h;
    inc_dec_op_sequence inc_dec_op_seq_h;
    com_op_sequence com_op_seq_h;
    mult_op_sequence mult_op_seq_h;
    log_op_sequence log_op_seq_h;
    wait_sequence wait_seq_h;

    function new(string name="alu_test",uvm_component parent);
	    super.new(name,parent);
    endfunction

 
   
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env_h = alu_env::type_id::create("env_h",this);
      add_op_seq_h = add_op_sequence :: type_id::create("add_op_seq_h",this);
      sub_op_seq_h = sub_op_sequence :: type_id::create("sub_op_seq_h",this);
      inc_dec_op_seq_h = inc_dec_op_sequence :: type_id::create("inc_dec_op_seq_h",this);
      com_op_seq_h = com_op_sequence :: type_id::create("com_op_seq_h",this);
      mult_op_seq_h = mult_op_sequence :: type_id::create("mult_op_seq_h",this);
      log_op_seq_h = log_op_sequence :: type_id::create("log_op_seq_h",this);
      wait_seq_h = wait_sequence :: type_id::create("wait_seq_h",this);
      
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
       //   add_op_seq_h.start(env_h.agent_a_h.seqr_h);
       //   sub_op_seq_h.start(env_h.agent_a_h.seqr_h);
       //  inc_dec_op_seq_h.start(env_h.agent_a_h.seqr_h);
       //   
       //  com_op_seq_h.start(env_h.agent_a_h.seqr_h);
       //  mult_op_seq_h.start(env_h.agent_a_h.seqr_h);
       //  log_op_seq_h.start(env_h.agent_a_h.seqr_h);
       end 
        #50;
	      phase.drop_objection(this);
        `uvm_info(get_full_name(), "end of run phase",UVM_NONE)
    endtask

 
endclass
