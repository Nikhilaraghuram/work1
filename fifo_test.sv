`include "fifo_sequence.sv"
`include "fifo_env.sv"

class fifo_test extends uvm_test;
  fifo_sequence seq;
  fifo_env env;
  
  `uvm_component_utils(fifo_test)
  
  function new(string name = "fifo_test", uvm_component parent= null);
    super.new(name, parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = fifo_sequence::type_id::create("seq", this);
    env = fifo_env::type_id::create("env", this);
  endfunction
  
   task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agnt.sqcr);
    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this, 100);
  endtask
  
endclass