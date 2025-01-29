class alu_driver extends uvm_driver #(alu_sequence_item);
  `uvm_component_utils(alu_driver)
  int time_out;


  function new(string name="alu_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
 
  virtual interface intf vif;
  alu_sequence_item txn;

 //uvm_analysis_port #(alu_sequence_item) drv2sb;
  

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  //drv2sb = new("drv2sb",this);

    txn=alu_sequence_item::type_id::create("txn");
    if(!(uvm_config_db#(virtual intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("driver","unable to get interface")
    end
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "start of drv run phase",UVM_NONE)
    forever begin
      seq_item_port.get_next_item(txn);
      if(txn.ce) begin
        // $display("1ce=%0d",txn.ce);
        // $display("1rst=%0d",vif.rst);
        if(vif.rst) begin
        
            checks_rst();
        end
        else begin
          
            drive2dut();
          end
      end
     
     // drv2sb.write(txn);
      seq_item_port.item_done();   

    end
  endtask

  task checks_rst();
    vif.ce        <= 0;
    vif.opa       <= 0;
    vif.opb       <= 0;
    vif.cmd       <= 0;
    vif.mode      <= 0;
    vif.cin       <= 0;
    vif.inp_valid <= 0;
  endtask
 
  task drive2dut();
    //$display("2ce=%0d",txn.ce);
      
       @(posedge vif.clk)
       
       vif.ce        <= txn.ce;
        vif.opa       <= txn.opa;
        vif.opb <= txn.opb;

      /* if(txn.opa) begin
          vif.opa       <= txn.opa;
          repeat(16) begin
            @(posedge vif.clk)
            if(txn.opb) begin
              vif.opb <= txn.opb;
              time_out=1;
              break;
             end
           end
           if(time_out)
             `uvm_info(get_type_name,"OPB is driving",UVM_NONE)
             else begin
               `uvm_error(get_type_name,"OPB is not availabel befor 16 clk cycle")
               $finish;
          end
        end*/
          
       vif.cmd       <= txn.cmd;
       vif.mode      <= txn.mode;
       vif.cin       <= txn.cin;
       vif.inp_valid <= txn.inp_valid;
     
     `uvm_info(get_type_name(),$sformatf("opa=%0d,opb=%0d,cmd=%0d,mode=%0d,cin=%0d,inp_valid=%0d",txn.opa,txn.opb,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
  endtask
 
endclass
