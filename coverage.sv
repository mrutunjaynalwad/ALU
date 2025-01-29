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
cmd: coverpoint txn.cmd{bins b3={[0:13]};}
ce: coverpoint txn.ce{bins b4[]={0,1};}
opa: coverpoint txn.opa{bins min={0};
                        bins even={[1:254]} with (item%2==0);
                        bins odd={[1:254]} with (item%2==1);
                        bins max={255};}
opb: coverpoint txn.opb{bins min={0};
                        bins even={[1:254]} with (item%2==0);
                        bins odd={[1:254]} with (item%2==1);
                        bins max={255};}

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

virtual function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info(get_name(),$sformatf("Coverage=%0.2f %%",crgp.get_inst_coverage()),UVM_NONE)
endfunction
 
endclass
