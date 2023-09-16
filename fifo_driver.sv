`include "fifo_define.sv"

class fifo_driver extends uvm_driver#(fifo_transaction);
  
  `uvm_component_utils(fifo_driver)
  
   virtual fifo_if vif;

   fifo_transaction trans;
  
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) 
      begin
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
      end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
     
    forever begin
       @(vif.drv.drv_cb)
        if(!vif.drv.drv_cb.rstn) begin
        vif.drv.drv_cb.i_wren<=0;
        vif.drv.drv_cb.i_rden<=0;
       vif.drv.drv_cb.i_wrdata<=0;
      end
      
      seq_item_port.get_next_item(trans);
    
       if(trans.i_wren == 1 && trans.i_rden==0)
             fifo_write(trans.i_wrdata);
       if(trans.i_wren==0  && trans.i_rden==1)
             fifo_read();
       if(trans.i_wren==1  && trans.i_rden==1)
         fifo_write_read(trans.i_wrdata);
      seq_item_port.item_done();
    end 
  endtask

  // driver write
  virtual task fifo_write(input [`DATA_W-1:0] din);
    @(posedge vif.drv.drv_cb)
          vif.drv.drv_cb.i_wren<=1;
          vif.drv.drv_cb.i_rden<=0;
          vif.drv.drv_cb.i_wrdata<=din;
    @(posedge vif.drv.drv_cb)
         vif.drv.drv_cb.i_wren<=0;
         vif.drv.drv_cb.i_rden<=0;
  endtask

  //driver read
 virtual task fifo_read();
   @(posedge vif.drv.drv_cb)
    vif.drv.drv_cb.i_wren <=0;
    vif.drv.drv_cb.i_rden <=1;
   @(posedge vif.drv.drv_cb)
     vif.drv.drv_cb.i_wren <=0;
     vif.drv.drv_cb.i_rden<=0;
  endtask

  //driver  write read
   virtual task fifo_write_read( input [`DATA_W-1:0] din);
     @(posedge vif.drv.drv_cb)
        vif.drv.drv_cb.i_wren<=1'b1;
        vif.drv.drv_cb.i_rden<=1'b1;
        vif.drv.drv_cb.i_wrdata<=din;    
     @(posedge vif.drv.drv_cb)
        vif.drv.drv_cb.i_wren<=0;
        vif.drv.drv_cb.i_rden<=0;
  endtask 

  
endclass: fifo_driver
