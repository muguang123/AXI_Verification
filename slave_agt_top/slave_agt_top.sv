class slave_agt_top extends uvm_env;
	
	`uvm_component_utils(slave_agt_top)

	slave_agt_cfg slv_cfg;
	slave_agent slv_agt[];

	
	extern function new(string name = "slave_agt_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass 

	function slave_agt_top::new(string name = "slave_agt_top", uvm_component parent);
		super.new(name, parent);
	endfunction 
	
	function void slave_agt_top::build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(slave_agt_cfg)::get(this, "", "slave_agt_cfg", slv_cfg))
			`uvm_fatal("CONFIG DB", "cannot get inside agent tops")
	
	slv_agt = new[slv_cfg.no_of_slv_agts];
	foreach(slv_agt[i])
		begin
		slv_agt[i] = slave_agent::type_id::create($sformatf("slv_agt[%0d]", i), this);
		uvm_config_db #(slave_agt_cfg)::set(this, $sformatf("slv_agt[%0d]*.", i), "slave_agt_cfg", slv_cfg);
		end

	endfunction

