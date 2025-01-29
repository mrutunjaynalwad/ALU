class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)
 
  function new(string name = "alu_monitor", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual interface intf vif;
  alu_sequence_item txn;
  uvm_analysis_port#(alu_sequence_item) ap_mon;
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_mon = new("ap_mon",this);
    if(!(uvm_config_db#(virtual intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("Monitor","Unable to get the interface")
    end
  endfunction
 
  
  virtual task run_phase(uvm_phase phase);
    txn = alu_sequence_item::type_id::create("txn");
    forever begin
      $display("rst=%0d",vif.rst);
      @(posedge vif.clk);
      if(vif.ce)begin
        if(vif.rst)begin
          txn.res= vif.res;
          txn.cout= vif.cout;
          txn.oflow= vif.oflow;
          txn.g= vif.g;
          txn.e= vif.e;
          txn.l= vif.l;
          txn.err= vif.err;
          `uvm_info(get_type_name(),$sformatf("1opa=%0d,opb=%0d,res=%0d, cout=%0d, cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",vif.opa,vif.opb,vif.res,vif.cout,vif.cmd,vif.mode,vif.cin,vif.inp_valid),UVM_NONE)

         end
        else if(vif.mode)begin
          if(vif.inp_valid==2'b01)begin
            case(vif.cmd)
              4'b0100:begin
                txn.res= vif.res;
              end
              4'b0101:begin
                txn.res=vif.res;
              end
            endcase
             `uvm_info(get_type_name(),$sformatf("2opa=%0d,opb=%0d,res=%0d, cout=%0d, cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",vif.opa,vif.opb,vif.res,vif.cout,vif.cmd,vif.mode,vif.cin,vif.inp_valid),UVM_NONE)
         end
         else if(vif.inp_valid==2'b10)begin
            case(vif.cmd)
              4'b0110:begin
                txn.res= vif.res;
              end
              4'b0111:begin
                txn.res= vif.res;
              end
            endcase
             `uvm_info(get_type_name(),$sformatf("3opa=%0d,opb=%0d,res=%0d, cout=%0d, cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",vif.opa,vif.opb,vif.res,vif.cout,vif.cmd,vif.mode,vif.cin,vif.inp_valid),UVM_NONE)
          end
        else if(vif.inp_valid==2'b11)begin
          case(vif.cmd)
        4'b0000: begin
             txn.res = vif.res;
        end
        4'b0001: begin
             txn.res = vif.res;
        end
        4'b0010: begin
             txn.res = vif.res;
        end
        4'b0011: begin
             txn.res = vif.res;
        end
        4'b0100: begin
             txn.res = vif.res;
        end
        4'b0101: begin
             txn.res = vif.res;
        end
        4'b0110: begin
             txn.res = vif.res;
        end
        4'b0111: begin
             txn.res = vif.res;
        end
        4'b1000: begin
             txn.res = vif.res;
        end
        4'b1001: begin
             txn.res = vif.res;
        end
        4'b1010: begin
             txn.res = vif.res;
        end
        default: begin
             txn.res = vif.res;
             txn.cout = vif.cout;
             txn.oflow = vif.oflow;
             txn.g = vif.g;
             txn.e = vif.e;
             txn.l = vif.l;
             txn.err = vif.err;
        end
      endcase
       `uvm_info(get_type_name(),$sformatf("4opa=%0d,opb=%0d,res=%0d, cout=%0d, cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",vif.opa,vif.opb,vif.res,vif.cout,vif.cmd,vif.mode,vif.cin,vif.inp_valid),UVM_NONE)
    end
    end
   end
     else begin
       txn.res= vif.res;
       txn.cout= vif.cout;
       txn.oflow= vif.oflow;
       txn.g= vif.g;
       txn.e= vif.e;
       txn.l= vif.l;
       txn.err=vif.err;
        `uvm_info(get_type_name(),$sformatf("5opa=%0d,opb=%0d,res=%0d, cout=%0d, cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",vif.opa,vif.opb,vif.res,vif.cout,vif.cmd,vif.mode,vif.cin,vif.inp_valid),UVM_NONE)
     end
    ap_mon.write(txn);
   end
  endtask
endclass : alu_monitor
