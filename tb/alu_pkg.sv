`include "uvm_macros.svh"
  
 
package tb_pkg;
  
 
  import globals::*;
  import uvm_pkg::*;

`include "seq_item.sv" 
//`include "alu_interface.sv"
`include "sequence.sv"             
`include "alu_sequencer.sv"            
`include "driver.sv"             
`include "alu_passive_mon.sv"
`include "alu_passive_agent.sv"
`include "alu_active_mon.sv"
`include "alu_active_agent.sv"

//`include "alu_agent.sv"  
//`include "scoreboard.sv"
`include "sb.sv"
`include "coverage.sv"
`include "alu_env.sv"                  
`include "test.sv"
`include "alu_add_test.sv"
`include "alu_sub_test.sv"
`include "alu_inc_dec_test.sv"
`include "alu_comp_test.sv"
`include "alu_mult_test.sv"
`include "alu_logical_test.sv"
`include "alu_wait_input_test.sv"

//`include "top.sv" 
 
endpackage 
