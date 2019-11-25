/**************************************************
*-- 编码类型选择
*-- NRZ
*-- BNRZ
*-- RZ
*-- BRZ
*-- Manchester
*-- MILLER
*-- CMI
*-- PST
*-- AMI
*-- HDB3
**************************************************/

module LineCode(
					input wire clk,
					input wire reset_n,			
					input wire[7:0] reg1,//编码类型
					input wire dataclk,
					input wire data,
					output reg ocode1,
					output reg ocode2		
);


always @(*)begin
	case(reg1)
	1:begin  ocode1 = code11;ocode2 = code21;end
	2:begin  ocode1 = code12;ocode2 = code22;end
	3:begin  ocode1 = code13;ocode2 = code23;end
	4:begin  ocode1 = code14;ocode2 = code24;end
	5:begin  ocode1 = code15;ocode2 = code25;end
	6:begin  ocode1 = code16;ocode2 = code26;end
	7:begin  ocode1 = code17;ocode2 = code27;end
	8:begin  ocode1 = code18;ocode2 = code28;end
	9:begin  ocode1 = code19;ocode2 = code29;end
	10:begin  ocode1 = code110;ocode2 = code210;end
	default:begin  ocode1 = code110;ocode2 = code210;end
	endcase
end

///////////////////////////////////////////////////////////////
//NRZ
wire code11,code21;
NRZ Linecode_inst1(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code11),
					.ocode2(code21)				
);
///////////////////////////////////////////////////////////////
//BNRZ
wire code12,code22;
BNRZ Linecode_inst2(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code12),
					.ocode2(code22)				
);///////////////////////////////////////////////////////////////
//RZ
wire code13,code23;
RZ Linecode_inst3(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code13),
					.ocode2(code23)				
);
///////////////////////////////////////////////////////////////
//BRZ
wire code14,code24;
BRZ Linecode_inst4(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code14),
					.ocode2(code24)				
);
///////////////////////////////////////////////////////////////
//Manchester
wire code15,code25;
Manchester Linecode_inst5(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code15),
					.ocode2(code25)				
);
///////////////////////////////////////////////////////////////
//CMI
wire code16,code26;
CMI Linecode_inst6(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code16),
					.ocode2(code26)				
);
///////////////////////////////////////////////////////////////
//MILLER
wire code17,code27;
MILLER Linecode_inst7(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code17),
					.ocode2(code27)				
);
///////////////////////////////////////////////////////////////
//PST
wire code18,code28;
PST Linecode_inst8(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code18),
					.ocode2(code28)				
);
///////////////////////////////////////////////////////////////
//AMI
wire code19,code29;
AMI Linecode_inst9(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code19),
					.ocode2(code29)				
);
///////////////////////////////////////////////////////////////
//HDB3
wire code110,code210;
HDB3 Linecode_inst10(
					.clk(clk),
					.reset_n(reset_n),			
					.reg1(reg1),//编码类型
					.reg2(),
					.dataclk(dataclk),
					.data(data),
					.ocode1(code110),
					.ocode2(code210)				
);

endmodule

