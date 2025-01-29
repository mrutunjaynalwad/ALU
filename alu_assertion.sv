
import globals::*;

interface assertions(input logic clk,rst,
                    input logic[DW:0] opa,
                    input logic[DW:0]opb,
                    input logic[1:0] inp_valid,
                    input logic[DW:0] res,
                    input logic mode,
                    input logic[CW:0]cmd,
                    input logic cin,
                    input logic oflow,
                    input logic cout,
                    input logic g,
                    input logic l,
                    input logic e,
                    input logic err,
                    input logic ce
                    );

  import uvm_pkg::*;
  `include "uvm_macros.svh";

  initial begin
    `uvm_info("ALU_Assertions",$sformatf("time=%0t ALU Assertions run started",$time),UVM_NONE)
  end

  property p;
    @(posedge clk) disable iff(rst)
    (opa || opb) && (inp_valid !=2'b00) |=> !($isunknown(res));
  endproperty: p

  res_checking: assert property(p) $info("output result checking assertion success");
                      else $error("output result checking assertion failure");

  property p1;
    @(posedge clk) disable iff(rst)
    (opa==opb) && (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b1000) |=> e;
  endproperty: p1

  equal_op: assert property(p1) $info("equal operation checking assertion success");
                      else $error("equal operation checking assertion failure");

  property p2;
    @(posedge clk) disable iff(rst)
    (opa>opb) && (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b1000) |=> g;
  endproperty: p2

  greater_op: assert property(p2) $info("greater operation checking assertion success");
                      else $error("greater operation checking assertion failure");

  property p3;
    @(posedge clk) disable iff(rst)
    (opa<opb) && (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b1000) |=> l;
  endproperty: p3

  less_op: assert property(p3) $info("less operation checking assertion success");
                      else $error("less operation checking assertion failure");

  property p4;
  @(posedge clk) disable iff(rst)
    (inp_valid==2'b11) && (mode==1'b0) && (cmd==4'b1100 || cmd==4'b1101) && (opb[4] || opb[5] ||
    opb[6] || opb[7])|=> err;
  endproperty: p4

  error_condition: assert property (p4) $info("rotation operation  assertion success");
                       else $error("rotation operation assertion failure");

 property p5;
   @(posedge clk) disable iff(rst)
   (cmd==4 && cin==0 && mode==1 && ce==1 && inp_valid==2) |=> res == (opa+1);
 endproperty: p5

 increament_operation_a: assert property (p5) $info("increamenting operation of opa success");
                         else $error("increamenting operation assertion failure");

  property p6;
    @(posedge clk) disable iff(rst)
    (opa) |-> ##[1:16] (opb);
  endproperty: p6

  condition_opa_opb: assert property (p6) $info("opa and opb operands assertion success");
                      else $error("opa and opb operands assertion failure");

  property p7;
   @(posedge clk) disable iff(!rst)
   (cmd ==0 && cin==0 && mode ==1 && ce ==1 && inp_valid ==3) |=> res == (opa+opb);
  endproperty: p7

  addition_operation:assert property (p7) $info("addition operation assertion success");
                         else $error("addition operation assertion failure");

  property p8;
   @(posedge clk) disable iff(!rst)
   (cmd ==1 && cin==0 && mode ==1 && ce ==1 && inp_valid ==3) |=> res == (opa-opb);
  endproperty: p8

  sub_operation:assert property (p8) $info("subtraction operation assertion success");
                         else $error("subtraction operation assertion failure");


endinterface: assertions

