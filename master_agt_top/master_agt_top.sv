class master_agt_top extends uvm_env;
	
	`uvm_component_utils(master_agt_top)

	master_agt_cfg m_cfg;
	
	master_agent m_agt[];

	
	extern function new(string name = "master_agt_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass 

	function master_agt_top::new(string name = "master_agt_top", uvm_component parent);
		super.new(name, parent);
	endfunction 
	
	function void master_agt_top::build_phase (uvm_phase phase);
		super.build_phase(phase);
	//	m_cfg = master_agt_cfg::type_id::create("m_cfg");
		if(!uvm_config_db #(master_agt_cfg)::get(this, "", "master_agt_cfg", m_cfg))
			`uvm_fatal("CONFIG DB", "cannot get inside agent tops")
//	`uvm_info("DISPLAY",$sformatf("value of no_of_mtr_agts", m_cfg.no_of_mtr_agts), UVM_NONE)
	m_agt = new[m_cfg.no_of_mtr_agts];
	foreach(m_agt[i])
		begin
		m_agt[i] = master_agent::type_id::create($sformatf("m_agt[%0d]", i), this);
		uvm_config_db #(master_agt_cfg)::set(this, $sformatf("m_agt[%0d]*.", i), "master_agt_cfg", m_cfg);
		end
		
	endfunction

		

