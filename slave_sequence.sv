class slave_sequence extends uvm_sequence #(slave_xtn);
	
	`uvm_object_utils(slave_sequence)

extern function new(string name = "slave_sequence");
endclass

	function slave_sequence::new(string name = "slave_sequence");
	
		super.new(name);
	endfunction 
	
	
class first_slave_seq extends slave_sequence;
		
	`uvm_object_utils(first_slave_seq)
	
extern function new(string name = "first_slave_seq");
extern task body();

endclass

	function first_slave_seq::new(string name = "first_slave_seq");
	
		super.new(name);
	endfunction 

	task first_slave_seq::body();
		
	repeat(3)
		begin
			req = slave_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize());
			finish_item(req);
		end
	endtask 
