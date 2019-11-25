module DeNRZ(
					input wire clk,
					input wire reset_n,			
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
	default:
	begin
		CmpCount <= COUNT_2K; 
		CmpCount1 <= COUNT_2K>>1; 
 
	end
	
	endcase

end




reg[30:0] clkcount ;
reg[1:0] dcode1,dcode2;
always @(posedge clk)begin
	dcode1 <= {dcode1[0],code1};
	dcode2 <= {dcode2[0],code2};
	
	if(dcode1 == 2'b10 || dcode2 == 2'b10)
	begin
		dedlk <= 1'b0;
		clkcount <= 0;
	end
	else
	begin
		if(clkcount == CmpCount1-1)
		begin
			dedlk <= 1'b1;
			clkcount <= clkcount + 1'b1;
		end
		else if(clkcount == CmpCount-1)
		begin
			clkcount <= 0;
			dedlk <= 1'b0;
		end
		else
			clkcount <= clkcount + 1'b1;
	end
end


always @(posedge clk)begin
	if(dcode1 == 2'b10)
		decode <= 1'b0;
	else if(dcode1 == 2'b01)
		decode <= 1'b1;
end

endmodule
