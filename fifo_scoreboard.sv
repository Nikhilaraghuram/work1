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
  
  function void write(input fifo_transaction trans);
    bit [`DATA_W-1:0] examdata;
    
    
    if(trans.i_wren == 1'b1 && trans.i_rden==1'b0)begin
      queue.push_back(trans.i_wrdata);
       `uvm_info("write Data", $sformatf("wren: %0b rden: %0b wrdata: %0h full:%0b alm_full:%0b",trans.i_wren, trans.i_rden,trans.i_wrdata, trans.o_full,trans.o_alm_full), UVM_LOW);
    end
    
    
    
  if  (trans.i_wren == 1'b0 && trans.i_rden==1'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0h data_out: %0h empty: %0b   alm_empty: %0b", examdata, trans.o_rddata, trans.o_empty, trans.o_alm_empty), UVM_LOW);
        if(examdata == trans.o_rddata)begin
          $display("-------- 		Pass! 		--------");
        end
        else begin
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
      end
    end

    
if (trans.i_wren==1'b1 && trans.i_rden==1'b1)begin
       queue.push_back(trans.i_wrdata);
       `uvm_info("write and read", $sformatf("wren: %0b rden: %0b wrdata: %0h full: %0b  alm_full:%0b",trans.i_wren, trans.i_rden,trans.i_wrdata, trans.o_full,trans.o_alm_full), UVM_LOW);
     if(queue.size() >= 'd1)begin
         examdata = queue.pop_front();
         `uvm_info("write and read", $sformatf("examdata: %0h data_out: %0h empty: %0b   alm_empty: %0b", examdata, trans.o_rddata, trans.o_empty, trans.o_alm_empty), UVM_LOW);
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
