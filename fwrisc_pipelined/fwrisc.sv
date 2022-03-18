
module fwrisc #(
		parameter ENABLE_COMPRESSED=0,
		parameter ENABLE_MUL_DIV=0,
		parameter ENABLE_DEP=0,
		parameter ENABLE_COUNTERS=1,
		parameter[31:0] VENDORID = 0,
		parameter[31:0] ARCHID = 0,
		parameter[31:0] IMPID = 0,
		parameter[31:0] HARTID = 0
		) (
		input			clock,
		input			reset,
		
		output reg[31:0]	PC,
		input[31:0]		idata,
		output			ivalid,
		input			iready,
		
		output			dvalid,
		output[31:0]	daddr,
		output[31:0]	dwdata,
		output[3:0]		dwstb,
		output			dwrite,
		input[31:0]		drdata,
		input			dready,
		input			irq,
		output logic flush);
	
	wire[31:0]				pc;
	wire[31:0]				pc_seq;
	wire					fetch_valid;
	wire					instr_complete;
	wire					trap;
	wire					tret;
	logic[31:0]				instr;
	wire					instr_c;
	wire					int_reset;
	wire					soft_reset_req;
	reg[4:0]				soft_reset_count;
	wire[31:0]				mtvec;
	reg[31:0]				tracer_pc;
	reg[31:0]				tracer_instr;
	wire[31:0]				dep_lo;
	wire[31:0]				dep_hi;
	logic instr_c_p2;
	logic branch_taken;
	logic stall_a;
	logic stall;
	assign int_reset = (reset | soft_reset_count != 0);
always@(*)
begin
flush = branch_taken;
end
	
	always @(posedge clock) begin
		if (reset) begin
			soft_reset_count <= 0;
		end else begin
			if (soft_reset_req) begin
				soft_reset_count <= 5'h1f;
			end else if (soft_reset_count != 0) begin
				soft_reset_count <= soft_reset_count - 1;
			end
		end
	end
	////////// Inserting seperate PC Counter/////////////////
//reg[31:0] PC;
always@(posedge clock)
begin 
if(reset)
begin
PC = 32'b0;
//flush = 0;
end
else
begin
if(branch_taken)
begin
PC = pc;
//flush = 1;
end
else if(!stall_a)
PC = PC + 4;

end
end

	//assign intr_c = 0;
//assign fetch_valid = 1;
	wire					decode_complete;

	fwrisc_fetch #(
		.ENABLE_COMPRESSED  (ENABLE_COMPRESSED )
		) u_fetch (
		.clock              (clock             ), 
		.reset              (int_reset         ), 
		.next_pc            (PC                ), 
		.next_pc_seq        (pc_seq            ), 
		.iaddr              (iaddr             ), 
		.idata              (idata             ), 
		.ivalid             (ivalid            ), 
		.iready             (iready            ), 
		.fetch_valid        (fetch_valid       ), 
		.decode_complete    (decode_complete   ), 
		.instr              (instr             ), 
		.instr_c            (instr_c           ));

	logic[31:0]				ra_raddr;
	logic[31:0]				ra_rdata;
	logic[31:0]				rb_raddr;
	logic[31:0]				rb_rdata;
	wire					decode_valid;
	logic[31:0]				op_a;
	logic[31:0]				op_b;
	logic[31:0]				op_c;
	logic[3:0]				op;
	logic[5:0]				rd_raddr;
	logic[4:0]				op_type;
logic[4:0] opcode;


Pipe2 P2(clock,reset,idata,instr_c,instr,instr_c_p2,flush,stall_a);
	fwrisc_decode #(
		.ENABLE_COMPRESSED  (ENABLE_COMPRESSED )
		) u_decode (
		.clock              (clock             ), 
		.reset              (int_reset         ), 
		.fetch_valid        (fetch_valid       ), 
		.decode_complete    (decode_complete   ), 
		.instr_i            (instr           ), 
		.instr_c            (instr_c_p2           ), 
		.pc                 (PC               ), 
		.ra_raddr           (ra_raddr          ), 
		.ra_rdata           (ra_rdata          ), 
		.rb_raddr           (rb_raddr          ), 
		.rb_rdata           (rb_rdata          ), 
		.decode_valid       (decode_valid      ), 
		.exec_complete      (instr_complete    ), 
		.op_a               (op_a              ), 
		.op_b               (op_b              ), 
		.op_c               (op_c              ), 
		.op                 (op                ), 
		.rd_raddr_w           (rd_raddr          ), 
		.op_type            (op_type           ),
		.opcode	(opcode),
		.stall(stall));
	
	always @(posedge clock) begin
		if (reset) begin
			tracer_pc <= 0;
			tracer_instr <= 0;
		end else begin
			if (decode_valid) begin
				tracer_pc <= pc;
				tracer_instr <= instr;
			end
		end
	end

	wire[5:0]				rd_waddr;
	wire[31:0]				rd_wdata;
	wire					rd_wen;
	wire                    meie;
	wire                    mie;
//logic[4:0] opcode_p;
logic[4:0] opcode_p1;
logic[4:0] opcode_p3;
logic decode_valid_p3 = 1;
logic [31:0]op_a_p3;
logic [31:0]op_b_p3;
logic [31:0]op_c_p3;
logic [5:0] rd_raddr_p3;
logic [5:0] rd_raddr_p4;
logic [5:0] rd_raddr_p5;
logic [3:0] op_p3;
logic [4:0] op_type_p3; 
logic instr_c_p3;
	logic[5:0]				rd_waddr_p3;
	logic[31:0]				rd_wdata_p3;
logic[5:0]				rd_waddr_p4;
	logic[31:0]				rd_wdata_p4;


logic sel_op_a,sel_op_b;

fw_comparator comp1(ra_raddr[5:0],rd_waddr,sel_op_a);
fw_comparator comp2(rb_raddr[5:0],rd_waddr,sel_op_b);
always@(*)
begin
if(sel_op_a || sel_op_b && stall)
stall_a =1;
else
stall_a = 0;
end

logic[31:0] alu_out;
logic[31:0] op_a_mux;
logic[31:0] op_b_mux;

fw_mux m1(op_a , alu_out , sel_op_a ,op_a_mux);
fw_mux m2(op_b , alu_out , sel_op_b ,op_b_mux);


Pipe3 P3(clock,reset,instr_c_p2,op_a_mux,op_b_mux,op_c,rd_raddr,op,op_type,decode_valid,opcode,rd_waddr,rd_wdata,instr_c_p3,op_a_p3,op_b_p3,op_c_p3,rd_raddr_p3,op_p3,op_type_p3,decode_valid_p3,opcode_p3,rd_waddr_p3,rd_wdata_p3,flush);
fwrisc_exec #(
		.ENABLE_COMPRESSED  (ENABLE_COMPRESSED ),
		.ENABLE_MUL_DIV  (ENABLE_MUL_DIV )
		) u_exec (
		.clock           (clock          ), 
		.reset           (int_reset      ), 
		.decode_valid    (decode_valid_p3 ),
		.opcode		(opcode_p3	),
		.instr_complete  (instr_complete ), 
		.trap            (trap           ),
		.tret            (tret           ),
		.instr_c         (instr_c_p3        ), 
		.op_type         (op_type_p3        ), 
		.op_a            (op_a_p3          ), 
		.op_b            (op_b_p3           ), 
		.op              (op_p3            ), 
		.op_c            (op_c_p3           ), 
		.rd              (rd_raddr_p3       ), 
		.rd_waddr        (rd_waddr      ), 
		.rd_wdata        (rd_wdata     ), 
		.rd_wen          (rd_wen         ), 
		.pc              (pc             ), 
		.pc_seq          (pc_seq         ),
		.mtvec           (mtvec          ),
		.dep_lo          (dep_lo         ),
		.dep_hi          (dep_hi         ),
		.dvalid          (dvalid         ),
		.daddr           (daddr          ),
		.dwrite          (dwrite         ),
		.dwdata          (dwdata         ),
		.dwstb           (dwstb          ),
		.drdata          (drdata         ),
		.dready          (dready         ),
		.irq             (irq            ),
		.meie            (meie           ),
		.mie             (mie            ),
		.br_taken 	(branch_taken),
		.alu_out1	(alu_out));

/*logic[5:0] rd_waddr_p5;
logic[31:0] rd_wdata_p5;
always@(posedge clock)
begin
rd_waddr_p5 = rd_waddr;
rd_wdata_p5 = rd_wdata;
end*/
	assign rd_wen=1;
	fwrisc_regfile #(
		.ENABLE_COUNTERS  	(ENABLE_COUNTERS ),
		.ENABLE_DEP       	(ENABLE_DEP      ),
		.VENDORID			(VENDORID        ),
		.ARCHID				(ARCHID          ),
		.IMPID				(IMPID           ),
		.HARTID				(HARTID          ),
		.ISA                ({
			2'b01,
			4'b0, // 29:26
			1'b0,							// Reserved
			1'b0,							// Reserved
			1'b0,							// Non-standard extensions
			1'b0,							// Reserved
			1'b0,							// Vector extension
			1'b0,							// User mode
			1'b0,							// Transactional memory extension
			1'b0,							// Supervisor mode
			1'b0,							// Reserved
			1'b0,							// Quad-precision floating-point
			1'b0,							// Packed-SIMD
			1'b0,							// Reserved
			1'b1,							// User-level interrupts
			(ENABLE_MUL_DIV)?1'b1:1'b0,		// Multiply/Divide
			1'b0,							// Decimal floating-point extension
			1'b0,							// Reserved
			1'b0,							// Dynamically-translated languages
			1'b1,							// RV32I
			1'b0,							// Reserved
			1'b0,							// Additional
			1'b0,							// Single-precision floating-point
			1'b0,							// RV32E
			1'b0,							// Double-precision floating-point
			(ENABLE_COMPRESSED)?1'b1:1'b0,	// Compressed instructions
			1'b0, 							// Bit operations
			1'b0  							// Atomic		
			})
		) u_regfile (
		.clock            (clock              ), 
		.reset            (int_reset          ), 
		.soft_reset_req   (soft_reset_req     ),
		.instr_complete   (instr_complete     ), 
		.trap             (trap               ),
		.tret             (tret               ),
		.irq              (irq                ),
		.ra_raddr         (ra_raddr           ), 
		.ra_rdata         (ra_rdata           ), 
		.rb_raddr         (rb_raddr           ), 
		.rb_rdata         (rb_rdata           ), 
		.rd_waddr         (rd_waddr_p3         ), 
		.rd_wdata        (rd_wdata_p3       ), 
		.rd_wen           (rd_wen             ),
		.dep_lo           (dep_lo             ),
		.dep_hi           (dep_hi             ),
		.mtvec            (mtvec              ),
		.meie             (meie               ),
		.mie              (mie                )
		);
	
	fwrisc_tracer u_tracer (
		.clock     (clock                     ), 
		.reset     (reset                     ), 
		.pc        (tracer_pc                 ), 
		.instr     (tracer_instr              ), 
		.ivalid    (instr_complete            ), 
		.ra_raddr  (ra_raddr                  ), 
		.ra_rdata  (ra_rdata                  ), 
		.rb_raddr  (rb_raddr                  ), 
		.rb_rdata  (rb_rdata                  ), 
		.rd_waddr  (rd_waddr                  ), 
		.rd_wdata  (rd_wdata                  ), 
		.rd_write  (rd_wen                    ), 
		.maddr     (daddr                     ), 
		.mdata     ((dwrite)?dwdata:drdata    ), 
		.mstrb     (dwstb                     ), 
		.mwrite    (dwrite                    ), 
		.mvalid    ((dready && dvalid)        ));


endmodule
