class master_sequence extends uvm_sequence #(master_xtn);
	
	`uvm_object_utils(master_sequence)

extern function new(string name = "master_sequence");
endclass

	function master_sequence::new(string name = "master_sequence");
	
		super.new(name);
	 endfunction 
	
	
class first_master_seq extends master_sequence;
		
	`uvm_object_utils(first_master_seq)
	
extern function new(string name = "first_master_seq");
extern task body();

endclass

	function first_master_seq::new(string name = "first_master_seq");
	
		super.new(name);
	endfunction 

	task first_master_seq::body();
		
	repeat(3)
		begin

			req = master_xtn::type_id::create("req");
			start_item(req);


			assert(req.randomize() with { awburst==2'd1;});
			finish_item(req);
		end
	endtask 


