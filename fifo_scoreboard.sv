`include "fifo_define.sv"

class fifo_scoreboard extends uvm_scoreboard;
  
  uvm_analysis_imp#(fifo_transaction, fifo_scoreboard) mon_out;
  
  `uvm_component_utils(fifo_scoreboard)
  
  function new(string name = "fifo_scoreboard", uvm_component parent= null);
    super.new(name, parent);
    mon_out = new("mon_out", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  bit[`DATA_W-1:0] queue[$];
  bit[ 10:0] counter;
  
  function void write(input fifo_transaction trans);
    bit [`DATA_W-1:0] examdata;
    bit ref_full;
    bit ref_empty;
    bit ref_alm_empty;
    bit ref_alm_full;
    
    
    if(trans.i_wren == 1'b1 )begin
      queue.push_back(trans.i_wrdata);
      counter ++;
      
      if( queue.size() == `DEPTH)
        ref_full = 1'b1;
      
      if( queue.size() >= (`DEPTH - `UPP_TH-1) && queue.size() < `DEPTH)
        ref_alm_full=1'b1;
      
      if(ref_full)begin
        $display(" reference is full");
        if(ref_full == trans.o_full)
          $display(" reference and design  are matched");
      end
      
      if(ref_alm_full)begin
        $display(" reference is almost full");
        if(ref_alm_full == trans.o_alm_full)
          $display(" reference and design  are matched");
      end
     
      `uvm_info("write Data", $sformatf("wren: %0b rden: %0b wrdata: %0h full:%0b alm_full:%0b, counter = %0d",trans.i_wren, trans.i_rden,trans.i_wrdata, trans.o_full,trans.o_alm_full,counter), UVM_LOW);
       
    end 
      
    
  if  ( trans.i_rden==1'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        counter --;
        
        if( queue.size() == 0)
        ref_empty = 1'b1;
      
        if( queue.size()>0 &&  queue.size() <= `LOW_TH)
        ref_alm_empty=1'b1;
        
        if(ref_empty)begin
          $display(" reference is empty");
          if(ref_empty == trans.o_empty)
          $display(" reference and design  are matched");
      end
      
        if(ref_alm_empty)begin
          $display(" reference is almost empty ");
          if(ref_alm_empty == trans.o_alm_empty)
          $display(" reference and design  are matched");
      end
     
        `uvm_info("Read Data", $sformatf("examdata: %0h data_out: %0h empty: %0b   alm_empty: %0b, counter=%0d", examdata, trans.o_rddata, trans.o_empty, trans.o_alm_empty,counter), UVM_LOW);
        if(examdata == trans.o_rddata)begin
          $display("-------- 		Pass! 		--------");
        end
        else begin
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
      end
  end

  endfunction
  
endclass
