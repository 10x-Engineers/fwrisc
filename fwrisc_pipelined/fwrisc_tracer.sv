module fwrisc_tracer (
		input			clock,
		input			reset,
		input [31:0]	pc,
		input [31:0]	instr,
		// True during execute stage. 
		// Note that write-back will occur at the same time
		input			ivalid,
		// ra, rb
		input [5:0]		ra_raddr,
		input [31:0]	ra_rdata,
		input [5:0]		rb_raddr,
		input [31:0]	rb_rdata,
		// rd
		input [5:0]		rd_waddr,
		input [31:0]	rd_wdata,
		input			rd_write,
		// memory access
		input [31:0]	maddr,
		input [31:0]	mdata,
		input [3:0]		mstrb,
		input			mwrite,
		input 			mvalid
		);

endmodule

