module noise(
					input wire clk,
					input wire reset_n,			
					input wire valid,
					output wire PN4095
);

/////////////////////////////////////////////////////////////////
//PN511
reg d31 = 1;
reg d32 = 0;
reg d33 = 0;
reg d34 = 0;
reg d35 = 0;
reg d36 = 0;
reg d37 = 0;
reg d38 = 0;
reg d39 = 0;
reg d310 = 0;
reg d311 = 0;
reg d312 = 0;
reg d313 = 0;
reg d314 = 0;
reg d315 = 0;
reg d316 = 0;
reg d317 = 0;
reg d318 = 0;
reg d319 = 0;


always @(posedge clk)begin
		d31 <= d31 + d36 + d311 + d316 + d319;
		d32 <= d31;
		d33 <= d32;
		d34 <= d33;
		d35 <= d34;
		d36 <= d35;
		d37 <= d36;
		d38 <= d37;
		d39 <= d38;
		d310 <= d39;
		d311 <= d310;
		d312 <= d311;
		d313 <= d312;
		d314 <= d313;
		d315 <= d314;
		d316 <= d315;
		d317 <= d316;
		d318 <= d317;
		d319 <= d318;
end
assign PN4095 = d319;

endmodule
