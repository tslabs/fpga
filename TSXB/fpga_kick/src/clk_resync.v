
// clk = 112MHz
// Note: the resolution of host Fcpu phasing must be not greater than 28MHz period

	input wire host_m1_n;
	input wire int_n;
	
	reg [21:0] cnt;
	wire [16:0] tcpu = cnt[21:5];	// counter of host CPU 3.5MHz tacts
	
	wire host_m1_s = host_m1_r[1] && !host_m1_r[2];
	reg [2:0] host_m1_r;
	always @(posedge clk)
		host_m1_r <= {host_m1_r[1:0], !host_m1_n};
	
	always @(posedge clk)
		if (!int_n)
			cnt <= 0;
		else if (host_m1_s)
			cnt <= {cnt[1] ? (cnt[21:2] + 1) : cnt[21:2], 2'b00};
		else
			cnt <= cnt + 1;
