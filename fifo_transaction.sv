`include "fifo_define.sv"
class fifo_transaction extends uvm_sequence_item;
   //data signals
    rand logic i_wren;
    rand logic i_rden;
    rand logic [`DATA_W - 1 : 0] i_wrdata;
    logic [`DATA_W - 1 : 0] o_rddata;
    logic  o_alm_full ;
    logic o_full ;
    logic o_alm_empty ;
    logic o_empty;

  //constructor 
  function new(string name = "fifo_transaction");
        super.new(name);
    endfunction

  `uvm_object_utils_begin(fifo_transaction)
        `uvm_field_int(i_wren, UVM_ALL_ON)
        `uvm_field_int(i_rden, UVM_ALL_ON)
        `uvm_field_int(i_wrdata, UVM_ALL_ON)
        `uvm_field_int(o_rddata, UVM_ALL_ON)
        `uvm_field_int(o_alm_full, UVM_ALL_ON)
        `uvm_field_int(o_full, UVM_ALL_ON)
        `uvm_field_int(o_alm_empty, UVM_ALL_ON)
        `uvm_field_int(o_empty, UVM_ALL_ON)
    `uvm_object_utils_end

   function string convert2string();
      return
      $psprintf("data_in=%0h,data_out=%0h,i_wren=%0d,i_rden=%0d,o_full=%0d,o_empty=%0d,o_alm_full=%0d,o_alm_empty=%0d",i_wrdata,o_rddata,i_wren,i_rden,o_full,o_empty,o_alm_full,o_alm_empty,);
  endfunction

endclass

