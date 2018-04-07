class master_monitor extends uvm_monitor;
		
	`uvm_component_utils(master_monitor)
virtual axi_if vif;
master_agt_cfg m_cfg;

extern function new(string name = "master_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

	function master_monitor::new(string name = "master_monitor", uvm_component parent);

		super.new(name, parent);
	endfunction 

	function void master_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(master_agt_cfg)::get(this, "", "master_agt_cfg", m_cfg))
			`uvm_fatal("MASTER MONITOR", "cannot get inside montior of master")
	endfunction 

	function void master_monitor::connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
	endfunction 

