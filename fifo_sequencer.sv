`include "fifo_define.sv"

class fifo_sequencer extends uvm_sequencer#(fifo_transaction);
  
  `uvm_component_utils(fifo_sequencer)
  
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
 virtual  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass
