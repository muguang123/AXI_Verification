class master_agt_cfg extends uvm_object;
	
	`uvm_object_utils(master_agt_cfg)

	uvm_active_passive_enum is_active = UVM_ACTIVE;

		int no_of_mtr_agts = 1;

	virtual axi_if vif;




extern function new(string name = "master_agt_cfg");
		
endclass

	function master_agt_cfg::new(string name = "master_agt_cfg");
		super.new(name);
	endfunction


