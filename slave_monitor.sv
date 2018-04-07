class slave_monitor extends uvm_monitor;
		
	`uvm_component_utils(slave_monitor)
slave_agt_cfg slv_cfg;
virtual axi_if.SLV_MON vif;



extern function new(string name = "slave_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

	function slave_monitor::new(string name = "slave_monitor", uvm_component parent);

		super.new(name, parent);
	endfunction 


	function void slave_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(slave_agt_cfg)::get(this, "", "slave_agt_cfg", slv_cfg))
			`uvm_fatal("MASTER MONITOR", "cannot get inside montior of slave")
	endfunction 

	function void slave_monitor::connect_phase(uvm_phase phase);
		vif = slv_cfg.vif;
	endfunction 

