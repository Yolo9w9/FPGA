module jd_gen(
			input wire clk,
			input wire reset_n,
			input wire[7:0]  reg1,//基带信号类型
			input wire[7:0]  reg2,//信号频率
			input wire[15:0] reg3,//16bit值
			output wire jd_valid,    //使能输出
			output reg jd_clk,    //时钟输出
			output reg jd_data,   //数据输出
			output reg jd_xd,	    //相对码输出
			
			output reg jd_validx2,    //使能输出
			output reg jd_clkx2,    //时钟输出
			output reg jd_validx3,    //使能输出
			output reg jd_clkx3    //时钟输出
);



parameter COUNT_2K = 32768;//2^15
parameter COUNT_4K = 16384;//2^14
parameter COUNT_8K = 8192;//2^13
parameter COUNT_16K = 4096;//2^12
parameter COUNT_32K = 2048;//2^11
parameter COUNT_64K = 1024;//2^10
parameter COUNT_128K = 512;//2^9
parameter COUNT_256K = 256;//2^8
parameter COUNT_512K = 128;//2^7
parameter COUNT_1024K = 64;//2^6
parameter COUNT_2048K = 32;//2^6

assign jd_valid = data_valid;


reg[14:0] count_div;
reg data_valid;
reg d1;
always @(posedge clk)begin
   if(!reset_n)
		count_div <= 0;	
	else
		count_div <= count_div + 1'b1;
	
	case(reg2)
	1:
	begin
		d1 <= count_div[14];
		jd_clk <= d1;
		
		if(d1==1 && count_div[14] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
		
	end
	2:	
	begin
		d1 <= count_div[13];
		jd_clk <= d1;
		
		if(d1==1 && count_div[13] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	3:
	begin
		d1 <= count_div[12];
		jd_clk <= d1;
		
		if(d1==1 && count_div[12] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	4:
	begin
		d1 <= count_div[11];
		jd_clk <= d1;
		
		if(d1==1 && count_div[11] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	5:
	begin
		d1 <= count_div[10];
		jd_clk <= d1;
		
		if(d1==1 && count_div[10] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	6:
	begin
		d1 <= count_div[9];
		jd_clk <= d1;
		
		if(d1==1 && count_div[9] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	7:
	begin
		d1 <= count_div[8];
		jd_clk <= d1;
		
		if(d1==1 && count_div[8] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	8:
	begin
		d1 <= count_div[7];
		jd_clk <= d1;
		
		if(d1==1 && count_div[7] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	9:
	begin
		d1 <= count_div[6];
		jd_clk <= d1;
		
		if(d1==1 && count_div[6] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	10:
	begin
		d1 <= count_div[5];
		jd_clk <= d1;
		
		if(d1==1 && count_div[5] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end
	11:
	begin
		d1 <= count_div[4];
		jd_clk <= d1;
		
		if(d1==1 && count_div[4] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
			
	end	
	default:
	begin
		d1 <= count_div[14];
		jd_clk <= d1;
		
		if(d1==1 && count_div[14] == 0)      data_valid <= 1;
		else	                               data_valid <= 0;	
	end
	
	endcase
end





reg[3:0] count_data;
always @(posedge clk)begin
	case(reg1)
	1:
	begin
		if(data_valid)begin
			jd_data <= PN15;
			jd_xd <= jd_xd ^ PN15;
		end
	end
	2:
	begin
		if(data_valid)begin
			jd_data <= PN31;
			jd_xd <= jd_xd ^ PN31;
		end
	end
	3:
	begin
		if(data_valid)begin
			jd_data <= PN511;
			jd_xd <= jd_xd ^ PN511;
		end
	end
	4:
	begin
		if(data_valid)begin
			count_data <= count_data - 1'b1;
			jd_data <= reg3[count_data];
			jd_xd <= jd_xd ^ reg3[count_data];
		end
	end	
	default:
	begin
		if(data_valid)begin
			jd_data <= PN15;
			jd_xd <= jd_xd ^ PN15;
		end
	end
	endcase
end


wire PN15,PN31,PN511;
PN15 PN_gen_inst1(
					.clk(clk),
					.reset_n(reset_n),			
					.valid(data_valid),
					.PN15(PN15),
					.PN31(PN31),
					.PN511(PN511),
					.PN1023(),
					.PN2047()					
);




reg d2;

always @(posedge clk)begin
 
	
	case(reg2+1)
	1:
	begin
		d2 <= count_div[14];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[14] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
		
	end
	2:	
	begin
		d2 <= count_div[13];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[13] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	3:
	begin
		d2 <= count_div[12];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[12] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	4:
	begin
		d2 <= count_div[11];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[11] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	5:
	begin
		d2 <= count_div[10];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[10] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	6:
	begin
		d2 <= count_div[9];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[9] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	7:
	begin
		d2 <= count_div[8];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[8] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	8:
	begin
		d2 <= count_div[7];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[7] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	9:
	begin
		d2 <= count_div[6];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[6] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	10:
	begin
		d2 <= count_div[5];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[5] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end
	11:
	begin
		d2 <= count_div[4];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[4] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end	
		12:
	begin
		d2 <= count_div[3];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[3] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
			
	end	
	default:
	begin
		d2 <= count_div[13];
		jd_clkx2 <= d2;
		
		if(d2==1 && count_div[13] == 0)      jd_validx2 <= 1;
		else	                               jd_validx2 <= 0;	
	end
	
	endcase
end











reg d3;

always @(posedge clk)begin
 
	
	case(reg2+2)
	1:
	begin
		d3 <= count_div[14];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[14] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
		
	end
	2:	
	begin
		d3 <= count_div[13];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[13] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	3:
	begin
		d3 <= count_div[12];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[12] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	4:
	begin
		d3 <= count_div[11];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[11] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	5:
	begin
		d3 <= count_div[10];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[10] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	6:
	begin
		d3 <= count_div[9];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[9] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	7:
	begin
		d3 <= count_div[8];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[8] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	8:
	begin
		d3 <= count_div[7];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[7] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	9:
	begin
		d3 <= count_div[6];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[6] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	10:
	begin
		d3 <= count_div[5];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[5] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	11:
	begin
		d3 <= count_div[4];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[4] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end	
	12:
	begin
		d3 <= count_div[3];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[3] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end
	13:
	begin
		d3 <= count_div[2];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[2] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
			
	end	
	default:
	begin
		d3 <= count_div[12];
		jd_clkx3 <= d3;
		
		if(d3==1 && count_div[12] == 0)      jd_validx3 <= 1;
		else	                               jd_validx3 <= 0;	
	end
	
	endcase
end

























endmodule

