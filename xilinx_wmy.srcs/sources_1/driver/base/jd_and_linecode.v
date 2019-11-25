module jd_and_linecode(
input  [7:0] base_type_reg,
input  [7:0] base_freq_reg,
input  [7:0] base_16bit_reg,

output JD_Data,
output JD_Clk,
output CODE1,
output CODE2,
output XDCode,
output jd_valid 


);

//////////////////////////////////////////////////////////////////////////////

jd_gen jd_gen_init1(
			.clk(clk),
			.reset_n(MRESET),
			.reg1(base_type_reg),//基带信号类型
			.reg2(base_freq_reg),//信号频率
			.reg3(base_16bit_reg),//16bit值
			.jd_valid(jd_valid),//使能输出
			.jd_clk(JD_Clk),    //时钟输出
			.jd_data(JD_Data),   //数据输出
			.jd_xd(XDCode)	    //相对码输出
);

 
LineCode LineCode_init1(
					.clk(clk),
					.reset_n(reset_n),	
					.reg1(base_type_reg),//编码类型
					.dataclk(JD_Clk),
					.data(JD_Data),
					.ocode1(CODE1),
					.ocode2(CODE2)					
);







endmodule

