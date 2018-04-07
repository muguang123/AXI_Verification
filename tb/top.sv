module top;

	bit clock = 1'b1;
	//bit reset = 1'b0;
	import uvm_pkg::*;
	import axi_test_pkg::*;

	axi_if INTERFACE(clock);
	
	

	initial 
		begin
			uvm_config_db #(virtual axi_if)::set(null, "*", "vif", INTERFACE);
			run_test();
		end

	always
		#10	clock = ~clock;

endmodule 
