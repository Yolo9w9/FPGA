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

module LineDecode(
					input wire clk,
					input wire reset_n,			
					input wire[7:0] rate,//时钟
					input wire[31:0 ]NCO,//时钟
					input wire[7:0] base_code_type,//译码模式选择
 
					input wire codein1,
					input wire codein2,
					output wire Syn_RHDB31,
					output wire Syn_RHDB32,		
					output reg declk,
					output reg decode		
);
reg valid;
reg[20:0] cnt;
reg[1:0] ddclk;
reg[8:0] Datad;
always @(*)begin
	begin
		case(base_code_type)
		1:begin  declk = declk1;decode =  decode1;end
		2:begin  declk = declk2;decode = decode2;end
		3:begin  declk = declk3;decode = decode3;end
		4:begin  declk = declk4;decode = decode4;end
		5:begin  declk = declk5;decode = decode5;end
		6:begin  declk = declk6;decode = decode6;end
		7:begin  declk = declk7;decode = decode7;end
		8:begin  declk = declk8;decode = decode8;end
		9:begin  declk = declk9;decode = decode9;end
		10:begin  declk = declk10;decode = decode10;end
		default:begin  declk = declk10;decode = decode10;end
		endcase
	end
end

 
 
 ////////////////////////////////////////////////////////////////////////////////

//将收到的RZ信号转换为NRZ信号
DataInSyn DataInSyn_inst_0(
					.clk(clk),
					.rate(rate),
					.NCO(NCO),
					.DataIn1(codein1),
					.DataIn2(codein2),
					.Dataout1(Syn_RHDB31),
					.Dataout2(Syn_RHDB32)
);


  
 
///////////////////////////////////////////////////////////////
//NRZ
wire declk1,decode1;
DeNRZ lineDecode_inst1(
					.clk(clk),
					.reset_n(reset_n),
					.rate(rate),
					.code1(codein1),
					.code2(codein2),
					.dedlk(declk1),
					.decode(decode1)
					
);			
///////////////////////////////////////////////////////////////
//BNRZ
wire declk2,decode2;
DeBNRZ Linecode_inst2(
					.clk(clk),
					.reset_n(reset_n),
					.rate(rate),
					.code1(codein1),
					.code2(codein2),
					.dedlk(declk2),
					.decode(decode2)
);
///////////////////////////////////////////////////////////////
//RZ
wire declk3,decode3;
DeRZ Linecode_inst3(
					.clk(clk),
					.reset_n(reset_n),
					.rate(rate),
					.code1(Syn_RHDB31),
					.code2(Syn_RHDB32),
					.dedlk(declk3),
					.decode(decode3)
);
///////////////////////////////////////////////////////////////
//BRZ
wire declk4,decode4;
DeBRZ Linecode_inst4(
					.clk(clk),
					.reset_n(reset_n),
					.rate(rate),
					.code1(Syn_RHDB31),
					.code2(Syn_RHDB32),
					.dedlk(declk4),
					.decode(decode4)
);
 
///////////////////////////////////////////////////////////////
//Manchester
wire declk5,decode5;
 
DeManchester Linecode_inst5(
					.clk(clk),
 
					.rate(rate),
					.code1(codein1),
					.code2(codein2),
					.dedlk(declk5),
					.decode(decode5)
);
 
 
///////////////////////////////////////////////////////////////
//CMI
wire declk6,decode6;
DeCMI Linecode_inst6(
					.clk(clk),
 
					.rate(rate),
					.code1(codein1),
					.code2(codein2),
					.dedlk(declk6),
					.decode(decode6)
);
  
///////////////////////////////////////////////////////////////
//MILLER
wire declk7,decode7;
DeMILLER Linecode_inst7(
					.clk(clk),
 
					.rate(rate),
					.code1(codein1),
					.code2(codein2),
					.dedlk(declk7),
					.decode(decode7)
);
  
///////////////////////////////////////////////////////////////
//PST
wire declk8,decode8;
DePST Linecode_inst8(
					.clk(clk),
 
					.rate(rate),
					.code1(codein1),
					.code2(codein2),
					.dedlk(declk8),
					.decode(decode8)
); 
 
 
///////////////////////////////////////////////////////////////
//AMI
wire declk9,decode9;
DeAMI Linecode_inst9(
					.clk(clk),
					.reset_n(reset_n),
					.rate(rate),
					.code1(Syn_RHDB31),
					.code2(Syn_RHDB32),
					.dedlk(declk9),
					.decode(decode9)
);
///////////////////////////////////////////////////////////////
//HDB3
wire declk10,decode10;/*keep synthesis*/
DeHDB3 Linecode_inst10(/*keep synthesis*/
					.clk(clk),
 					.NCO(NCO),
					.rate(rate),
					.code1(Syn_RHDB31),
					.code2(Syn_RHDB32),
					.dedlk(declk10),
					.decode(decode10)
);
 

endmodule

