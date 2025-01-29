class alu_env extends uvm_env;

`uvm_component_utils(alu_env)
   
  function new(string name="alu_env",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  alu_passive_agent    agent_p_h;
  alu_active_agent    agent_a_h;
  alu_cov  cov_h;
  scoreboard scoreboard_h;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent_p_h    = alu_passive_agent::type_id::create("agent_p_h",this);
    agent_a_h    = alu_active_agent::type_id::create("agent_a_h",this);
    scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
    cov_h = alu_cov::type_id::create("cov_h",this);
  endfunction
 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
        agent_a_h.mon_h.a_mon.connect(scoreboard_h.aport_a_mon.analysis_export);
        agent_p_h.mon_pass_h.p_mon.connect(scoreboard_h.aport_p_mon.analysis_export);
        agent_a_h.mon_h.a_cov.connect(cov_h.analysis_export);
  endfunction
  
endclass:alu_env
