class axi_env_config extends uvm_object;

	`uvm_object_utils(axi_env_config)


	master_agt_cfg m_cfg[];
	slave_agt_cfg slv_cfg[];

//	virtual axi_if vif;
//	uvm_active_passive_enum is_active = UVM_ACTIVE;
//	bit has_functional_coverage = 1;
	int has_sb = 1;
	int has_v_seqr = 1;
	int no_of_mtr_agts = 1;
	int no_of_slv_agts = 1;
	int no_of_mtops =1; 
	int no_of_stops = 1;

extern function new(string name = "axi_env_config");
endclass

	function axi_env_config::new(string name = "axi_env_config");
		super.new(name);
	endfunction 
	
	 
