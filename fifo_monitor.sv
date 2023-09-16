`include "fifo_define.sv"

class fifo_monitor extends uvm_monitor;
  
  virtual fifo_if vif;

  fifo_transaction trans;
  
  uvm_analysis_port#(fifo_transaction) ap;
  
  `uvm_component_utils(fifo_monitor)
  

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    ap=new("ap", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   // trans=fifo_transaction::type_id::create("trans");
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
       `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
       end
   endfunction

   virtual task run_phase(uvm_phase phase);
    forever begin
      @( posedge vif.mon.mon_cb)
//monitor write
      if( vif.mon.mon_cb.i_wren == 1  &&  vif.mon.mon_cb.i_rden == 0)begin
        trans=fifo_transaction::type_id::create("trans");
        $display("\n write enable  is high");
        trans.i_wrdata =  vif.mon.mon_cb.i_wrdata;
        trans.i_wren = 1'b1;
        trans.i_rden = 1'b0;
        trans.o_alm_full =  vif.mon.mon_cb.o_alm_full;
        trans.o_full = vif.mon.mon_cb.o_full;
        ap.write(trans);
      end
       
    //monitor read  
    if( vif.mon.mon_cb.i_wren == 0 &&  vif.mon.mon_cb.i_rden == 1)begin
        @(posedge  vif.mon.mon_cb)
        trans=fifo_transaction::type_id::create("trans");
        $display("\nRead enable  is high");
        trans.o_rddata =  vif.mon.mon_cb.o_rddata;
        trans.i_wren = 1'b0;
        trans.i_rden= 1'b1;
        trans.o_alm_empty = vif.mon.mon_cb.o_alm_empty;
        trans.o_empty =  vif.mon.mon_cb.o_empty;
        ap.write(trans);
      end
      
     //monitor write read 
 if( vif.mon.mon_cb.i_wren == 1 &&  vif.mon.mon_cb.i_rden == 1)begin
        @(posedge  vif.mon.mon_cb)
          trans=fifo_transaction::type_id::create("trans");
          $display("\n write and read");
          trans.i_wrdata =  vif.mon.mon_cb.i_wrdata;                                                  
          trans.i_wren = 1'b1;                                                                        
          trans.i_rden = 1'b1; 
          trans.o_rddata =  vif.mon.mon_cb.o_rddata;
          trans.o_alm_full =  vif.mon.mon_cb.o_alm_full;                                              
          trans.o_full = vif.mon.mon_cb.o_full;     
          trans.o_alm_empty = vif.mon.mon_cb.o_alm_empty;
          trans.o_empty =  vif.mon.mon_cb.o_empty;
          ap.write(trans);

       end
end
endtask
endclass
