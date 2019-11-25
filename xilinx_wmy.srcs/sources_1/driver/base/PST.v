module PST(
					input wire clk,
					input wire reset_n,			
					input wire reg1,//编码类型
					input wire reg2,//编码时钟
					input wire dataclk,
					input wire data,
					output reg ocode1,
					output reg ocode2
					
);

reg flag;//记录上一个编码
reg ddata;
reg[1:0] fdata;
reg data_count;

reg dclk,dclk1,dclk2;
always @(posedge clk)begin
	dclk <= dataclk;
	dclk1 <= dclk;
	dclk2 <= dclk1;
	if(dclk2 == 1 && dclk1 == 0)
	begin
		data_count <= data_count + 1'b1;
		ddata <= data;
		if(data_count)
			fdata <= {ddata,data};
		
		case(fdata)
		2'b00:
		begin
			if(data_count == 0) begin ocode1 <= 1; ocode2 <= 0;end
			else                begin ocode1 <= 0; ocode2 <= 1;end
		end
		2'b01:
		begin
			if(flag)
			begin
				if(data_count == 0) begin ocode1 <= 0; ocode2 <= 0;end
				else                begin ocode1 <= 0; ocode2 <= 1;flag <= ~flag;end		
			end
			else
			begin
				if(data_count == 0) begin ocode1 <= 0; ocode2 <= 0;end
				else                begin ocode1 <= 1; ocode2 <= 0;flag <= ~flag;end		
			end			
		end
		2'b10:
		begin
			if(flag)
			begin
				if(data_count == 0) begin ocode1 <= 0; ocode2 <= 1;end
				else                begin ocode1 <= 0; ocode2 <= 0;flag <= ~flag;end		
			end
			else
			begin
				if(data_count == 0) begin ocode1 <= 1; ocode2 <= 0;end
				else                begin ocode1 <= 0; ocode2 <= 0;flag <= ~flag;end		
			end			
		end
		2'b11:
		begin
			if(data_count == 0) begin ocode1 <= 0; ocode2 <= 1;end
			else                begin ocode1 <= 1; ocode2 <= 0;end
		end
		endcase
	end
end

endmodule
