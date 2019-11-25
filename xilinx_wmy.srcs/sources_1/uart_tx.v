module uart_tx(
					output reg tx,
					input wire clk,
					input wire valid,
					input wire [7:0]	data,
					input wire parity,
					output reg busy
);
										
//parameter BAUD=115200;

 parameter [31:0]	NCO = 7549747/2;//4947802;


reg [31:0]	phase;
reg [31:0]	prephase;

reg rx0;
reg start_rx;
reg start_sample;
reg start_cc;
always@(posedge clk)
begin

	if(phase[31]== 1 && prephase[31]==0)	start_sample <= 1'b1;
	else											start_sample <= 1'b0;
	
	if(phase[31]==0 && prephase[31]==1)	start_cc <= 1'b1;
	else											start_cc <= 1'b0;
		
	
	
end

reg [9:0]	rr;
reg [1:0]	state;
reg [3:0]	count;
reg crc;
reg [7:0]	tx_data;
always@(posedge clk)
begin
	case(state)
	2'd0:
	begin
		if(valid)	begin state <= 2'd1;busy <= 1'b1;tx_data<=data;end
		else			begin busy <= 1'b0;					end
		phase <= 0;
		prephase <= 32'd0;
		count <= 0;
		tx <= 1'b1;
		//crc <= 
	end
	2'd1:
	begin
		prephase <= phase;
		phase <= phase + NCO;
		
		
		if(start_cc)
		begin
			count <= count + 1;
			case(count)
			4'd0:tx <= 1'b0;
			4'd1:tx <= tx_data[0];
			4'd2:tx <= tx_data[1];
			4'd3:tx <= tx_data[2];
			4'd4:tx <= tx_data[3];
			4'd5:tx <= tx_data[4];
			4'd6:tx <= tx_data[5];
			4'd7:tx <= tx_data[6];
			4'd8:tx <= tx_data[7];
			4'd9:tx <= 1'b1;
			4'd10:tx <= 1'b1;
			endcase
			if(count==10)	state <= 2'd0;
		end
	end
	endcase
end


endmodule
