class alu_cov extends uvm_subscriber#(alu_sequence_item);
`uvm_component_utils(alu_cov)
 
 alu_sequence_item txn;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
txn= alu_sequence_item::type_id::create("txn");
endfunction
 
covergroup crgp();
 
inp_val: coverpoint txn.inp_valid{bins b1={[0:3]};}
mode: coverpoint txn.mode{bins b2={0,1};}
cmd: coverpoint txn.cmd{bins b3[]={[0:13]};}
ce: coverpoint txn.ce{bins b4[]={0,1};}
opa: coverpoint txn.opa{bins b5={[0:49]};
                        bins b6={[50:100]};
                        bins b7={[101:149]};
                        bins b8={[150:200]};
                        bins b9={[200:255]};}
opb: coverpoint txn.opb{bins b10={[0:49]};
                        bins b11={[50:100]};
                        bins b12={[101:149]};
                        bins b13={[150:200]};
                        bins b14={[200:255]};}

cin: coverpoint txn.cin{bins b15={0,1};}
mode_x_cmd:cross mode,cmd;
 
endgroup
 
function new(string name="alu_cov",uvm_component parent=null);
super.new(name,parent);
crgp=new;
endfunction
 
function void write(alu_sequence_item t);
  txn=t;
   crgp.sample();
endfunction

 
endclass
