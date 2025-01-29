import globals::*;

interface intf (input logic clk,rst);
    
  logic mode;
  logic [CW:0] cmd;
  logic ce;
  logic [DW:0] opa;
  logic [DW:0] opb;
  logic cin;
  logic [DW:0] res;
  logic oflow;
  logic cout;
  logic g;
  logic l;
  logic e;
  logic err;
  logic [1:0] inp_valid;

endinterface
