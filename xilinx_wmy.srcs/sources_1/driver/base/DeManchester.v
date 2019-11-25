module DeManchester(
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
	case(rate+1)
	
 
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



 
 reg declkx2;
reg[30:0] clkcount ;
reg[1:0] dcode1,dcode2;
always @(posedge clk)begin
	dcode1 <= {dcode1[0],code1};
	dcode2 <= {dcode2[0],code2};
	
	if(dcode1 == 2'b10)
	begin
		declkx2 <= 1'b0;
		clkcount <= 0;
	end
	else
	begin
		if(clkcount == CmpCount1-1)
		begin
			declkx2 <= 1'b1;
			clkcount <= clkcount + 1'b1;
		end
		else if(clkcount == (CmpCount-1))
		begin
			clkcount <= 0;
			declkx2 <= 1'b0;
		end
		else
			clkcount <= clkcount + 1'b1;
	end
end

 reg[1:0] dcode11,dcode22;

reg[1:0] r0,r1,r2,r3;
reg[3:0] r;
reg ready=0;// 
reg fail=1;// 
  
  
reg[31:0] clkbuf;
reg[31:0] dedlkbuf;
always @(posedge clk)
begin
	clkbuf <= {clkbuf[30:0],declkx2};

	if(fail == 1  )
	begin
			ready <= 0;
			dedlk <= 0;
	end
	else if(clkbuf[1:0] == 2'b01)
	begin
		dcode11 <= {dcode11[0],code1};
		if(dcode11 == 2'b00 )
		begin 
			ready <= 1; 
		end
	end
	else if(clkbuf[1:0] == 2'b10)
	begin
		if(ready == 1)
		begin
			dedlk <= ~dedlk;
		end	
	end	
end

always @(posedge clk)
begin
	dedlkbuf <= {dedlkbuf[30:0],dedlk};

	if(dedlkbuf[1:0] == 2'b01)
	begin
		if(dcode11 == 2'b10)
		begin
			decode <= 1;
			fail <= 0;
		end
		else if(dcode11 == 2'b01)
		begin
			decode <= 0;
			fail <= 0;
		end
		else   if(dcode11 == 2'b11)
		begin
			decode <= 0;
			fail <= 1;
		end
	end
	
	if(fail ==1)
		fail <= 0;
end

endmodule
