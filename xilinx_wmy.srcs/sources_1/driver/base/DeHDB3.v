module DeHDB3(
					input wire clk,
					input wire[7:0] rate,			
					input wire[31:0 ]NCO,//时钟
					input wire code1,
					input wire code2,
					output reg dedlk,
					output reg decode
					
);

parameter COUNT_1K = 65536;//2^15
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
parameter COUNT_8192K = 8;//2^5
parameter COUNT_16384K = 4;//2^5

reg[30:0] CmpCount;
reg[30:0] CmpCount1;
 
 

always @(posedge clk)
begin
 
		CmpCount <= NCO; 
		CmpCount1 <= NCO>>1; 
 

end



 
 
reg[30:0] clkcount ;
reg[1:0] dcode1,dcode2;
always @(posedge clk)begin
	dcode1 <= {dcode1[0],code1};
	dcode2 <= {dcode2[0],code2};
	
	if(dcode2 == 2'b10 )
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
		else if(clkcount == (CmpCount-1))
		begin
			clkcount <= 0;
			dedlk <= 1'b0;
		end
		else
			clkcount <= clkcount + 1'b1;
	end
end

 
reg[1:0] r0,r1,r2,r3;
reg[3:0] r;
reg flag0;//前一非零码极性
reg flag1;//前一V码极性
reg[31:0] clkbuf;
always @(posedge clk)
begin
	clkbuf <= {clkbuf[30:0],dedlk};

	if(clkbuf[1:0] == 2'b01)
	begin
	
			r3<=r2;
			r2<=r1;
			r1<=r0;
			r0<={code2,code1};
			decode<=r[3];
			if({code2,code1}==1 && r3==1 && r2==0 && r0==0 && r1==0 && flag1==1)
			 begin
			  r<=0;
			  flag1<=0;
			 end
			else if({code2,code1}==2 && r3==2 && r2==0 && r0==0 && r1==0 && flag1==0)
				begin
				r<=0;
				flag1<=1;
				end
			else if({code2,code1}==1 && r2==1 && r0==0 && r1==0 && r3==2 && flag1==1)
				 begin
				  r<=0;
				  flag1<=0;
				 end
			else if({code2,code1}==2 && r2==2 && r0==0 && r1==0 && r3==1 && flag1==0)
				begin
				r<=0;
				flag1<=1;
				end
			else if({code2,code1}==0)
				 begin 
				  r<={r[2:0],1'b0};
				 end
			else
				 begin 
				  r<={r[2:0],1'b1};
				 end
		end
end

endmodule
