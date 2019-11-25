module MILLER(
					input wire clk,
					input wire reset_n,			
					input wire reg1,//编码类型
					input wire reg2,//编码时钟
					input wire dataclk,
					input wire data,
					output reg ocode1,
					output reg ocode2
					
);

reg[1:0] flag;//记录上一个编码
reg dclk,dclk1,dclk2;
always @(posedge clk)begin
	dclk <= dataclk;
	dclk1 <= dclk;
	dclk2 <= dclk1;
	if(dclk2 == 1 && dclk1 == 0)
	begin
		if(data == 1)begin
			case(flag)
			2'b00:begin ocode1 <= 1;ocode2 <= 0;end//
			2'b01:begin ocode1 <= 1;ocode2 <= 0;end
			2'b10:begin ocode1 <= 0;ocode2 <= 1;end
			2'b11:begin ocode1 <= 0;ocode2 <= 1;end
			endcase
		end
		else
		begin
			case(flag)
			2'b00:begin ocode1 <= 0;ocode2 <= 1;end
			2'b01:begin ocode1 <= 0;ocode2 <= 1;end
			2'b10:begin ocode1 <= 1;ocode2 <= 0;end
			2'b11:begin ocode1 <= 1;ocode2 <= 0;end
			endcase
		end
	end
	else if(dclk2 == 0 && dclk1 == 1)
	begin
		if(data == 1)begin
			case(flag)
			2'b00:begin ocode1 <= 0;ocode2 <= 1;flag <= 2'b01;end
			2'b01:begin ocode1 <= 0;ocode2 <= 1;flag <= 2'b01;end
			2'b10:begin ocode1 <= 1;ocode2 <= 0;flag <= 2'b10;end
			2'b11:begin ocode1 <= 1;ocode2 <= 0;flag <= 2'b10;end
			endcase
		end
		else
		begin
			case(flag)
			2'b00:begin ocode1 <= 0;ocode2 <= 1;flag <= 2'b11;end
			2'b01:begin ocode1 <= 0;ocode2 <= 1;flag <= 2'b11;end
			2'b10:begin ocode1 <= 1;ocode2 <= 0;flag <= 2'b00;end
			2'b11:begin ocode1 <= 1;ocode2 <= 0;flag <= 2'b00;end
			endcase
		end	
	end
	
end
//////////////
// 0  1  0  1  1  0  0  0  1  1  1  0  1  0  1  1  0 1 0
//11 10 00 01 01 11 00 11 10 10 10 00 01 


endmodule
