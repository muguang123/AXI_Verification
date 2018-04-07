interface axi_if(input aclk);

	
	logic [3:0]awid, awlen, wid, wstrb, bid, arid, arlen, rid;
//	logic reset;
	logic [31:0]awaddr, wdata, araddr, rdata;
	logic [2:0]awsize, arsize;
	logic [1:0]awburst, arburst, bresp, rresp;
	logic awvalid, awready, arready, arvalid, bvalid, bready, rlast, rvalid, rready, wlast, wvalid, wready;


clocking mtr_drv@(posedge aclk);
	default input #1 output #0;

//	output reset;
	input wready;
	input awready;
	input bid;
	input bresp;
	input bvalid;
	output awid;
	output awaddr;
	output awlen;
	output awsize;
	output awburst;
	output awvalid;
	output wid;
	output wdata;
	output wstrb;
	output wlast;
	output wvalid;
	output bready;
	output araddr;
	output arid;
	output arlen;
	output arsize;
	output arburst;
	output arvalid;
	output rready;
	input rid;
	input rdata;	
	input rresp;
	input rlast;
	input rvalid; 
	
endclocking

clocking mtr_mon@(posedge aclk);
	default input #1 output #0;
	
//	input reset;
	input wready;
	input awready;
	input bid;
	input bresp;
	input bvalid;
	input  awid;
	input  awaddr;
	input  awlen;
	input  awsize;
	input  awburst;
	input  awvalid;
	input  wid;
	input  wdata;
	input  wstrb;
	input  wlast;
	input  wvalid;
	input  bready;
	input  araddr;
	input  arid;
	input  arlen;
	input  arsize;
	input  arburst;
	input  arvalid;
	input  rready;
	input rid;
	input rdata;	
	input rresp;
	input rlast;
	input rvalid; 
	
endclocking

clocking slv_drv@(posedge aclk);
	
	default input #1 output #0;
	
//	output reset;
	input awid;
	input awaddr;
	input awlen;
	input awsize;
	input awburst;
	input awvalid;
	input wid;
	input wdata;
	input wstrb;
	input wlast;
	input wvalid;
	input bready;
	output bid;
	input araddr;
	input arlen;
	input arsize;
	input arburst;
	input arvalid;
	input rready;
	output rvalid;
	output rlast;
	output rresp;
	output rdata;
	output rid;
	output arready;
	output bvalid;
	output bresp;
	output wready;
	output awready;

endclocking 

clocking slv_mon@(posedge aclk);
	
	default input #1 output #0;
	
//	input reset;
	input awid;
	input awaddr;
	input awlen;
	input awsize;
	input awburst;
	input awvalid;
	input wid;
	input wdata;
	input wstrb;
	input wlast;
	input wvalid;
	input bready;
	input  bid;
	input araddr;
	input arlen;
	input arsize;
	input arburst;
	input arvalid;
	input rready;
	input  rvalid;
	input  rlast;
	input  rresp;
	input  rdata;
	input  rid;
	input  arready;
	input  bvalid;
	input  bresp;
	input  wready;
	input  awready;

endclocking 

modport MTR_DRV(clocking mtr_drv);
modport MTR_MON(clocking mtr_mon);
modport SLV_DRV(clocking slv_drv);
modport SLV_MON(clocking slv_mon);
	
endinterface

	
	
	

	 
