class add_op_sequence extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(add_op_sequence)            

   alu_sequence_item txn;

  function new(string name="add_op_sequence");  
    super.new(name);
  endfunction

 

  virtual task body();
  `uvm_info(get_full_name(), "start of add_seq run phase",UVM_NONE)
    txn=alu_sequence_item::type_id::create("txn");
     
    repeat(10) begin
     start_item(txn);
      if(txn.cin==0) begin
       void'(txn.randomize()with{txn.cmd==0;txn.mode==1;txn.ce==1;txn.inp_valid==3;});
       
      end
      else begin 
       void'(txn.randomize()with{txn.cmd==2;txn.mode==1;txn.ce==1;txn.inp_valid==3;});
       
      end
    #5;
    finish_item(txn);
     
  end
  
  endtask:body

endclass

//--------------------------------------------------------------------

class sub_op_sequence extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(sub_op_sequence)            

  
  alu_sequence_item txn;

  function new(string name="sub_op_sequence");  
    super.new(name);
  endfunction

 

  virtual task body();
  `uvm_info(get_full_name(), "start of sub_seq run phase",UVM_NONE)
    txn=alu_sequence_item::type_id::create("txn");
    repeat(10) begin 
   
    start_item(txn);
    if(txn.cin==0) begin
      void'(txn.randomize()with{txn.cmd==1;txn.mode==1;txn.ce==1;txn.inp_valid==3;});
      
     end
     else begin 
      void'(txn.randomize()with{txn.cmd==3;txn.mode==1;txn.ce==1;txn.inp_valid==3;});
      
     end
    #5;
    finish_item(txn);
   
 end
  
  endtask:body

endclass

//-----------------------------------------------------------------------

class inc_dec_op_sequence extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(inc_dec_op_sequence)            

   alu_sequence_item txn;

  function new(string name="mult_op_sequence");  
    super.new(name);
  endfunction

 

  virtual task body();
  `uvm_info(get_full_name(), "start of inc_dec_seq run phase",UVM_NONE)
    txn=alu_sequence_item::type_id::create("txn");
  
   repeat(10) begin 
    
    start_item(txn);
    void'(txn.randomize()with{txn.cmd inside {[4:7]};txn.mode==1;txn.ce==1;});
  
    #5;
    finish_item(txn);
  
  end
   
  endtask:body

endclass

//------------------------------------------------------------------------------

class com_op_sequence extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(com_op_sequence)            

 
  alu_sequence_item txn;

  function new(string name="com_op_sequence");  
    super.new(name);
  endfunction

 

  virtual task body();
  `uvm_info(get_full_name(), "start of com_seq run phase",UVM_NONE)
    txn=alu_sequence_item::type_id::create("txn");
    repeat(10) begin
    start_item(txn);
    void'(txn.randomize()with{txn.cmd==8;txn.mode==1;txn.ce==1;txn.inp_valid==3;});
    #5;
    finish_item(txn);
  end
  endtask:body

endclass

//-------------------------------------------------------------------------------

class mult_op_sequence extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(mult_op_sequence)            

 
  alu_sequence_item txn;

  function new(string name="mult_op_sequence");  
    super.new(name);
  endfunction

 

  virtual task body();
  `uvm_info(get_full_name(), "start of mult_seq run phase",UVM_NONE)
    txn=alu_sequence_item::type_id::create("txn");
    repeat(10) begin
    start_item(txn);
    void'(txn.randomize()with{txn.cmd inside {[9:10]};txn.mode==1;txn.ce==1;});
    #5;
    finish_item(txn);
  end
  endtask:body

endclass

//---------------------------------------------------------------------

class log_op_sequence extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(log_op_sequence)            

 
  alu_sequence_item txn;

  function new(string name="log_op_sequence");  
    super.new(name);
  endfunction

 virtual task body();
  `uvm_info(get_full_name(), "start of log_seq run phase",UVM_NONE)
    txn=alu_sequence_item::type_id::create("txn");
    logical_op(txn);
  endtask:body

  // m==1 and logical operation 
  task logical_op(alu_sequence_item txn);
      for(int i=0;i<15;i++) begin
        
        start_item(txn);
        void'(txn.randomize()with{txn.cmd==i;txn.mode==0;txn.cin==0;txn.ce==1;txn.inp_valid==3;});
        #20;
        finish_item(txn);
      end
  endtask
endclass

//----------------------------------------------------------------------------

class wait_for_operands extends uvm_sequence#(alu_sequence_item);
  `uvm_object_utils(wait_for_operands)

  alu_sequence_item txn;

  // constructor
  function new(string name="wait_for_operands");
    super.new(name);
  endfunction: new

  virtual task body();
  `uvm_info(get_name(),"inside body method of wait_for_operands seq",UVM_NONE)
  txn=alu_sequence_item::type_id::create("txn");

  txn.opb.rand_mode(0);
  start_item(txn);
  void'(txn.randomize() with {txn.mode==1;txn.ce==1;txn.inp_valid==3;txn.cmd==0;});
  finish_item(txn);

endtask

endclass

