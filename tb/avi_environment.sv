class axi_environment extends uvm_env;
	
	`uvm_component_utils(axi_environment)
	
	axi_env_config env_cfg;
//	slave_agt_cfg slv_cfg[];
//	master_agt_cfg m_cfg[];

	master_agt_top mtop[];
	slave_agt_top slvtop[];
		
	axi_scoreboard sb;
	axi_virtual_sequencer v_seqr;


	

extern function new(string name = "axi_environment", uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass
	function axi_environment::new(string name = "axi_environment", uvm_component parent);
		super.new(name, parent);
	endfunction 

	function void axi_environment::build_phase(uvm_phase phase);
		
		super.build_phase(phase);
		if(!uvm_config_db #(axi_env_config)::get(this, "", "axi_env_config", env_cfg))
			`uvm_fatal("CONFIG DB", "cannot get inside the environmeint from test")
		
		if(env_cfg.has_sb)
			sb = axi_scoreboard::type_id::create("sb", this);
	
		if(env_cfg.has_v_seqr)
			v_seqr = axi_virtual_sequencer::type_id::create("v_seqr", this);
		
		mtop = new[env_cfg.no_of_mtops];
		foreach(mtop[i])
			begin
				mtop[i] = master_agt_top::type_id::create($sformatf("mtop[%0d]",i), this);
				uvm_config_db #(master_agt_cfg)::set(this, $sformatf("mtop[%0d]*",i), "master_agt_cfg", env_cfg.m_cfg[i]);
			end

		slvtop = new[env_cfg.no_of_stops];
		foreach(slvtop[i])
			begin
				slvtop[i] = slave_agt_top::type_id::create($sformatf("slvtop[%0d]",i), this);
				uvm_config_db #(slave_agt_cfg)::set(this, $sformatf("slvtop[%0d]*", i), "slave_agt_cfg", env_cfg.slv_cfg[i]);
			end

		

	endfunction 

	function void axi_environment::connect_phase(uvm_phase phase);
		//for(int i =0; i<env_cfg.no_of_mtops; i= i+1)
		//	begin
		//		for(int j = 0; j< env_cfg.no_of_mtr_agts; j = j+1)
		//			begin
						v_seqr.mtr_sqr[0] = mtop[0].m_agt[0].mtr_sqr;
		//			end
		//	end
//		for(int m =0; m<env_cfg.no_of_stops; m= m+1)
//			begin
//				for(int n = 0; n< env_cfg.no_of_slv_agts; n = n+1)
//					begin

						v_seqr.slv_sqr[0] = slvtop[0].slv_agt[0].slv_sqr;
//					end
//			end
	endfunction 

	

	
	

