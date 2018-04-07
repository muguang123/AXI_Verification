class slave_agt_cfg extends uvm_object;

	`uvm_object_utils(slave_agt_cfg)

	uvm_active_passive_enum is_active = UVM_ACTIVE;
	int no_of_slv_agts = 1;

	virtual axi_if vif;


	
extern function new(string name = "slave_agt_cfg");
		
endclass

	function slave_agt_cfg::new(string name = "slave_agt_cfg");
		super.new(name);
	endfunction


