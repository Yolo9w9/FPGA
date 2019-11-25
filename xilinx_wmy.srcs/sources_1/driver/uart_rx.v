module uart_rx(
					input wire rx,
					input wire reset_n,
					input wire clk,
					output reg [15:0]	address,
					output reg write,
					output reg [15:0]	wdata,
					output reg start_rx
);
					
					
reg valid;
reg [7:0]	data;					

					
//parameter BAUD=2184533;
//
//parameter [31:0]	NCO = 143165576;

//parameter BAUD=2*1024*1000;

parameter [31:0]	NCO = 7549747/2;//85899340.27777778;//4947802;
reg [31:0]	phase;
reg [31:0]	prephase;

reg rx0;
//output reg start_rx;
reg start_sample;
reg start_cc;
always@(posedge clk)
begin
	rx0 <= rx;
	if(rx0==1'b1 && rx==1'b0)		start_rx <= 1'b1;
	else									start_rx <= 1'b0;
	
	
	if(phase[31]==1 && prephase[31]==0)	start_sample <= 1'b1;
	else											start_sample <= 1'b0;
	
	if(phase[31]==0 && prephase[31]==1)	start_cc <= 1'b1;
	else											start_cc <= 1'b0;
		
	
	
end

reg [7:0]	rr;
reg [1:0]	state;
reg [3:0]	count;
always@(posedge clk)
begin
	case(state)
	2'd0:
	begin
		if(start_rx)	state <= 2'd1;
		phase <= 0;
		prephase <= 0;
		count <= 0;
		valid <= 0;
	end
	2'd1:
	begin
		prephase <= phase;
		phase <= phase + NCO;
		if(start_sample)	
		begin
			//rr <= {rx,rr[8:1]};
			rr <= {rx,rr[7:1]};
			count <= count + 1;
			if(count==9)
			begin
				//state <= 2'd0;
				valid <= 1'b1;
				data <= rr;
			end	
			else
			begin
				valid <= 1'b0;
			end
			if(count==9)	state <= 2'd0;
		end
		else
		begin
			valid <= 1'b0;
		end

	end
	endcase
end

reg [3:0]	ST;

parameter RX_LENGTH = 48;
reg [7:0]	rx_count;




//帧头	功能字	帧长	帧计数	data	描述
//0x7E7E	0x0000	6		Card	Chip	address	wdata	写寄存器
//2 byte	2 byte	2 byte	2 byte	0x00	0x00	2 byte	2 byte	
//0x7E7E	0x0001	6		Card	Chip	address	wdata	读寄存器
//2 byte	2 byte	2 byte	2 byte	0x00	0x00	2 byte	2 byte	


reg [7:0]	r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13 /* synthesis noprune */;
reg valid0;

always@(posedge clk)
begin
	if(valid)
	begin
		r0 <= data;
		r1 <= r0;
		r2 <= r1;
		r3 <= r2;
		r4 <= r3;
		r5 <= r4;
		r6 <= r5;
		r7 <= r6;
		r8 <= r7;
		r9 <= r8;
		r10 <= r9;
		r11 <= r10;
		r12 <= r11;
		r13 <= r12;
		valid0 <= 1;
	end
	else
	begin
		valid0 <= 0;
	end
	
	
	if(valid0==1)
	begin
		if({r13,r12}==16'h7e7e && {r11,r10}==16'h0000)
		begin
			address <= {r2,r3};
			wdata <= {r0,r1};
			write <= 1;
		end
		else
		begin
			write <= 0;
		end
		
	end
	else
	begin
		write <= 0;
	end
end

	
endmodule
