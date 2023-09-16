`include "fifo_agent.sv"
`include "fifo_scoreboard.sv"

class fifo_env extends uvm_env;
  fifo_agent agnt;
  fifo_scoreboard scb;
  
  `uvm_component_utils(fifo_env)

  virtual fifo_if vif;
  
  function new(string name = "fifo_env", uvm_component parent= null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt = fifo_agent::type_id::create("agnt", this);
    scb = fifo_scoreboard::type_id::create("scb", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    agnt.mon.ap.connect(scb.mon_out);
  endfunction
  
endclass
