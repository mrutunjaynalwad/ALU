
import globals::*;

interface assertions(input logic clk,
                     input logic rst,
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
    `uvm_info("ALU_Assertions",$sformatf("time=%0t ALU Assertions run started ",$time),UVM_NONE)
  end

/*  property p1;
  @(posedge clk) disable iff(rst)
    (opa || opb) && (inp_valid != 2'b00) && (cmd != 4'b1001) && (cmd != 4'b1010) |-> ##1 !($isunknown(res));
endproperty

assert property (p1) $display("time=%0t output assertion success \n",$time);
      else $display("time=%0toutput assertion failure\n", $time);
*/
property p2;
  @(posedge clk) disable iff(rst)
    (opa==opb) && (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b1000) |->##1 e;
endproperty

assert property (p2) $display("time=%0t equal operation assertion success\n",$time);
      else $display("time=%0t equal operation assertion failure\n", $time);

property p3;
  @(posedge clk) disable iff(rst)
    (opa>opb) && (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b1000) |->##1 g;
endproperty

assert property (p3) $display("time=%0t greater ope assertion success\n",$time);
      else $display("time=%0t greater ope assertion failure\n", $time); 

property p4;
  @(posedge clk) disable iff(rst)
    (opa<opb) && (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b1000) |->##1 l;
endproperty

assert property (p4) $display("time=%0t less ope assertion success\n",$time);
      else $display("time=%0t less ope assertion failure\n", $time); 

property p5;
  @(posedge clk) disable iff(rst)
    (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b0000 || cmd==4'b0010) && (res[8]==1)|-> cout;
endproperty

assert property (p5) $display("time=%0t carry out  assertion success\n",$time);
      else $display("time=%0t carry out assertion failure\n", $time);

property p6;
  @(posedge clk) disable iff(rst)
    (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b0001 || cmd==4'b0011) && (opa<opb)|-> oflow;
endproperty

assert property (p6) $display("time=%0t oflow  assertion success\n",$time);
      else $display("time=%0t oflow t assertion failure\n", $time);

property p7;
  @(posedge clk) disable iff(rst)
    (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b1001 || cmd==4'b1010) |->##2 !($isunknown(res));
endproperty

assert property (p7) $display("time=%0t multiply op  assertion success\n",$time);
      else $display("time=%0t multiply ope assertion failure\n", $time);

property p8;
  @(posedge clk) disable iff(rst)
    (inp_valid==2'b11) && (mode==1'b0) && (cmd==4'b1100 || cmd==4'b1101) && (opb[4] || opb[5] ||
    opb[6] || opb[7])|->##1 err;
endproperty

assert property (p8) $display("time=%0t rotation op  assertion success\n",$time);
      else $display("time=%0t rotation op assertion failure\n", $time);

 property p9;
  @(posedge clk) disable iff(rst)
    (inp_valid==2'b11) && (mode==1'b1) && (cmd==4'b0000) && (opa==8'h08) |-> ##[1:16] opb;
endproperty

assert property (p9) $display("time=%0t OBA is come before 16 clock cycle then assertion success\n",$time);
      else $display("time=%0t wait for input  assertion failure\n", $time);     

endinterface
