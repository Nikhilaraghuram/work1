`include "fifo_sequencer.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"

class fifo_agent extends uvm_agent;
  fifo_sequencer sqcr;
  fifo_driver dri;
  fifo_monitor mon;

  virtual fifo_if vif; 
  
  `uvm_component_utils(fifo_agent)
  
  function new(string name = "fifo_agent", uvm_component parent= null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) 
      begin
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
      end
    
    if(get_is_active() == UVM_ACTIVE) begin
      sqcr = fifo_sequencer::type_id::create("sqcr", this);
      dri = fifo_driver::type_id::create("dri", this);
    end
    mon = fifo_monitor::type_id::create("mon", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE)
      dri.seq_item_port.connect(sqcr.seq_item_export);
  endfunction
  
endclass
