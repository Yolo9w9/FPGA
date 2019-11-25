module DePST(
					input wire clk,
					input wire[7:0] rate,			
					input wire code1,
					input wire code2,
					output reg dedlk,
					output reg decode
					
);

parameter COUNT_2K = 32768;//2^15
parameter COUNT_4K = 16384;//2^14
parameter COUNT_8K =  8192;//2^13
parameter COUNT_16K = 4096;//2^12
parameter COUNT_32K = 2048;//2^11
parameter COUNT_64K = 1024;//2^10
parameter COUNT_128K = 512;//2^9
parameter COUNT_256K = 256;//2^8
parameter COUNT_512K = 128;//2^7
parameter COUNT_1024K = 64;//2^6
parameter COUNT_2048K = 32;//2^5
parameter COUNT_4096K = 16;//2^5

reg[30:0] CmpCount;
reg[30:0] CmpCount1;
 
 

always @(rate)
begin
	case(rate)
	
 
	1:
	begin
		CmpCount <= COUNT_2K; 
		CmpCount1 <= COUNT_2K>>1; 
		
	end
	2:	
	begin
		CmpCount <= COUNT_4K; 
		CmpCount1 <= COUNT_4K>>1; 
			
	end
	3:
	begin
		CmpCount <= COUNT_8K; 
		CmpCount1 <= COUNT_8K>>1; 
	end
	4:
	begin
		CmpCount <= COUNT_16K; 
		CmpCount1 <= COUNT_16K>>1; 
			
	end
	5:
	begin
		CmpCount <= COUNT_32K; 
		CmpCount1 <= COUNT_32K>>1; 
			
	end
	6:
	begin
		CmpCount <= COUNT_64K; 
		CmpCount1 <= COUNT_64K>>1; 
			
	end
	7:
	begin
		CmpCount <= COUNT_128K; 
		CmpCount1 <= COUNT_128K>>1; 
			
	end
	8:
	begin
		CmpCount <= COUNT_256K; 
		CmpCount1 <= COUNT_256K>>1; 
 
	end
	9:
	begin
		CmpCount <= COUNT_512K; 
		CmpCount1 <= COUNT_512K>>1; 

			
	end
	10:
	begin
		CmpCount <= COUNT_1024K; 
		CmpCount1 <= COUNT_1024K>>1; 
	 
			
	end
	11:
	begin
		CmpCount <= COUNT_2048K; 
		CmpCount1 <= COUNT_2048K>>1; 
			
	end
	12:
	begin
		CmpCount <= COUNT_4096K; 
		CmpCount1 <= COUNT_4096K>>1; 
			
	end		
	default:
	begin
		CmpCount <= COUNT_4K; 
		CmpCount1 <= COUNT_4K>>1; 
 
	end
	
	endcase

end



 
 reg declk_div2;
reg[30:0] clkcount ;
reg[1:0] dcode1,dcode2;
always @(posedge clk)begin
	dcode1 <= {dcode1[0],code1};
	dcode2 <= {dcode2[0],code2};
	
	if(dcode1 == 2'b10 || dcode1 == 2'b01 || dcode2 == 2'b01 || dcode2 == 2'b10)
	begin
		dedlk <= 1'b0;
		clkcount <= 1;
	end
	else
	begin
		if(clkcount == CmpCount1-1)
		begin
			dedlk <= 1'b1;
			clkcount <= clkcount + 1'b1;
		end
		else if(clkcount == (CmpCount-1))
		begin
			clkcount <= 0;
			dedlk <= 1'b0;
		end
		else
			clkcount <= clkcount + 1'b1;
	end
end

 reg[3:0] dcode11,dcode22;

 
reg ready=0;// 
reg fail=1;// 
  
  
reg[31:0] clkbuf;
reg[31:0] declk_div2buf;
always @(posedge clk)
begin
	clkbuf <= {clkbuf[30:0],dedlk};

	if(fail == 1  )
	begin
			ready <= 0;
			declk_div2 <= 0;
	end
	else if(clkbuf[1:0] == 2'b01)
	begin
		
		dcode11 <= {dcode11[2:0],code1};
		dcode22 <= {dcode22[2:0],code2};
		if((dcode11[2:0] == 3'b100 && dcode22[2:0] == 3'b000 ) || (dcode11[2:0] == 3'b000 && dcode22[2:0] == 3'b100 ))//-00和+00时同步
		begin 
			ready <= 1; 
		end
	end
	else if(clkbuf[1:0] == 2'b10)
	begin
		if(ready == 1)
		begin
			declk_div2 <= ~declk_div2;
			if(declk_div2)
				decode <= decode_buf[0];
			else 
				decode <= decode_buf[1];			
		end	
	end	
end

reg[1:0] decode_buf;
//-00和+00时同步
/*
编码转换过程：先将二进制码分为两组，然后把每一组码编成两个三进制数字（+-0）
转换共有两种模式，加模式和减模式
二进制码   +模式    -模式
	00     -+      -+ 
	01     0+      0- 
	10     +0      -0 
	11     +-      +- 
在译码过程中应先使用加模式，然后采用减模式。即先加后减，交替出现。
例如有二进制码：00 10 11 00 01 10 00 11
PST码编码为：-+ +0 +- -+ 0- +0 -+ +-
*/
always @(posedge clk)
begin
	declk_div2buf <= {declk_div2buf[30:0],declk_div2};

	if(declk_div2buf[1:0] == 2'b01)
	begin
		if((dcode11[2:0] == 3'b100 && dcode22[2:0] == 3'b000 ) || (dcode11[2:0] == 3'b000 && dcode22[2:0] == 3'b100 ))//-00和+00时同步或者失步
		begin
			decode_buf <= 0;
			fail <= 1;
		end
		else if(dcode11[1:0] == 2'b10 && dcode22[1:0] == 2'b01 )
		begin
			decode_buf <= 2'b11;
			fail <= 0;
		end
		else if(dcode11[1:0] == 2'b01 && dcode22[1:0] == 2'b10 )
		begin
			decode_buf <= 2'b00;
			fail <= 0;
		end
		else if(dcode11[0] == 1'b0 && dcode22[0] == 1'b0 )
		begin
			decode_buf <= 2'b01;
			fail <= 0;
		end
		else if(dcode11[1] == 1'b0 && dcode22[1] == 1'b0 )
		begin
			decode_buf <= 2'b10;
			fail <= 0;
		end

	end
	
	if(fail ==1)
		fail <= 0;
end

endmodule
