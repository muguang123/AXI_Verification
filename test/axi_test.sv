class axi_test extends uvm_test;

	`uvm_component_utils(axi_test)

	axi_env_config env_cfg;
	 
	axi_environment env; 
	
	//axi_env_config env_cfg;
	
	master_agt_cfg m_cfg[];
	slave_agt_cfg slv_cfg[];


	int no_of_mtr_agts = 1;
	int no_of_slv_agts = 1;
	int no_of_mtops = 1;
	int no_of_stops = 1;
	int has_sb =1;
	int has_v_seqr = 1;
	
	


extern function void build_phase(uvm_phase phase);
extern function new(string name = "axi_test", uvm_component parent);
extern function void end_of_elaboration_phase(uvm_phase phase);


endclass 

	function axi_test::new(string name = "axi_test", uvm_component parent);
		super.new(name, parent);
	endfunction 

	function void axi_test::build_phase(uvm_phase phase);

		env_cfg = axi_env_config::type_id::create("env_config");

		env_cfg.no_of_mtr_agts = no_of_mtr_agts;
		env_cfg.no_of_slv_agts = no_of_slv_agts;
		env_cfg.has_sb = has_sb;
		env_cfg.has_v_seqr = has_v_seqr;
		env_cfg.no_of_mtops = no_of_mtops;
		env_cfg.no_of_stops = no_of_stops;


		m_cfg = new[no_of_mtr_agts];
		env_cfg.m_cfg = new[no_of_mtr_agts];
		foreach(m_cfg[i])
		begin
			m_cfg[i] = master_agt_cfg::type_id::create($sformatf("m_cfg[%0d]",i));
		
			if(!uvm_config_db #(virtual axi_if)::get(this, "", "vif", m_cfg[i].vif))
				`uvm_fatal("VIF CONFIG", "cannot get virtual interface in test itself")
			m_cfg[i].is_active = UVM_ACTIVE;
	
		
			env_cfg.m_cfg[i] = m_cfg[i];
		end

		
		
		
		slv_cfg = new[no_of_slv_agts];
		env_cfg.slv_cfg = new[no_of_slv_agts];
		foreach(slv_cfg[i])
		begin

			slv_cfg[i] = slave_agt_cfg::type_id::create($sformatf("slv_cfg[%0d]",i));
				
			if(!uvm_config_db #(virtual axi_if)::get(this, "", "vif", slv_cfg[i].vif))
				`uvm_fatal("VIF CONFIG", "cannot get virtual interface in test itself")
			slv_cfg[i].is_active = UVM_ACTIVE;
	
			env_cfg.slv_cfg[i] = slv_cfg[i];
		end

		uvm_config_db #(axi_env_config)::set(this, "*", "axi_env_config", env_cfg);
		env = axi_environment::type_id::create("env", this);
		
		super.build_phase(phase);
		
	endfunction 

	function void axi_test::end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction 
	

class first_extended_test extends axi_test;
	
	`uvm_component_utils(first_extended_test)
		
	first_virtual_seq vseqI;
	
extern function new(string name = "first_extended_test", uvm_component parent);
extern task run_phase(uvm_phase phase);
extern function void build_phase(uvm_phase phase);
	
endclass
	
	function first_extended_test::new(string name = "first_extended_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void first_extended_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction 

	task first_extended_test::run_phase(uvm_phase phase);
		
		vseqI = first_virtual_seq::type_id::create("vseqI");
	
		phase.raise_objection(this);
		vseqI.start(env.v_seqr);
	//	vseqI.start(null);
		#4000;
		phase.drop_objection(this);
	endtask 

	



