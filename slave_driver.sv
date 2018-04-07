class slave_driver extends uvm_driver #(slave_xtn);
		
	`uvm_component_utils(slave_driver)

	virtual axi_if.SLV_DRV vif;

	slave_agt_cfg slv_cfg;

	slave_xtn clcxtn;

	semaphore sem_addr = new(1);	
	semaphore sem_data = new(1);
	semaphore sem_resp = new(1);
			int q1[$];
			int q2[$];
			longint q3[$];
			int q_awid[$];

		logic [31:0]next_addr, al_addr;
		logic [7:0]num_bytes; 
		longint slv_burst_ln; 
		logic [1:0]burst_type;
		logic [2:0]size_addr;
		logic [31:0] wrap_b;
			logic [31:0]addr_array[];
		logic [31:0]extra_addr;
		longint burst_ln;
		int a_wid;

	
extern function new(string name = "slave_driver", uvm_component parent );
extern function void connect_phase (uvm_phase phase);
extern function void build_phase (uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(slave_xtn xtnI);
extern task write_data_chnl(slave_xtn xtnII);
extern task address_channel();
extern task resp_channel();


endclass

	function slave_driver::new(string name = "slave_driver", uvm_component parent);

		super.new(name, parent);
	endfunction 

	function void slave_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(slave_agt_cfg)::get(this, "", "slave_agt_cfg", slv_cfg))
			`uvm_fatal ("SLAVE DRIVER", "cannot get inside driver of slave")
	endfunction 
	
	function void slave_driver::connect_phase(uvm_phase phase);
		vif=slv_cfg.vif;
	endfunction 

	task slave_driver::run_phase(uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask 
	

	task slave_driver::send_to_dut(slave_xtn xtnI);//, slave_xtn clcxtn);

		fork 

			begin
			sem_addr.get(1);
				clcxtn = slave_xtn::type_id::create("clcxtn");
				address_channel();
			sem_addr.put(1);
			sem_resp.put(1);
			end
			
			

				begin
			
				sem_data.get(1);	
						
					write_data_chnl(clcxtn);			
				sem_data.put(1);
				sem_resp.put(1);
							
				end
			
			begin
			sem_resp.get(3);
			
				resp_channel();
			sem_resp.put(1);
			end
				
		join_any 
					
			
	endtask





	task slave_driver::write_data_chnl(slave_xtn xtnII);
					$display("passed the key to second_sem inside slave driver ========at time=%d",$time);
						repeat(2)
						@(vif.slv_drv);

							vif.slv_drv.wready <= 1'b1;
							//@(vif.slv_drv);
							wait(vif.slv_drv.wvalid)
						//repeat(1)
						//@(vif.slv_drv);
						$display("%%%%%%%%%%%%%%%%%%%%%%%%%%% data channel slave time=%d",$time);
						burst_ln = q3.pop_back();
						$display("SLAVE$$$$time at which the value in the queue is popped=%d and after popping the value of queue3333=%p DATA CHANNEL",$time, q3);
					 xtnII.wdata = new[burst_ln];
					$display("SLAVE########value of burst_ln=%d DATA CHANNEL",burst_ln);
					for(int i=0 ; i<(burst_ln); i++)
						begin
							$display("------------------slave driver after asserting WREAdy and waiting for WVALID--------------");
							$display("%%%%%%%%%%%%%%%%%%%%%%%%%%% data channel slave time=%d",$time);
							if(i==(burst_ln-1))
							vif.slv_drv.wready <= 0;
	
							//xtnII.wid = vif.slv_drv.wid;
							xtnII.wdata[i] = vif.slv_drv.wdata;
							xtnII.wstrb= vif.slv_drv.wstrb;
							xtnII.q_strb.push_front(xtnII.wstrb);
							$display("value of the strobe inside queue=%p",xtnII.q_strb);
							@(vif.slv_drv);
						end
						//@(vif.slv_drv);
							$display("memory ===============================%p at time=%d",	xtnII.wdata, $time);
					//	vif.slv_drv.wready <= 0;
					//	repeat(2)
						//@(vif.slv_drv);
					//xtnII.print();

	endtask 
		
	task slave_driver::address_channel();
		parameter FIXED = 2'b00,
			  INCR  = 2'b01,
			  WRAP  = 2'b10;
			$display("passed the key to first_sem inside slave driver ===========at time=%d",$time);
 	 	 	vif.slv_drv.awready  <= 1'b1;
			wait(vif.slv_drv.awvalid)
			//repeat(2)
				@(vif.slv_drv);
						
						clcxtn.awid = vif.slv_drv.awid;
						q_awid.push_front(clcxtn.awid);
						clcxtn.awaddr = vif.slv_drv.awaddr;
						clcxtn.awlen = vif.slv_drv.awlen;
						$display("value of awlen====%d at time=%d", clcxtn.awlen, $time);
						clcxtn.awsize = vif.slv_drv.awsize;		
						clcxtn.awburst = vif.slv_drv.awburst;

					al_addr = clcxtn.awaddr;
					size_addr = clcxtn.awsize;
					burst_type = clcxtn.awburst;
					slv_burst_ln = clcxtn.awlen + 1'b1;
				//	@(vif.slv_drv);
					q3.push_front(slv_burst_ln);
					$display("SLAVE$$$value of the queue Q33333333333333333 =%p at time======%d ADDRESS CHANNEL",q3, $time);
					$display("value of burst length is===++==========%d", slv_burst_ln);
					num_bytes = 2**(size_addr);
					
		wrap_b = (al_addr/(num_bytes*slv_burst_ln))*(num_bytes*slv_burst_ln);
					
			addr_array = new[(slv_burst_ln*num_bytes)];

				case(burst_type)
					FIXED : begin
							for(int i = 1; i<=slv_burst_ln; i++)
							begin
								next_addr = al_addr;
								q1.push_front(next_addr);
								$display("------------Next address for fixed burst=%h----------", next_addr);
							end
						end
					INCR : 
						begin
							for(int i = 1; i<=(slv_burst_ln); i = i+1)
								begin
								next_addr = al_addr + {(i-1)*(num_bytes)};
								q1.push_front(next_addr);
								$display("----Next address for incrementing burst =%h--------at burst no =%d----------", next_addr, i);
								end
						end
					WRAP : begin
						for(int i = 1; i <= slv_burst_ln; i++)
							begin
								
								if(next_addr == (wrap_b + (num_bytes*slv_burst_ln)))
								begin
									next_addr = wrap_b;
									q1.push_front(wrap_b);
									$display("inside for loop wrap boundary  for iteration number = %d", i);
									$display("------------Next address for wrapping burst = %h---at burst no = %d----------", next_addr,i);
								end
								else 
									begin

										next_addr = al_addr + ((i-1)*num_bytes) - (num_bytes*slv_burst_ln);
										$display("inside for loop for iteration number = %d", i);
										q1.push_front(next_addr);
										$display("------------Next address for wrapping burst = %h----at burst no = %d----------", next_addr,i);						end
									
							end
						end
				endcase

				vif.slv_drv.awready <= 1'b0;	
				//@(vif.slv_drv);			
	endtask



	task slave_driver::resp_channel();
	/*	repeat(2)
		@(vif.slv_drv);*/
			wait(!vif.slv_drv.wvalid)
			wait(!vif.slv_drv.awvalid && !vif.slv_drv.wlast)	
			repeat(2)		
			@(vif.slv_drv);
			vif.slv_drv.bvalid <= 1'b1;
			a_wid = q_awid.pop_back();
			vif.slv_drv.bid <= a_wid;
			vif.slv_drv.bresp <= 2'b00;
		//	repeat(2)
			@(vif.slv_drv);
			wait(vif.slv_drv.wvalid)
			vif.slv_drv.bid <= 0;
			vif.slv_drv.bresp <= 2'bxx;

					
			vif.slv_drv.bvalid <= 1'b0;
	endtask 

	
		
			
