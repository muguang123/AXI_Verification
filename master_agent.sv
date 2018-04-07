class master_agent extends uvm_agent;
	
	`uvm_component_utils(master_agent)

	master_agt_cfg m_cfg;
	master_driver m_drv;
	master_sequencer mtr_sqr;
	master_monitor m_mon;
	
	
	extern function new(string name = "master_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
	endclass

	function master_agent::new(string name = "master_agent", uvm_component parent);

		super.new(name, parent);
	endfunction

	function void master_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(master_agt_cfg)::get(this, "", "master_agt_cfg", m_cfg))
			`uvm_fatal("config db", "cannopt get inside agents ")
		if(m_cfg.is_active == UVM_ACTIVE)
			begin
			m_drv = master_driver::type_id::create("m_drv", this);
			mtr_sqr = master_sequencer::type_id::create("mtr_sqr", this);
			end	
		m_mon = master_monitor::type_id::create("m_mon", this);
	endfunction 

	function void master_agent::connect_phase(uvm_phase phase);
		if(m_cfg.is_active == UVM_ACTIVE)
			begin
				m_drv.seq_item_port.connect(mtr_sqr.seq_item_export);
			end
	endfunction 
		
