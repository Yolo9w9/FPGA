module BRZ(
					input wire clk,
					input wire reset_n,			
					input wire reg1,//编码类型
					input wire reg2,//编码时钟
					input wire dataclk,
					input wire data,
					output reg ocode1,
					output reg ocode2
					
);

reg dclk,dclk1,dclk2;
always @(posedge clk)begin
	dclk <= dataclk;
	dclk1 <= dclk;
	dclk2 <= dclk1;
	if(dclk2 == 1 && dclk1 == 0)
	begin
		if(data == 1)begin
			ocode1 <= 0;
			ocode2 <= 1;
		end
		else
		begin
			ocode1 <= 1;
			ocode2 <= 0;
		end	
	end
	else if(dclk2 == 0 && dclk1 == 1)
	begin
		ocode1 <= 0;
		ocode2 <= 0;
	end
end

endmodule
