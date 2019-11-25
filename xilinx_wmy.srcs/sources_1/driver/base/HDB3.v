module HDB3(
					input wire clk,
					input wire reset_n,			
					input wire reg1,//编码类型
					input wire reg2,//编码时钟
					input wire dataclk,
					input wire data,
					output reg ocode1,
					output reg ocode2					
);

reg flagv;//记录v码极性
reg flagd;//记录1极性

reg[3:0] fdata;

reg[3:0] ST=0;

reg dclk,dclk1,dclk2;
always @(posedge clk)begin
	dclk <= dataclk;
	dclk1 <= dclk;
	dclk2 <= dclk1;
	if(dclk2 == 1 && dclk1 == 0)
	begin
		//fdata <= {fdata[2:0],data};
		case(ST)
		0:
		begin
			if(fdata == 4'b0000)
			begin
				case({flagv,flagd})
				2'b00:begin ocode1 <= 0;ocode2 <= 1;flagd <= ~flagd;end//-- => +1
				2'b01:begin ocode1 <= 0;ocode2 <= 0;end//-+ => 0
				2'b10:begin ocode1 <= 0;ocode2 <= 0;end//+- => 0
				2'b11:begin ocode1 <= 1;ocode2 <= 0;flagd <= ~flagd;end//++ => -1
				endcase
				ST <= 1;
			end
			else if(fdata[3] == 1)
			begin
				if(flagd)begin ocode1 <= 1;ocode2 <= 0; end
				else     begin ocode1 <= 0;ocode2 <= 1; end
				flagd <= ~flagd;
			end
			else
			begin
				ocode1 <= 0;
				ocode2 <= 0;
			end
		end
		1:
		begin
			ocode1 <= 0;
			ocode2 <= 0;
			ST <= 2;
		end
		2:
		begin
			ocode1 <= 0;
			ocode2 <= 0;
			ST <= 3;
		end
		3:
		begin
			if(flagv)begin ocode1 <= 1;ocode2 <= 0;end
			else     begin ocode1 <= 0;ocode2 <= 1;end	
			flagv <= ~flagv;
			ST <= 0;
		end
		endcase
	end	//if(dclk == 0 && dataclk == 1)
	else if(dclk2 == 0 && dclk1 == 1)	
	begin
		fdata <= {fdata[2:0],data};
		ocode1 <= 0;ocode2 <= 0;
	end	
end

endmodule
