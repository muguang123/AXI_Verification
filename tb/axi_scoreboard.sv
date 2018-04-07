class axi_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(axi_scoreboard)

extern function new(string name = "axi_scoreboard", uvm_component parent);
endclass

	function axi_scoreboard::new(string name = "axi_scoreboard", uvm_component parent);
		super.new(name ,parent);
	endfunction 

