`include "fifo_define.sv"

class fifo_sequence extends uvm_sequence#(fifo_transaction);
   
  `uvm_object_utils(fifo_sequence)

   fifo_transaction tx;
  
  function new(string name="fifo_sequence");
     super.new(name);
   endfunction:new
   
   // Task Body. Behavior of the sequence. 
   
  virtual task body();
    
    //write sequence 
    repeat(`DEPTH) 
     begin   
       tx=fifo_transaction::type_id::create("tx");
       start_item(tx);
           assert(tx.randomize() with {(i_wren ==1 && i_rden==0);});
       finish_item(tx);
    end
     
    
    //read sequence 
    repeat(`DEPTH ) 
     begin
       tx=fifo_transaction::type_id::create("tx");
       start_item(tx);
              assert(tx.randomize() with {(i_wren ==0 && i_rden==1);});
       finish_item(tx);
     end

    //parallel write read
     repeat(`DEPTH) 
     begin
       tx=fifo_transaction::type_id::create("tx");
       start_item(tx);
        assert(tx.randomize() with {(i_wren ==1 && i_rden==1);});
       finish_item(tx);
     end
   
  endtask:body 
   
 endclass:fifo_sequence 
