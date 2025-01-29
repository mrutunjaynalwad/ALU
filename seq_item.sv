class alu_sequence_item extends uvm_sequence_item;
 
  rand bit [DW-1:0] opa;
  rand bit [DW-1:0] opb;
  rand bit [CW-1:0] cmd;
  rand bit mode;
  rand bit cin;
  rand bit ce;
  rand bit [1:0] inp_valid;
 
  logic [DW:0] res;        //o/p
  logic oflow;
  logic cout;
  logic g;
  logic l;
  logic e;
  logic err;
 
  
  //---- factory regisitration--------
  `uvm_object_utils_begin(alu_sequence_item) 
     `uvm_field_int( opa,UVM_ALL_ON)
     `uvm_field_int( opb ,UVM_ALL_ON)
     `uvm_field_int( cmd,UVM_ALL_ON)
     `uvm_field_int( mode,UVM_ALL_ON)
     `uvm_field_int( cin,UVM_ALL_ON)
     `uvm_field_int( ce,UVM_ALL_ON)
     `uvm_field_int( inp_valid,UVM_ALL_ON)
     `uvm_field_int( res,UVM_ALL_ON)
     `uvm_field_int( oflow,UVM_ALL_ON)
     `uvm_field_int( cout,UVM_ALL_ON)
     `uvm_field_int( g,UVM_ALL_ON)
     `uvm_field_int( l,UVM_ALL_ON)
     `uvm_field_int( e,UVM_ALL_ON)
     `uvm_field_int( err,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="alu_sequence_item");
    super.new(name);
  endfunction
 
  constraint opa_var {opa dist {[0:49]:/20, [50:100]:/20, [101:149]:/20, [150:200]:/20,[201:255]:/50};}
  constraint opb_var {opb dist {[0:49]:/20, [50:100]:/20, [101:149]:/30, [150:200]:/20, [201:255]:/20};}
  
endclass
