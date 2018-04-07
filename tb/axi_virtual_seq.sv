class axi_virtual_seq extends uvm_sequence #(uvm_sequence_item);
	
	`uvm_object_utils(axi_virtual_seq)
	
	axi_virtual_sequencer v_seqr;
	axi_env_config env_cfg;
	master_sequencer mtr_sqr[];
	slave_sequencer slv_sqr[];
	
extern function new(string name = "axi_virtual_seq");
extern task body();
endclass

	function axi_virtual_seq::new(string name = "axi_virtual_seq");
		super.new(name);
	endfunction 


	task axi_virtual_seq::body();
		if(!uvm_config_db #(axi_env_config)::get(null,get_full_name(),"axi_env_config", env_cfg))
			`uvm_fatal("sequence_v","cannot get inside virtual sequence")
		if(!$cast(v_seqr, m_sequencer))
			begin
				`uvm_error("CASTING", "cannot perform casting of sequencer and m_sequencer");
			end
		mtr_sqr = new[env_cfg.no_of_mtr_agts];
		slv_sqr = new[env_cfg.no_of_slv_agts];
	
	foreach(mtr_sqr[i])
		mtr_sqr[i] = v_seqr.mtr_sqr[i];
	foreach(slv_sqr[i])
		slv_sqr[i] = v_seqr.slv_sqr[i];
	endtask

	
class first_virtual_seq extends axi_virtual_seq;
	

	`uvm_object_utils(first_virtual_seq)

	first_master_seq mtr_seqI;
	first_slave_seq slv_seqI;
	
	extern function new(string name = "first_virtual_seq");
	extern task body();
	
endclass
	
	function first_virtual_seq::new(string name = "first_virtual_seq");
		super.new(name);
	endfunction 

	task first_virtual_seq::body();
		super.body();
			mtr_seqI = first_master_seq::type_id::create("mtr_seqI");
		slv_seqI = first_slave_seq::type_id::create("slv_seqI");
		fork 

		
			mtr_seqI.start(mtr_sqr[0]);
		
			slv_seqI.start(slv_sqr[0]);
		join 

	endtask


