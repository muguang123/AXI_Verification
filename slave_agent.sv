class slave_agent extends uvm_agent;
	
	`uvm_component_utils(slave_agent)

	slave_agt_cfg slv_cfg;

	slave_driver slv_drv;
	slave_sequencer slv_sqr;
	slave_monitor slv_mon;
	
	
	extern function new(string name = "slave_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

	
	endclass

	function slave_agent::new(string name = "slave_agent", uvm_component parent);

		super.new(name, parent);
	endfunction

	function void slave_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(slave_agt_cfg)::get(this, "", "slave_agt_cfg", slv_cfg))
			`uvm_fatal("config db", "cannopt get inside agents ")
		if(slv_cfg.is_active == UVM_ACTIVE)
			begin
			slv_drv = slave_driver::type_id::create("slv_drv", this);
			slv_sqr = slave_sequencer::type_id::create("slv_sqr", this);
			end
		slv_mon = slave_monitor::type_id::create("slv_mon", this);
	endfunction 

	function void slave_agent::connect_phase(uvm_phase phase);
		if(slv_cfg.is_active == UVM_ACTIVE)
			begin
					slv_drv.seq_item_port.connect(slv_sqr.seq_item_export);
			end
	endfunction 

