class axi_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
		
	`uvm_component_utils(axi_virtual_sequencer)
	
	master_sequencer mtr_sqr[];
	slave_sequencer slv_sqr[];
	axi_env_config env_cfg;
	
extern function new(string name = "axi_virtual_sequencer", uvm_component parent);
extern function void build_phase(uvm_phase phase);

endclass

	
	function axi_virtual_sequencer::new(string name = "axi_virtual_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction 
	
	function void axi_virtual_sequencer::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(axi_env_config)::get(this, "", "axi_env_config", env_cfg))
			`uvm_fatal("VIRTUL_SEq", "cannot get inside the virtual_sequencer")
		
		mtr_sqr = new[env_cfg.no_of_mtr_agts];
		slv_sqr = new[env_cfg.no_of_slv_agts];
	
	endfunction	
