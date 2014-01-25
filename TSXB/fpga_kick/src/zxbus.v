module 	zxbus
(
	input wire clk,
	
	input wire rd,
	input wire wr,
	input wire mrq,
	input wire iorq,
	input wire reset,
	
	input wire [7:0] fci_in,
	output reg [1:0] fci_sel,
	output wire fci_dir,
	
	output reg [15:0] zaddr,		// addr from CPU
	output reg [7:0] zdata_in,		// data from CPU
	output reg zxb_rnw,
	output reg zxb_mni,
	input wire zxb_en,
	
	output reg mem_req,
	output reg port_req,
	input wire mem_stb,
	input wire port_stb
);
	
	assign fci_dir = fci_dir_int;
	
	reg [7:0] memdata_out;
	reg [7:0] portdata_out;

	// re-strobe Z80 bus signals
	reg rd_r, wr_r, mrq_r, iorq_r;
	
	always @(posedge clk)
	begin
		  rd_r <=   rd;
		  wr_r <=   wr;
		 mrq_r <=  mrq;
		iorq_r <= iorq;
	end

	wire zmrd  =  mrq_r && rd_r;
	wire zmwr  =  mrq_r && wr_r;
	wire ziord = iorq_r && rd_r;
	wire ziowr = iorq_r && wr_r;
	
	// ZXBUS FSM
	reg [3:0] zxb_state;
	
	localparam FCI_ZAL = 2'h0;
	localparam FCI_ZAH = 2'h1;
	localparam FCI_ZD  = 2'h2;

	reg fci_dir_int = 1'b1;
	
	always @(posedge clk)
	begin
		if (reset)
		begin
			fci_dir_int <= 1'b1;
			mem_req <= 1'b0;
			port_req <= 1'b0;
			zxb_state <= 4'h0;
		end

		else
		case (zxb_state)
			// Initial state
			4'h0:
			begin
				fci_sel <= FCI_ZAL;		// FCI_S set to select ZA[7:0]
				zxb_state <= zxb_state + 1;
			end

			// Idle state
			4'h2:
			begin
				zaddr[7:0] <= fci_in;		// ZA[7:0] is read from FCI

				if (zmrd || zmwr || ziord || ziowr)		// If an event on Z80 bus happens...
				begin
					if (zmrd || ziord)
						zxb_rnw <= 1'b1;
					else
						zxb_rnw <= 1'b0;

					if (zmrd || zmwr)
						zxb_mni <= 1'b1;
					else
						zxb_mni <= 1'b0;

					fci_sel <= FCI_ZAH;		// FCI_S set to select ZA[15:8]
					zxb_state <= zxb_state + 1;
				end
			end

			// Active state
			4'h4:
			begin
				zaddr[15:8] <= fci_in;		// ZA[15:8] is read from FCI
				fci_sel <= FCI_ZD;		// FCI_S set to select ZD[7:0]
				zxb_state <= zxb_state + 1;
			end

			// Bus decode
			4'h5:
			begin
				if (zxb_en)			// device decoded its address (external module)
					if (zxb_rnw)
					// read event
					begin
						fci_dir_int <= 1'b0;	// route internal data selector to Z80 databus

						if (zxb_mni)
						// memory read
						begin
							mem_req <= 1'b1;	// start memory request
							zxb_state <= 4'h8;
						end

						else
						// port read
						begin
							port_req <= 1'b1;	// start port request
							zxb_state <= 4'h7;
						end
					end

					else
					// write event
						zxb_state <= zxb_state + 1;

				else
					zxb_state <= 4'hF;		// not our turn - go to Finish state
			end

			// Data read
			4'h6:
			begin
				zdata_in <= fci_in;		// ZD[7:0] is read from FCI

				if (zxb_mni)
				// memory write
				begin
					mem_req <= 1'b1;	// start memory request
					zxb_state <= 4'h8;
				end

				else
				// port write
				begin
					port_req <= 1'b1;	// start port request
					zxb_state <= 4'h7;
				end
			end

			// Write to internal port (external module)
			4'h7:
			begin
				if (port_stb)
				// port strobe received
				begin
					port_req <= 1'b0;		// stop port request
					zxb_state <= 4'hF;		// go to Finish state
				end
			end

			// Read/write to internal memory (external module)
			4'h8:
			begin
				if (mem_stb)
				// memory strobe received
				begin
					mem_req <= 1'b0;		// stop memory request
					zxb_state <= 4'hF;		// go to Finish state
				end
			end

			// Finish state
			4'hF:
			begin
				if (!(zmrd || zmwr || ziord || ziowr))		// wait for the end of bus activity
				begin
					fci_dir_int <= 1'b1;		// release data bus
					zxb_state <= 4'h0;		// return to Idle state
				end
			end

			default:
				zxb_state <= zxb_state + 1;
		endcase
	end
	
endmodule
