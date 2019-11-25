module PN15(
					input wire clk,
					input wire reset_n,			
					input wire valid,
					input [15:0] reg3,
					output wire SW16,
					output wire PN3,
					output wire PN7,
					output wire PN15,
					output wire PN31,
					output wire PN63,
					output wire PN127,
					output wire PN255,
					output wire PN511,
					output wire PN1023,
					output wire PN2047,
					output wire PN4095,
					output wire PN8191,
					output wire PN16383,
					output wire PN32767,
					output wire PN65535,
					output wire PN131071,
					output wire PN262143,
					output wire PN524287,
					output wire PN1048575,
					output wire PN2097151,
					output wire PN4194303,
					output wire PN8388607,
					output wire PN16777215,
					output wire PN33554431,
					output[26:0]PN_seq
);
 
 
 
 
assign  PN_seq[26:0]={
SW16,PN33554431,PN16777215,PN8388607,PN4194303,PN2097151,
PN1048575,PN524287,PN262143, PN131071, PN65535,
PN32767,PN16383,PN8191,PN4095,PN2047,
PN1023,PN511,PN255,PN127,PN63,
PN31, PN15,PN7,PN3,1'b1,
1'b0   
};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//PN3
reg [2:0]dn2 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn2[0] <= dn2[1] + dn2[0];
 
		dn2[2:1] <= dn2[1:0] ;
	end
end

assign PN3 =  dn2[0];
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//PN7
reg [2:0]dn3 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn3[0] <= dn3[2] + dn3[0];
 
		dn3[2:1] <= dn3[1:0] ;
	end
end

assign PN7 =  dn3[0];
/////////////////////////////////////////////////////////////////
//PN15
reg [3:0]dn4 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn4[0] <= dn4[3] + dn4[0];
 
		dn4[3:1] <= dn4[2:0] ;
	end
end

assign PN15 =  dn4[0];
 
//////////////////////////////////////////////////////////////////
//PN31
reg [4:0]dn5 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn5[0] <= dn5[4] + dn5[1];
 
		dn5[4:1] <= dn5[3:0] ;
	end
end

assign PN31 =  dn5[0];
//////////////////////////////////////////////////////////////////
//PN63
reg [5:0]dn6 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn6[0] <= dn6[5] + dn6[0];
 
		dn6[5:1] <= dn6[4:0] ;
	end
end

assign PN63 =  dn6[0];

 

 //////////////////////////////////////////////////////////////////
//PN127
reg [6:0]dn7 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn7[0] <= dn7[6] + dn7[2];
 
		dn7[6:1] <= dn7[5:0] ;
	end
end

assign PN127 =  dn7[0];

  //////////////////////////////////////////////////////////////////
//PN255
reg [7:0]dn8 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn8[0] <= dn8[7] + dn8[3]+ dn8[2]+ dn8[1];
 
		dn8[7:1] <= dn8[6:0] ;
	end
end

assign PN255 =  dn8[0];

  //////////////////////////////////////////////////////////////////
//PN511
reg [8:0]dn9 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn9[0] <= dn9[8] + dn9[3] ;
 
		dn9[8:1] <= dn9[7:0] ;
	end
end

assign PN511 =  dn9[0];

//////////////////////////////////////////////////////////////////
//PN1023
reg [25:0]dn10 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn10[0] <= dn10[9] + dn10[2] ;
 
		dn10[25:1] <= dn10[24:0] ;
	end
end

assign PN1023 =  dn10[0];

 //////////////////////////////////////////////////////////////////
//PN2047
reg [25:0]dn11 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn11[0] <= dn11[10] + dn11[1] ;
 
		dn11[25:1] <= dn11[24:0] ;
	end
end

assign PN2047 =  dn11[0];
 //////////////////////////////////////////////////////////////////
//PN4095
reg [25:0]dn12 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn12[0] <= dn12[11] + dn12[5]+ dn12[3]+ dn12[0] ;
 
		dn12[25:1] <= dn12[24:0] ;
	end
end

assign PN4095 =  dn12[0];
  //////////////////////////////////////////////////////////////////
//PN8191
reg [25:0]dn13 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn13[0] <= dn13[12] + dn13[3]+ dn13[2]+ dn13[0] ;
 
		dn13[25:1] <= dn13[24:0] ;
	end
end

assign PN8191 =  dn13[0];
 
  //////////////////////////////////////////////////////////////////
//PN16383
reg [25:0]dn14 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn14[0] <= dn14[13] + dn14[9]+ dn14[5]+ dn14[0] ;
 
		dn14[25:1] <= dn14[24:0] ;
	end
end

assign PN16383 =  dn14[0];
 
  //////////////////////////////////////////////////////////////////
//PN32767
reg [25:0]dn15 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn15[0] <= dn15[14] + dn15[0]  ;
 
		dn15[25:1] <= dn15[24:0] ;
	end
end

assign PN32767 =  dn15[0];
 
  //////////////////////////////////////////////////////////////////
//PN65535
reg [25:0]dn16 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn16[0] <= dn16[15] + dn16[11]+ dn16[2]+ dn16[0] ;
 
		dn16[25:1] <= dn16[24:0] ;
	end
end

assign PN65535 =  dn16[0];
  //////////////////////////////////////////////////////////////////
//PN131071
reg [25:0]dn17 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn17[0] <= dn17[16] + dn17[2]  ;
 
		dn17[25:1] <= dn17[24:0] ;
	end
end

assign PN131071 =  dn17[0];

  //////////////////////////////////////////////////////////////////
//PN262143
reg [25:0]dn18 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn18[0] <= dn18[17] + dn18[6]  ;
 
		dn18[25:1] <= dn18[24:0] ;
	end
end

assign PN262143 =  dn18[0];

  //////////////////////////////////////////////////////////////////
//PN524287
reg [25:0]dn19 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn19[0] <= dn19[18] + dn19[4]+ dn19[1]+ dn19[0] ;
 
		dn19[25:1] <= dn19[24:0] ;
	end
end

assign PN524287 =  dn19[0];
//////////////////////////////////////////////////////////////////
//PN1048575
reg [25:0]dn20 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn20[0] <= dn20[19] + dn20[2] ;
 
		dn20[25:1] <= dn20[24:0] ;
	end
end

assign PN1048575 =  dn20[0];

 
	 
 //////////////////////////////////////////////////////////////////
//PN2097151
reg [25:0]dn21 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn21[0] <= dn21[20] + dn21[1] ;
 
		dn21[25:1] <= dn21[24:0] ;
	end
end

assign PN2097151 =  dn21[0];
 //////////////////////////////////////////////////////////////////
//PN4194303
reg [25:0]dn22 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn22[0] <= dn22[21] + dn22[0] ;
 
		dn22[25:1] <= dn22[24:0] ;
	end
end

assign PN4194303 =  dn22[0];
 //////////////////////////////////////////////////////////////////
//PN8388607
reg [25:0]dn23 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn23[0] <= dn23[22] + dn23[4] ;
 
		dn23[25:1] <= dn23[24:0] ;
	end
end

assign PN8388607 =  dn23[0];
 //////////////////////////////////////////////////////////////////
//PN16777215
reg [25:0]dn24 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn24[0] <= dn24[23] + dn24[6]+ dn24[1]+ dn24[0] ;
 
		dn24[25:1] <= dn24[24:0] ;
	end
end

assign PN16777215 =  dn24[0];
 //////////////////////////////////////////////////////////////////
//PN33554431
reg [25:0]dn25 = 1;
 
always @(posedge clk)begin
	if(valid)begin
		dn25[0] <= dn25[24] + dn25[2] ;
 
		dn25[25:1] <= dn25[24:0] ;
	end
end

assign PN33554431 =  dn25[0];
 
 //////////////////////////////////////////////////////////////////
//SW16
reg[3:0] count_data;
 reg sw_data;
always @(posedge clk)begin
	if(valid)begin
	      count_data <= count_data - 1'b1;
			sw_data <= reg3[count_data];
	end
end

assign SW16 =  sw_data;
 
 

endmodule
