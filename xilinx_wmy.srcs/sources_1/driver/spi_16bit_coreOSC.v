 
module spi_16bit_coreOSC(
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

parameter FPP=16;

//assign SCK = div_count[2];

reg [9:0]	count;
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
		SCK <= 1;
		flag <= 1'b0;
		tt <= 0;
	end
	3'd1:
	begin
		sink_ready <= 1'b0;
		if(div_count==FPP-1)
		begin
			div_count <= FPP/2;
			state <= 2'd2;
		end	
		else if(div_count==0)
		begin
			div_count <= div_count + 1'b1;
			MISO <= temp[15];
		   temp <= {temp[14:0],1'b0};
		end
		else
		begin
			div_count <= div_count + 1'b1;
			state <= 2'd1;
		end
		NSS <= 1;
		
//		SCK <= (div_count<=FPP/2-1);
		count <= 0;

	end
	3'd2:
	begin
		NSS <= 0;
		div_count <= div_count + 1'b1;
		SCK <= (div_count>=FPP/2-1);	
		if(div_count==FPP-1)
		begin
			div_count <= 0;
			count <= count + 1'b1;
			if(count==15)				state <= 3'd3;			
		end

		if(div_count==FPP/2-1)
		begin
			MISO <= temp[15];
			temp <= {temp[14:0],1'b0};
		end
		
		//if(div_count==7)	temp <= {temp[30:0],MOSI};
	end
	3'd3:
	begin
		NSS <= 1;
		SCK <= 1;
		flag <= 1'b0;
		tt <= tt + 1'b1;		
		if(tt==FPP)	state <= 0;
	end
	endcase
end


endmodule
				