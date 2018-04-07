class master_driver extends uvm_driver #(master_xtn);
	
	`uvm_component_utils(master_driver)

	virtual axi_if.MTR_DRV vif;

		master_agt_cfg m_cfg;
		semaphore sem_addr = new(1);
		semaphore sem_data = new(1);	
		semaphore sem_resp = new(1);

		longint q[$];
		longint burst_vl;

extern function new(string name = "master_driver", uvm_component parent);
extern function void connect_phase (uvm_phase phase);
extern function void build_phase (uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(master_xtn xtnI);
extern task address_channel(master_xtn xtnI);
extern task write_data_chnl(master_xtn xtnI);
extern task resp_channel(master_xtn xtnI);
		
endclass 
		
	function master_driver::new(string name = "master_driver", uvm_component parent);
		super.new(name, parent);
	endfunction 

	function void master_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(master_agt_cfg)::get(this, "", "master_agt_cfg", m_cfg))
			`uvm_fatal ("MASTER DRIVER", "cannot get inside driver of master")
	endfunction 
	
	function void master_driver::connect_phase(uvm_phase phase);
		vif=m_cfg.vif;
	endfunction 

	task master_driver::run_phase(uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask 
		
	task master_driver::send_to_dut(master_xtn xtnI);
				xtnI.print();
		fork 
			begin
			sem_addr.get(1);
				address_channel(xtnI);
					
			sem_addr.put(1);
			sem_resp.put(1);
			end

			
			begin
			//@(vif.mtr_drv);
		 	sem_data.get(1);
						
				write_data_chnl(xtnI);	
				
			sem_data.put(1);
			sem_resp.put(1);
			end

				
			begin
			sem_resp.get(3);
				resp_channel(xtnI);
			sem_resp.put(1);
			end

		join_any

	endtask 


	task master_driver::address_channel(master_xtn xtnI);
			
				q.push_front(xtnI.burst_ln);
			//repeat(2)	@(vif.mtr_drv);
				
				$display("passed the key to first_sem inside master driver ===============at time=%d",$time);
				vif.mtr_drv.awvalid <= 1'b1;
				wait(vif.mtr_drv.awready)
				vif.mtr_drv.awid <= xtnI.awid;
				vif.mtr_drv.awaddr <= xtnI.awaddr;

				vif.mtr_drv.awlen <= xtnI.awlen;
				$display("MASTER%%$####time at which the value in the queue is pushed =%d ADDRESS CHANNEL" ,$time);

				$display("MASTER%%%####the value of the queue=====%p and the burst_ln=====%d ADDRESS CHANNEL", q, xtnI.burst_ln);

				vif.mtr_drv.awsize <= xtnI.awsize;

				vif.mtr_drv.awburst <= xtnI.awburst;
				@(vif.mtr_drv);
				
				vif.mtr_drv.awvalid <= 1'b0;
				//@(vif.mtr_drv);

				

	endtask 

	task master_driver::write_data_chnl(master_xtn xtnI);
			
				$display("passed the key to second sem inside master driver=================at time=%d",$time);
				$display("valure of the data inside the queue Q_DATA=%p", xtnI.q_data);	
					repeat(4)
					@(vif.mtr_drv);
				
						vif.mtr_drv.wvalid <= 1'b1;
						wait(vif.mtr_drv.wready)
						burst_vl = q.pop_back();
	
		
						$display("MASTER%%%####time at which the value in the queue is popped=%d and after popping the value of queue=%pDATA CHANNEL",$time, q);

				$display("value of the burst length variable in the queue -------$$$$$$$$$=%d",burst_vl );
				for(int i=1; i<=(burst_vl); i++)
					begin
						if(i == burst_vl)
							begin
								vif.mtr_drv.wlast <= 1'b1;
							end
						//vif.mtr_drv.wid <= xtnI.wid;
					
						vif.mtr_drv.wdata <= xtnI.q_data.pop_back();
						vif.mtr_drv.wstrb <= xtnI.q_strb.pop_back();
						@(vif.mtr_drv);
						

					end
						vif.mtr_drv.wlast <= 1'b0;
						vif.mtr_drv.wvalid <= 1'b0;
					//	vif.mtr_drv.wid <= 0;
						vif.mtr_drv.wdata <=0;
						vif.mtr_drv.wstrb <= 0;
					/*	repeat(2)
						@(vif.mtr_drv);*/
					

	endtask 

	task master_driver::resp_channel(master_xtn xtnI);
	/*	repeat(2)
		@(vif.mtr_drv);*/
		wait(!vif.mtr_drv.awready && !vif.mtr_drv.wready)
		repeat(2)
		@(vif.mtr_drv);
		vif.mtr_drv.bready <= 1'b1;
		wait(vif.mtr_drv.bvalid)
		xtnI.bid = vif.mtr_drv.bid;
		xtnI.bresp = vif.mtr_drv.bresp;
		//repeat(2)
		
		@(vif.mtr_drv);
		wait(vif.mtr_drv.wready)
		
		vif.mtr_drv.bready <= 1'b0;
	
	endtask



