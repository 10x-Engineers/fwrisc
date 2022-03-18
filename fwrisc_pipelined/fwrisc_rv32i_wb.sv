module fwrisc_rv32i_wb (
		input			clock,
		input			reset,
	
		`WB_INITIATOR_PORT(wbi_,32,32),
		`WB_INITIATOR_PORT(wbd_,32,32),
		input			irq
		);

	fwrisc_wb #(
			.ENABLE_COMPRESSED  (0),
			.ENABLE_MUL_DIV     (0),
			.ENABLE_DEP         (0),
			.ENABLE_COUNTERS    (1)
			) u_core (
			.clock(clock),
			.reset(reset),
	
			`WB_CONNECT(wbi_,wbi_),
			`WB_CONNECT(wbd_,wbd_),
			.irq(irq)
			);

endmodule
