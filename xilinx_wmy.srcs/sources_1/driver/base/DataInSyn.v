module DataInSyn(
					input wire clk,
					input wire[7:0] rate,
 					input wire[31:0 ]NCO,//时钟
					input wire DataIn1,
					input wire DataIn2,
					output reg Dataout1,
					output reg Dataout2
);

initial
begin
ST1<=0;
ST2<=0;
end
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

reg [30:0]COUNT_HALF_CLOCK;

always @(posedge clk)
begin
		COUNT_HALF_CLOCK <= (NCO>>1)-1;	
end






reg[1:0] D1buf;
reg[20:0] Dcount1;
reg[1:0] ST1;
always @(posedge clk)begin
		D1buf <= {D1buf[0:0],DataIn1};
	case(ST1)
	2'b00:
	begin

		Dataout1 <= D1buf[1];
		Dcount1 <= 1'b0;
		if(D1buf == 2'b10)
			ST1 <= 2'b01;
	end
	2'b01:
	begin
		if(Dcount1 == COUNT_HALF_CLOCK)begin
				Dataout1 <= 1'b1;
				ST1 <=2'b00;				
		end
		else
			Dcount1 <= Dcount1 + 1'b1;
	end	
	endcase	
end



reg[1:0] D2buf;
reg[30:0] Dcount2;
reg[1:0] ST2;
always @(posedge clk)begin
		D2buf <= {D2buf[0],DataIn2};
	case(ST2)
	2'b00:
	begin

		Dataout2 <= D2buf[1];
		Dcount2 <= 1'b0;
		if(D2buf == 2'b10)
			ST2 <= 2'b01;
	end
	2'b01:
	begin
		if(Dcount2 == COUNT_HALF_CLOCK)begin
				Dataout2 <= 1'b1;
				ST2 <=2'b00;				
		end
		else
			Dcount2 <= Dcount2 + 1'b1;
	end	
	endcase	
end


endmodule
