/***********************************************************
*-- STM32 SPI_通信接口,
*-- FPGA作为主方式
*-- 
*-- 
	clk	   input	1	      时钟，11.0592M*4MHz;
	hold	   input	1	      STM32提供，下降沿通知FPGA采集数据准备好;
	reset_n	input	1	      复位信号，低电平复位，高电平正常工作;
	SCK	   output	1	   SPI时钟信号，4.096MHz，高电平触发，低电平采样;
	MOSI	   input	1	       SPI数据线输入;
	MISO	   output	1	SPI数据线输出;
	NSS	         output	1	SPI启动信号，每次传输16bit数据，先拉高NSS;
	source_valid	output	1	输出信号，AD采样有效信号，采样率64K，每1024个时钟高电平有效;
************************************************************/
module spi_16bit_core(
						input wire clk,
						output reg SCK,
						input wire MOSI,
						output reg MISO,
						output reg NSS,
						output reg sink_ready,
						
						input wire sink_valid,
						input wire [15:0]	sink_data
						);


reg [7:0]	div_count;

parameter FPP=8;

//assign SCK = div_count[2];

reg [5:0]	count;
reg [1:0]	state;
reg [15:0]	temp;
reg flag;
reg [7:0]	tt;
initial
begin
	state = 0;
	div_count = 0;
	NSS = 0;
	SCK = 0;
	flag = 1'b0;
	tt = 0;
	sink_ready = 1'b1;	
end
always@(posedge clk)
begin
	case(state)
	3'd0:
	begin
		if(sink_valid)	
		begin
			state <= 3'd1;	
			temp <= sink_data;
			sink_ready <= 1'b0;
		end
		else
		begin
			sink_ready <= 1'b1;			
		end
		div_count <= 0;
		NSS <= 1;
		SCK <= 0;
		flag <= 1'b0;
		tt <= 0;
	end
	3'd1:
	begin
		sink_ready <= 1'b0;
		if(div_count==FPP-1)
		begin
			div_count <= 0;
			state <= 2'd2;
		end	
		else
		begin
			div_count <= div_count + 1'b1;
			state <= 2'd1;
		end
		NSS <= 1;
		
		SCK <= (div_count<=FPP/2-1);
		count <= 0;
	end
	3'd2:
	begin
		NSS <= 0;
		div_count <= div_count + 1'b1;
		SCK <= (div_count<=FPP/2-1);	
		if(div_count==FPP-1)
		begin
			div_count <= 0;
			count <= count + 1'b1;
			if(count==15)				state <= 3'd3;			
		end

		if(div_count==0)
		begin
			MISO <= temp[15];
			temp <= {temp[14:0],1'b0};
		end
		
		//if(div_count==7)	temp <= {temp[30:0],MOSI};
	end
	3'd3:
	begin
		NSS <= 1;
		SCK <= 0;
		flag <= 1'b0;
		tt <= tt + 1'b1;		
		if(tt==15)	state <= 0;
	end
	endcase
end


endmodule
				