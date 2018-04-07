class slave_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(slave_xtn)

	//rand logic [3:0]awid, bid, rid, wid;
	logic [3:0]awid, awlen, arid, arlen;
	rand logic [3:0]rid, bid;
	logic [3:0]wid;
	logic [31:0]awaddr, araddr;
	logic [31:0]wdata[];
	rand logic [31:0] rdata[];
	logic [2:0]awsize, arsize;
	//logic [2:0]n;
	logic [1:0]awburst, arburst;
	logic [3:0]wstrb;
	logic [1:0] bresp, rresp;
	logic awvalid, awready, arready, arvalid, bvalid, bready, rlast, rvalid, rready, wlast, wvalid, wready;

	 	logic [31:0]al_addr, next_addr;
		logic [7:0]num_bytes;
		logic [4:0]burst_ln;
		logic [1:0]burst_type;
		logic [2:0]size_addr;
		logic [31:0]wrap_b;
		logic [3:0]strb;
		logic [31:0]extra_addr;
		
		int q_strb[$];

	//constraint EVEN_N{n inside {[1:4]};}	
	//constraint BURST{if(awburst == 2'b10) (awlen == (2**n - 1));} // randomization for length of burst for wrapping 
	//constraint DATA{wdata.size == (awlen +1'b1);}
//	constraint RDATA{rdata.size == (awlen +1'b1);}
//	constraint WDTA{wdata.size == (awlen + 1'b1);}
/*	constraint WID{wid.size == ((awlen +1'b1)*(2**awsize));}
	constraint BID{bid.size == ((awlen +1'b1)*(2**awsize));}
	constraint RID{rid.size == ((awlen +1'b1)*(2**awsize));}*/
//	constraint ARRAY{foreach(rdata[i])
//				rdata[i]<30;}
	//constraint SIZE{awsize inside {[0:2]};}


extern function new(string name = "slave_xtn");
extern function void do_print(uvm_printer printer); 
//extern function void strb_clc();
//extern function void post_randomize();

endclass

	function slave_xtn::new(string name = "slave_xtn");
		super.new(name);
	endfunction 


	function void slave_xtn::do_print(uvm_printer printer);
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

