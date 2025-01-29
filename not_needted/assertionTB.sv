`include "uvm_macros.svh"
import uvm_pkg::*;
`include "global_pkg.sv"
`include "assertion.sv"
module tb;

  bit clk;
  bit rst;
  logic[7:0] opa;
  logic[7:0]opb;
  logic[1:0] inp_valid;
  logic[8:0] res;
  logic mode;
  logic[3:0]cmd;
  logic cin;
  logic oflow;
  logic cout;
  logic g;
  logic l;
  logic e;
  logic err;
  logic ce;

  always #5 clk = ~clk;

//  assertions intf(.clk(clk),
//                  .rst(rst));

  assertions assertion(.clk(clk),
                       .rst(rst),
                       .opa(opa),
                       .opb(opb),
                       .inp_valid(inp_valid),
                       .res(res),
                       .mode(mode),
                       .cmd(cmd),
                       .cin(cin),
                       .oflow(oflow),
                       .cout(cout),
                       .g(g),
                       .l(l),
                       .e(e),
                       .err(err),
                       .ce(ce)
                       );



  initial begin
    #1000;
    $finish;
  end

  initial begin
    assertion_task();
  end

    task assertion_task();
      `uvm_info("",$sformatf("assertion_Task started"),UVM_NONE);

      @(posedge clk);
      opa <= 3;
      opb <= 4;
      inp_valid <= 2'b11;
      cmd <= 4'b0000;
      @(posedge clk);
      res <= 7;
      @(posedge clk);
      opa <= 0;
      opb <= 0;
      inp_valid <= 2'b00;
      cmd <= 4'b0000;
      res <= 0;
      `uvm_info("",$sformatf("assertion_Task ended"),UVM_NONE);
    endtask

endmodule : tb
