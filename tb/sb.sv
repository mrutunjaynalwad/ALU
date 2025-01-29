class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_tlm_analysis_fifo #(alu_sequence_item)aport_a_mon;
  uvm_tlm_analysis_fifo #(alu_sequence_item)aport_p_mon;
  alu_sequence_item txn;
  virtual intf vif;

  bit [DW:0] res;
  bit [DW:0] ex_res;
  bit oflow;
  bit ex_oflow;
  bit cout;
  bit ex_cout;
  bit g;
  bit l;
  bit e;
  bit ex_g;
  bit ex_l;
  bit ex_e;
  bit err;
  bit ex_err;
  
  bit[CW-1:0] OPA,OPB;

  function new(string name="scoreboard",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    txn=alu_sequence_item::type_id::create("txn");
    aport_a_mon=new("aport_drv",this);
    aport_p_mon=new("aport_mon",this);

    if(!(uvm_config_db#(virtual intf)::get(this,"","vif",vif)))
      `uvm_fatal(get_type_name(),"Failed to get virtual intf in scoreboard")
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      aport_a_mon.get(txn);
      ref_model(txn);
      aport_p_mon.get(txn);
      actual_output(txn);
//#20;
      result_checker();
      result_for_wait();
    end
  endtask


  virtual task ref_model(alu_sequence_item txn);
      @(posedge(vif.clk))begin
      if(vif.rst)begin
        txn.opa <=0;
        txn.opb <=0;
      end
    end
      
   @(posedge(vif.clk))begin
      if(txn.ce)begin
        if(vif.rst)begin
          ex_res='b0;
          ex_cout='b0;
          ex_oflow='b0;
          ex_g='b0;
          ex_e='b0;
          ex_l='b0;
          ex_err='b0;
        end
        else if(txn.mode)begin                //Arithmetic as mode=1
         
          if(txn.inp_valid==2'b01)begin
            case(txn.cmd)
              4'b0100:begin
               // txn.opa=txn.opa+1;
                ex_res=txn.opa+1;
                `uvm_info(get_type_name(),$sformatf("1opa=%0d,opb=%0d,res=%0d,cmd=%0d,mode=%0d,cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
              end
              4'b0101:begin
                //txn.opa=txn.opa-1;
                ex_res=txn.opa-1;
                `uvm_info(get_type_name(),$sformatf("2opa=%0d,opb=%0d,res=%0d,cmd=%0d,mode=%0d,cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)

              end

            endcase
            end
          else if(txn.inp_valid==2'b10)begin
            case(txn.cmd)
              4'b0110:begin
               // txn.opb=txn.opb+1;
                ex_res=txn.opb+1;
              end
              4'b0111:begin
                //txn.opb=txn.opb-1;
                ex_res=txn.opb-1;
              end
            endcase
            `uvm_info(get_type_name(),$sformatf("3opa=%0d,opb=%0d,res=%0d,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)

          end
          else if(txn.inp_valid==2'b11)begin
            case(txn.cmd)
              4'b0000:begin
                 OPA=txn.opa;
          OPB=txn.opb; 
                ex_res=txn.opa+txn.opb;
                ex_cout=txn.res[8]?1:0;
                 `uvm_info(get_type_name(),$sformatf("4opa=%0d,opb=%0d,res=%0d, cout=%0d,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res, ex_cout,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
                             end

              4'b0001:begin
                ex_res=txn.opa-txn.opb;
                ex_oflow=(txn.opa<txn.opb)?1:0;
                `uvm_info(get_type_name(),$sformatf("5opa=%0d,opb=%0d,res=%0d,oflow=%0d,cmd=%0d,mode=%0d, cin=%0d,inp_valid=%0d",txn.opa,txn.opb,ex_res,ex_oflow,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)

              end
            
              4'b0010:begin
                ex_res=txn.opa+txn.opb+txn.cin;
                ex_cout=txn.res[8]?1:0;
                `uvm_info(get_type_name(),$sformatf("6opa=%0d,opb=%0d,res=%0d,cout=%0d,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,ex_cout,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)

              end

              4'b0011:begin
                ex_oflow=(txn.opa<txn.opb)?1:0;
                ex_res=txn.opa-txn.opb-txn.cin;
                `uvm_info(get_type_name(),$sformatf("7opa=%0d,opb=%0d,res=%0d,oflow=%0d,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,ex_oflow,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)

              end

              4'b1000:begin
                ex_res='bz;
                if(txn.opa==txn.opb)begin
                  ex_e=1;
                  ex_g='b0;
                  ex_l='b0;
                end
                else if(txn.opa>txn.opb)begin
                  ex_e='b0;
                  ex_g=1;
                  ex_l='b0;
                end
                else begin
                  ex_e='b0;
                  ex_g='b0;
                  ex_l=1;
                end
            `uvm_info(get_type_name(),$sformatf("8opa=%0d,opb=%0d,g=%0d,l=%0d,e=%0d,cmd=%0d,mode=%0d,cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_g,ex_l,ex_e,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
              end

              4'b1001:begin
                txn.opa<= txn.opb+1;
                txn.opb<= txn.opb+1;
                ex_res<=txn.opa * txn.opb;
                `uvm_info(get_type_name(),$sformatf("9opa=%0d,opb=%0d,res=%0d,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
              end

              4'b1010:begin
                txn.opa<= txn.opb <<1;
                ex_res<=txn.opa * txn.opb;
              `uvm_info(get_type_name(),$sformatf("10 opa=%0d,opb=%0d,res=%0d,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
              end

              default:begin
                 ex_res='b0;
                 ex_cout='b0;
                 ex_oflow='b0;
                 ex_g='b0;
                 ex_e='b0;
                 ex_l='b0;
                 ex_err='b0;             
               end
           endcase
          end
          

          else begin
          ex_res='b0;
          ex_cout='b0;
          ex_oflow='b0;
          ex_g='b0;
          ex_e='b0;
          ex_l='b0;
          ex_err='b0;
        end
      end
      else begin             //tx.mode=0 so logic operations
          ex_res='b0;
          ex_cout='b0;
          ex_oflow='b0;
          ex_g='b0;
          ex_e='b0;
          ex_l='b0;
          ex_err='b0;

        if(txn.inp_valid==2'b11)begin
          case(txn.cmd)
            4'b0000:ex_res={1'b0,txn.opa & txn.opb};
            4'b0001:ex_res={1'b0,~(txn.opa&txn.opb)};  // CMD_tmp = 0001: NAND
            4'b0010:ex_res={1'b0,txn.opa&&txn.opb};     // CMD_tmp = 0010: OR
 	          4'b0011:ex_res={1'b0,~(txn.opa|txn.opb)};  // CMD_tmp = 0011: NOR
            4'b0100:ex_res={1'b0,txn.opa^txn.opb};     // CMD_tmp = 0100: XOR
            4'b0101:ex_res={1'b0,~(txn.opa^txn.opb)};  // CMD_tmp = 0101: XNOR
            
            4'b1100:begin   //ROL_A_B
              if(txn.opb[0])
                ex_res= {txn.opa[6:0], txn.opa[7]};
               else
                 ex_res = txn.opa;
 
               if(txn.opb[1])
                 ex_res =  {txn.opa[5:0], txn.opa[7:6]}; 
               else
                 ex_res= txn.opa;
 
               if(txn.opb[2])
                 ex_res =  {txn.opa[3:0], txn.opa[7:4]} ;
               else
                 ex_res = txn.opa;
 
               if(txn.opb[4] | txn.opb[5] | txn.opb[6] | txn.opb[7])
                 ex_err=1'b1;
            
             end
             4'b1101:begin             // CMD_tmp = 1101: ROR_A_B 
               if(txn.opb[0])
                 ex_res = {txn.opa[0], txn.opa[7:1]};
               else
                 ex_res = txn.opa;
               if(txn.opb[1])
                 ex_res =  {txn.opa[1:0], txn.opa[7:2]}; 
               else
                 ex_res= txn.opa;
               if(txn.opb[2])
                 ex_res =  {txn.opa[3:0], txn.opa[7:4]} ;
               else
                 ex_res = txn.opb;
               if(txn.opb[4] | txn.opb[5] | txn.opb[6] | txn.opb[7])
                 ex_err=1'b1;
                 
          end
        endcase
        `uvm_info(get_type_name(),$sformatf("11 opa=%0b,opb=%0b,res=%0b,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
      end
        else if(txn.inp_valid==2'b01)begin
          case(txn.cmd)
            4'b1000:ex_res={1'b0,txn.opa>>1};      // CMD_tmp = 1000: SHR1_A 
            4'b1001:ex_res={1'b0,txn.opa<<1};      // CMD_tmp = 1001: SHL1_A
          endcase
          `uvm_info(get_type_name(),$sformatf("12 opa=%0b,opb=%0b,res=%0b,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
        end
        else if(txn.inp_valid==2'b10)begin
          case(txn.cmd)
            4'b1000:ex_res={1'b0,txn.opb>>1};      // CMD_tmp = 1000: SHR1_B 
            4'b1001:ex_res={1'b0,txn.opb<<1};      // CMD_tmp = 1001: SHL1_B
          endcase
          `uvm_info(get_type_name(),$sformatf("13 opa=%0b,opb=%0b,res=%0b,cmd=%0d,mode=%0d, cin=%0d, inp_valid=%0d",txn.opa,txn.opb,ex_res,txn.cmd,txn.mode,txn.cin,txn.inp_valid),UVM_NONE)
        end
        else begin
          ex_res='b0;
          ex_cout='b0;
          ex_oflow='b0;
          ex_g='b0;
          ex_e='b0;
          ex_l='b0;
          ex_err='b0;
        end
      end

    end                //tx.ce=1 is ending here
      else begin
        txn.opa<=0;
        txn.opb<=0;
      end
    end

  endtask

 virtual task actual_output(alu_sequence_item txn);
      begin 
    
       res=txn.res;
       oflow=txn.oflow;
       cout=txn.cout;
       g=txn.g;
       l=txn.l;
       e=txn.e;
       err=txn.err;
      end

     
    endtask



 task result_checker(); 
    
     
              
        if(res) begin  
         if(ex_res==res)
          `uvm_info(get_type_name(),$sformatf("result matched expected_res=%0d,actual_res=%0d",ex_res,res),UVM_NONE)
         else
          `uvm_error(get_type_name(),$sformatf("Fail matched expected_res=%0d,actual_res=%0d",ex_res,res))
        end

        else begin
          if(ex_g==g && g)
          `uvm_info(get_type_name(),$sformatf("result matched expected_g=%0d,actual_g=%0d",ex_g,g),UVM_NONE)
          else if (ex_l==l && l )
          `uvm_info(get_type_name(),$sformatf("result matched expected_l=%0d,actual_l=%0d",ex_l,l),UVM_NONE)
          else if(ex_e==e && e)
          `uvm_info(get_type_name(),$sformatf("result matched expected_e=%0d,actual_e=%0d",ex_e,e),UVM_NONE)
         else
          `uvm_error(get_type_name(),$sformatf("Fail matched expected_res=%0d,actual_res=%0d",ex_res,res))
        end

  endtask

  task result_for_wait();
    int count,delay_sb ;

        
     if(OPA)begin

        for(int i=1; i<17; i++) begin

           #delay_sb if(OPB) begin
            count=1;
            break;
           end

            delay_sb =delay_sb + 10;
              
          end

          if(count==1)
            `uvm_info(get_type_name(),$sformatf("OPB is come befor 16 clock cycle"),UVM_NONE)
            else
              `uvm_fatal(get_type_name(),$sformatf("wait for input operation is failed"))
      end

  endtask


  
endclass
