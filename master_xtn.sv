class master_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(master_xtn)

	//rand logic [3:0]awid, bid, rid, wid;
	rand logic [3:0]awid, awlen, arid, arlen;
	rand logic [3:0]wid;
	logic [3:0]rid, bid;
	rand logic [31:0]awaddr, araddr;
	rand logic [31:0]wdata[];
	logic [31:0]rdata[];
	rand logic [2:0]awsize, arsize;
	rand logic [2:0]n;
	rand logic [1:0]awburst, arburst;
	logic [3:0]wstrb;
	logic [1:0] bresp, rresp;
	logic awvalid, awready, arready, arvalid, bvalid, bready, rlast, rvalid, rready, wlast, wvalid, wready;

	 	logic [31:0]al_addr, next_addr;
		logic [7:0]num_bytes;
		logic [7:0]burst_ln;
		logic [1:0]burst_type;
		logic [2:0]size_addr;
		logic [31:0]wrap_b;
		logic [3:0]strb;
		logic [31:0]extra_addr;
		
		int q_strb[$];
		int q_data[$];

//	constraint EVEN_N{n inside {[1:4]};}	
//	constraint BURST{if(awburst == 2'b10) (awlen == (2**n - 1));} // randomization for length of burst for wrapping 
	constraint DATA{wdata.size == (awlen +1'b1);}
	//constraint RDATA{rdata.size == (awlen +1'b1);}
/*	constraint WID{wid.size == ((awlen +1'b1)*(2**awsize));}
	constraint BID{bid.size == ((awlen +1'b1)*(2**awsize));}
	constraint RID{rid.size == ((awlen +1'b1)*(2**awsize));}*/
	constraint ARRAY{foreach(wdata[i])
				wdata[i]<30;}
	constraint SIZE{awsize inside {[0:2]};}


extern function new(string name = "master_xtn");
extern function void do_print(uvm_printer printer); 
extern function void strb_clc();
extern function void post_randomize();

endclass

	function master_xtn::new(string name = "master_xtn");
		super.new(name);
	endfunction 


	function void master_xtn::do_print(uvm_printer printer);
		printer.print_field("address ID", this.awid, 4, UVM_DEC);
		printer.print_field("burst length ", this.awlen, 4, UVM_DEC);
		printer.print_field("write ID", this.wid, 4, UVM_DEC);
		
				printer.print_field("wstrb", this.wstrb, 4, UVM_DEC);
		
		printer.print_field("response ID", this.bid, 4, UVM_DEC);
		printer.print_field("address read ID", this.arid, 4, UVM_DEC);
		printer.print_field("transfer length read", this.arlen, 4, UVM_DEC);
		printer.print_field("read ID", this.rid, 4, UVM_DEC);
		printer.print_field("write address", this.awaddr, 32, UVM_HEX);
		foreach(wdata[i])
			begin
				printer.print_field($sformatf("wdata[%0d]",i), this.wdata[i], 32, UVM_DEC);
			end
		printer.print_field("read address", this.araddr, 32, UVM_DEC);
		foreach(rdata[i])
			begin
				printer.print_field($sformatf("rdata[%0d]",i), this.rdata[i], 32, UVM_DEC);
			end
		printer.print_field("write data transfer size", this.awsize, 3, UVM_DEC);
		printer.print_field("read data transfer size", this.arsize, 3, UVM_DEC);
	
		printer.print_field("write data burst", this.awburst, 2, UVM_DEC);
		printer.print_field("read data burst", this.arburst, 2, UVM_DEC);
		
	/*	printer.print_field("write response", this.bresp, 2, UVM_DEC);
		printer.print_field("read response", this.rresp, 2, UVM_DEC);
	
		printer.print_field("write address valid", this.awvalid, 1, UVM_DEC);
		printer.print_field("write valid", this.wvalid, 1, UVM_DEC);
		printer.print_field("read address valid", this.arvalid, 1, UVM_DEC);
		printer.print_field("read valid", this.rvalid, 1, UVM_DEC);
		printer.print_field("write response valid", this.bvalid, 1, UVM_DEC);
		printer.print_field("write address ready", this.awready, 1, UVM_DEC);
		printer.print_field("read address ready", this.arready, 1, UVM_DEC);
		printer.print_field("write data ready", this.wready, 1, UVM_DEC);
		printer.print_field("read data ready", this.rready, 1, UVM_DEC);
		printer.print_field("response ready", bready, 1, UVM_DEC);
		printer.print_field("write data last", wlast, 1, UVM_DEC);
		printer.print_field("read data last", rlast, 1, UVM_DEC);*/

	endfunction 

	function void master_xtn::post_randomize();	

		burst_ln = awlen + 1'b1;
		burst_type = awburst;
		size_addr = awsize;
		num_bytes = 2**(size_addr);

		al_addr = awaddr;
		
		wrap_b = (awaddr/(num_bytes*burst_ln))*(num_bytes*burst_ln);

		


		case(burst_type)
		2'b00: begin
				for(int i = 1; i<=burst_ln; i=i+1)
					begin
					next_addr = al_addr;
					strb_clc();
					q_strb.push_front(wstrb);
					
					$display("the strobe wstrb =%h for size =%d, burst_type =%d, and length =%d for addr =%h", wstrb, size_addr, burst_type, burst_ln, next_addr );				
					q_data.push_front(wdata[i-1]);
					


					end
			end
		2'b01: begin
	
				for(int i = 1; i<=(burst_ln); i = i+1)
					begin
						next_addr = al_addr + ((i-1)*num_bytes);
					strb_clc();

					q_strb.push_front(wstrb);



					$display("the strobe wstrb =%h for size =%d, burst_type =%d, and length =%d for addr =%h", wstrb, size_addr, burst_type, burst_ln, next_addr );
					q_data.push_front(wdata[i-1]);
					




					end
		      end

		2'b10: begin		
				extra_addr = al_addr + num_bytes*(1 - burst_ln);
				for(int i = 1; i <= burst_ln; i++)
					begin
								if(extra_addr == (wrap_b + (num_bytes*burst_ln)))
								begin
									next_addr = wrap_b;
									strb_clc();
									$display("the strobe for wrap boundary  wwstrb =%b for size =%d, burst_type =%d, and length =%d for addr =%h", wstrb, size_addr, burst_type, burst_ln, next_addr);
								end
								else
								begin	
									next_addr = al_addr + ((i-1)*num_bytes) - (num_bytes*burst_ln);
									strb_clc();
									$display("the strobe wstrb =%b for size =%d, burst_type =%d, and length =%d for addr =%h", wstrb, size_addr, burst_type, burst_ln, next_addr);
								end
					end
			end
	endcase
						 
	endfunction 	
		  	
	function void master_xtn::strb_clc();
		 case(size_addr)
					
						3'b000: case(next_addr[1:0])
							
							2'b00: wstrb = 4'b0001;
							2'b01: wstrb = 4'b0010;
							2'b10: wstrb = 4'b0100;
							2'b11: wstrb = 4'b1000;
							endcase
						3'b001: case(next_addr[1:0])
							
							2'b00: wstrb = 4'b0011;
							2'b10: wstrb = 4'b0010;
		
							2'b01: wstrb = 4'b1100;
							2'b11: wstrb = 4'b1000;
							endcase
						default: case(next_addr[1:0])
							2'b00: wstrb = 4'b1111;
							2'b01: wstrb = 4'b1110;
							2'b10: wstrb = 4'b1100;
							2'b11: wstrb = 4'b1000;
				     			endcase
 		endcase
		
	endfunction 
	
							

