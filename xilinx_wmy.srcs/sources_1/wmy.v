module wmy(
				input wire clk,
				input wire reset_n,			
				input wire[7:0] reg01,//时钟速率
				input wire[7:0] reg02,//码长设置
				input wire[7:0] reg03,//误码数设置
				input wire      reg04,//重新同步
 				input wire  [15:0]    baseband_sw16,//重新同步
 
				input wire wmy_i,     //误码仪输入(可能比误码仪输入晚)
				input wire wmy_clk_i,     //误码仪输入(可能比误码仪输入晚)
				input wire wmy_clk_e,     //误码仪输入(可能比误码仪输入晚)
				input wire recv_edge,     //误码仪输入(可能比误码仪输入晚)
				input wire send_edge,     //误码仪输入(可能比误码仪输入晚)
 
				output wire wmy_o,    //误码仪输出
				output wire wmy_clk_o,//误码仪时钟输出
				output reg data_c,    //收码计数脉冲
				output reg wm_c,       //误码计数脉冲
				output   sonyc_led,       //误码计数脉冲

				input wmy_run,	//运行1，停止0
				input   wmy_pause,//暂停0，继续1

				output [47:0]data_count,//收码计数值
				output [47:0]wmy_count,//误码计数值
				output [31:0]wmy_time_500ms,//误码计时
            output  data_wmy_count_valid//误码仪计数有效，每格500ms计算一次
					
					
);

wire[7:0] CLK_REG = reg01;//误码仪时钟
wire[7:0] MLEN_REG = reg02;//误码仪m序列长度
wire[7:0] WM_REG = reg03;//误码仪插入错误

 

reg jd_clk_pre;
reg jd_clk_pre0;
reg jd_clk_pre1;
reg jd_clk_pre2;
reg jd_clk_pre3;
reg jd_clk; 
reg data_valid;
reg [15:0]data_valid_delay; 
always @(posedge clk)begin
	 jd_clk_pre<=wmy_clk_e;
	 jd_clk_pre0<=jd_clk_pre;
	 jd_clk_pre1<=jd_clk_pre0;
	 if(send_edge==0)	  
		jd_clk_pre2<=jd_clk_pre1;
	 else
		jd_clk_pre2<=~jd_clk_pre1;	 
	 jd_clk_pre3<=jd_clk_pre2;
	if({jd_clk_pre0,jd_clk_pre}==2'b01)
		data_valid<=1;
	else
		data_valid<=0;
		
		data_valid_delay[15:0]<={data_valid_delay[14:0],data_valid};
		
end

////////////////////////////////////////////////////////////////
//M序列产生
wire PN15,PN31,PN511,PN1023,PN2047,SW16;
PN15 PN_gen_inst2(
					.clk(clk),
					.reset_n(reset_n),			
					.valid(data_valid),
					.reg3(baseband_sw16),
					.SW16(SW16),
					.PN15(PN15),
					.PN31(PN31),
					.PN511(PN511),
					.PN1023(PN1023),
					.PN_seq(PN_seq),
					.PN2047(PN2047)
);
wire[26:0]PN_seq;
///////////////////////////////////////////////////////////////////
reg WM_NO_ERROR;
always @(posedge clk)
begin
	if(data_valid_delay[0])
		WM_NO_ERROR <= PN_seq[MLEN_REG];  
end


////////////////////////////////////////////////////////////////
//插入错误
reg WM_INSERT_ERROR;
reg[20:0] INSERT_Count;
reg[7:0] ErrorRegTmp;
always @(posedge clk)
	if(data_valid_delay[1])
	begin
		ErrorRegTmp <= WM_REG;
		if(ErrorRegTmp != WM_REG)
		begin
				INSERT_Count <= 0;
				WM_INSERT_ERROR <= WM_NO_ERROR;
		end
		else
		begin
		case(WM_REG)//插入误码
		0:
		begin
			WM_INSERT_ERROR <= WM_NO_ERROR;
		end
		1:
		begin
			if(INSERT_Count == 1000-1)
				begin
					INSERT_Count <= 0;
					WM_INSERT_ERROR <= WM_NO_ERROR ^ 1'b1;
				end
			else
				begin
					INSERT_Count <= INSERT_Count + 1'b1;
					WM_INSERT_ERROR <= WM_NO_ERROR;
				end
		end
		2:
		begin
			if(INSERT_Count == 10000-1)	
				begin
					INSERT_Count <= 0;
					WM_INSERT_ERROR <= WM_NO_ERROR ^ 1'b1;
				end
			else
				begin
					INSERT_Count <= INSERT_Count + 1'b1;
					WM_INSERT_ERROR <= WM_NO_ERROR;
				end
		end		
		3:
		begin
			if(INSERT_Count == 100000-1)	
				begin
					INSERT_Count <= 0;
					WM_INSERT_ERROR <= WM_NO_ERROR ^ 1'b1;
				end
			else
				begin
					INSERT_Count <= INSERT_Count + 1'b1;
					WM_INSERT_ERROR <= WM_NO_ERROR;
				end
		end
		4:
		begin
			if(INSERT_Count == 1000000-1)	
				begin
					INSERT_Count <= 0;
					WM_INSERT_ERROR <= WM_NO_ERROR ^ 1'b1;
				end
			else
				begin
					INSERT_Count <= INSERT_Count + 1'b1;
					WM_INSERT_ERROR <= WM_NO_ERROR;
				end
		end		
		default:
		begin
			WM_INSERT_ERROR <= WM_NO_ERROR;
		end
		endcase
		end
end



assign wmy_o = WM_INSERT_ERROR;
assign wmy_clk_o = jd_clk_pre3;

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
reg[1:0] clkbuf;
reg      clk_valid;
always @(posedge clk)begin
	clkbuf <= {clkbuf[0],wmy_clk_i};
	if((clkbuf == 2'b10 &&	  recv_edge ==0)||
   	(clkbuf == 2'b01 &&	  recv_edge ==1))
		clk_valid <= 1'b1;
	else
		clk_valid <= 1'b0;
end

////////////////////////////////////////////////////////////////
//误码同步及检测
reg[25:0]  WMbuf;

reg[7:0] reg01_buf = 8'h01;
reg[7:0] reg02_buf = 8'h00;
reg[7:0] reg03_buf = 8'h00;
reg      reg04_buf = 1'b0;
reg      reg04_buf1 = 1'b0;


always @(posedge clk)
begin
	if(clk_valid)
		WMbuf <= {WMbuf[25:0],wmy_i};//缓存误码仪输入的数据
end
	reg[3:0] count_data;
reg[3:0] ST;
reg[25:0]  Mbuf;
reg[3:0]  Buf_cnt;
reg[10:0] Ccount;
reg[10:0] WMcount;
reg  sonyc;
always @(posedge clk)
begin

	if(wmy_run==0)begin
				ST <= 0;
				Mbuf[25:0]<=26'b11_1111_1111_1111_1111_1111_1111;
 				Ccount<=0;	
				wm_c <=   1'b0;        //误码计数	
				data_c <= 1'b0;        //收码计数	
				Buf_cnt <= 0;
				WMcount <= 0;
	end//wmy_run = 1
//	else if(sonyc_lost==0)
//	begin
//			ST <= 0;
//			Mbuf[10:0]<=11'b111_1111_1111;	
//	end	
	else
	begin

		case(ST)
		0://初始状态
		if(clk_valid)
		begin
		
			reg04_buf <= reg04;
			reg04_buf1 <= reg04_buf;
			
			if((reg04_buf ^ reg04_buf1))
			begin
				ST <= 0;
				Mbuf[25:0]<=26'b11_1111_1111_1111_1111_1111_1111;
			end
			
		   else 	if(
			        (MLEN_REG==0&&Mbuf[25:0] == 0) || 
					  (MLEN_REG==1&&Mbuf[25:0] == 26'b11_1111_1111_1111_1111_1111_1111) || 
					  (MLEN_REG==2&&Mbuf[1:0] == 1) ||
					  (MLEN_REG==	3	&&Mbuf[	2	:0] == 1)  || 
					  (MLEN_REG==	4	&&Mbuf[	3	:0] == 1)  || 
					  (MLEN_REG==	5	&&Mbuf[	4	:0] == 1)  || 
					  (MLEN_REG==	6	&&Mbuf[	5	:0] == 1)  || 
					  (MLEN_REG==	7	&&Mbuf[	6	:0] == 1)  || 
					  (MLEN_REG==	8	&&Mbuf[	7	:0] == 1)  || 
					  (MLEN_REG==	9	&&Mbuf[	8	:0] == 1)  || 
					  (MLEN_REG==	10	&&Mbuf[	9	:0] == 1)  || 
					  (MLEN_REG==	11	&&Mbuf[	10	:0] == 1)  || 
					  (MLEN_REG==	12	&&Mbuf[	11	:0] == 1)  || 
					  (MLEN_REG==	13	&&Mbuf[	12	:0] == 1)  || 
					  (MLEN_REG==	14	&&Mbuf[	13	:0] == 1)  || 
					  (MLEN_REG==	15	&&Mbuf[	14	:0] == 1)  || 
					  (MLEN_REG==	16	&&Mbuf[	15	:0] == 1)  || 
					  (MLEN_REG==	17	&&Mbuf[	16	:0] == 1)  || 
					  (MLEN_REG==	18	&&Mbuf[	17	:0] == 1)  || 
					  (MLEN_REG==	19	&&Mbuf[	18	:0] == 1)  || 
					  (MLEN_REG==	20	&&Mbuf[	19	:0] == 1)  || 
					  (MLEN_REG==	21	&&Mbuf[	20	:0] == 1)  || 
					  (MLEN_REG==	22	&&Mbuf[	21	:0] == 1)  || 
					  (MLEN_REG==	23	&&Mbuf[	22	:0] == 1)  || 
					  (MLEN_REG==	24	&&Mbuf[	23	:0] == 1)  || 
					  (MLEN_REG==	25	&&Mbuf[	24	:0] == 1)   ||  
					  
					  (MLEN_REG==	26	&&Mbuf[	15	:0] == baseband_sw16[15:0])  
					  )
			begin
				Ccount<=0;	
				ST <= 1;
				Buf_cnt <= 0;
				WMcount <= 0;
					      count_data <= 15;
			end
			else
			begin
				Mbuf[25:0] <= {Mbuf[24:0],wmy_i};
				Buf_cnt <= Buf_cnt + 1'b1;
			end
		end
		1://搜索同步状态
		if(clk_valid)
		begin
			      count_data <= count_data - 1'b1;
			reg04_buf <= reg04;
			reg04_buf1 <= reg04_buf;
			
			if((reg04_buf ^ reg04_buf1))
			begin
				ST <= 0;
				Mbuf[25:0]<=26'b11_1111_1111_1111_1111_1111_1111;
			end
			else
			begin
		
				case(MLEN_REG)
					0:Mbuf[0] <= 0;
					1:Mbuf[0] <= 1; 
			 
					2:Mbuf[0] <= Mbuf[1] + Mbuf[0]; 
					3:Mbuf[0] <= Mbuf[2] + Mbuf[0]; 
					4:Mbuf[0] <= Mbuf[3] + Mbuf[0]; 
					5:Mbuf[0] <= Mbuf[4] + Mbuf[1]; 
					6:Mbuf[0] <= Mbuf[5] + Mbuf[0]; 
					7:Mbuf[0] <= Mbuf[6] + Mbuf[2]; 
					8:Mbuf[0] <= Mbuf[7] + Mbuf[3]+ Mbuf[2]+ Mbuf[1]; 
					9:Mbuf[0] <= Mbuf[8] + Mbuf[3] ; 
					10:Mbuf[0] <= Mbuf[9] + Mbuf[2] ; 
					11:Mbuf[0] <= Mbuf[10] + Mbuf[1] ; 
					12:Mbuf[0] <= Mbuf[11] + Mbuf[5]+ Mbuf[3]+ Mbuf[0] ; 
					13:Mbuf[0] <= Mbuf[12] + Mbuf[3]+ Mbuf[2]+ Mbuf[0] ; 
					14:Mbuf[0] <= Mbuf[13] + Mbuf[9]+ Mbuf[5]+ Mbuf[0] ; 
					15:Mbuf[0] <= Mbuf[14] + Mbuf[0]  ; 
					16:Mbuf[0] <= Mbuf[15] + Mbuf[11]+ Mbuf[2]+ Mbuf[0] ; 
					17:Mbuf[0] <= Mbuf[16] + Mbuf[2]  ; 
					18:Mbuf[0] <= Mbuf[17] + Mbuf[6]  ; 
					19:Mbuf[0] <= Mbuf[18] + Mbuf[4]+ Mbuf[1]+ Mbuf[0] ; 
					20:Mbuf[0] <= Mbuf[19] + Mbuf[2] ; 
					21:Mbuf[0] <= Mbuf[20] + Mbuf[1] ; 
					22:Mbuf[0] <= Mbuf[21] + Mbuf[0] ; 
					23:Mbuf[0] <= Mbuf[22] + Mbuf[4] ; 
					24:Mbuf[0] <= Mbuf[23] + Mbuf[6]+ Mbuf[1]+ Mbuf[0] ; 
					25:Mbuf[0] <= Mbuf[24] + Mbuf[2] ;
					
					26:Mbuf[0] <= baseband_sw16[count_data] ;
			 
				endcase
				Mbuf[25:1]<=Mbuf[24:0];				


				if(Ccount == 111)
				begin
					Ccount <= 0;
					WMcount <= 0;
					if(WMcount >= 20)
					begin
						ST <= 0;
					end
					else
					begin
						ST <= 2;
						sonyc<=1;
					end
				end
				else begin
					Ccount <= Ccount + 1'b1;
					if(WMbuf[1] != Mbuf[0])
						WMcount <= WMcount + 1'b1;
				end
			end
		end
		2://误码计数状态
		begin
			if(clk_valid)
			begin
				count_data <= count_data - 1'b1;
				reg04_buf <= reg04;
				reg04_buf1 <= reg04_buf;
				sonyc<=0;
				if((reg04_buf ^ reg04_buf1))
				begin
					ST <= 0;
					Mbuf[25:0]<=26'b11_1111_1111_1111_1111_1111_1111;
				end
				else
				begin
			
					Ccount <= 0;
					case(MLEN_REG)
							0:Mbuf[0] <= 0;
							1:Mbuf[0] <= 1; 
					 
							2:Mbuf[0] <= Mbuf[1] + Mbuf[0]; 
							3:Mbuf[0] <= Mbuf[2] + Mbuf[0]; 
							4:Mbuf[0] <= Mbuf[3] + Mbuf[0]; 
							5:Mbuf[0] <= Mbuf[4] + Mbuf[1]; 
							6:Mbuf[0] <= Mbuf[5] + Mbuf[0]; 
							7:Mbuf[0] <= Mbuf[6] + Mbuf[2]; 
							8:Mbuf[0] <= Mbuf[7] + Mbuf[3]+ Mbuf[2]+ Mbuf[1]; 
							9:Mbuf[0] <= Mbuf[8] + Mbuf[3] ; 
							10:Mbuf[0] <= Mbuf[9] + Mbuf[2] ; 
							11:Mbuf[0] <= Mbuf[10] + Mbuf[1] ; 
							12:Mbuf[0] <= Mbuf[11] + Mbuf[5]+ Mbuf[3]+ Mbuf[0] ; 
							13:Mbuf[0] <= Mbuf[12] + Mbuf[3]+ Mbuf[2]+ Mbuf[0] ; 
							14:Mbuf[0] <= Mbuf[13] + Mbuf[9]+ Mbuf[5]+ Mbuf[0] ; 
							15:Mbuf[0] <= Mbuf[14] + Mbuf[0]  ; 
							16:Mbuf[0] <= Mbuf[15] + Mbuf[11]+ Mbuf[2]+ Mbuf[0] ; 
							17:Mbuf[0] <= Mbuf[16] + Mbuf[2]  ; 
							18:Mbuf[0] <= Mbuf[17] + Mbuf[6]  ; 
							19:Mbuf[0] <= Mbuf[18] + Mbuf[4]+ Mbuf[1]+ Mbuf[0] ; 
							20:Mbuf[0] <= Mbuf[19] + Mbuf[2] ; 
							21:Mbuf[0] <= Mbuf[20] + Mbuf[1] ; 
							22:Mbuf[0] <= Mbuf[21] + Mbuf[0] ; 
							23:Mbuf[0] <= Mbuf[22] + Mbuf[4] ; 
							24:Mbuf[0] <= Mbuf[23] + Mbuf[6]+ Mbuf[1]+ Mbuf[0] ; 
							25:Mbuf[0] <= Mbuf[24] + Mbuf[2] ;
					 
					 		26:Mbuf[0] <= baseband_sw16[count_data] ;
					endcase
					Mbuf[25:1]<=Mbuf[24:0];				

				
					data_c <= 1;        //收码计数	
					if(WMbuf[1] != Mbuf[0])
						wm_c <= 1'b1;
				end
			end
			else
			begin 
					wm_c <=   1'b0;        //误码计数	
					data_c <= 1'b0;        //收码计数	 
			end
			
		end
		default:
		begin
				ST <= 0;
				Mbuf[25:0]<=26'b11_1111_1111_1111_1111_1111_1111;
		end
		endcase
	end 
end

assign sonyc_led=((ST==2)&&sonyc_lost);
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

reg sonyc_lost;

reg data_c_pre;
reg wm_c_pre;
reg [47:0]count_500ms;//
reg [47:0]count_c_pre;
reg [47:0]count_wm_c_pre;
reg [31:0]wmy_time;
reg [47:0]count_c_delta;
reg [47:0]count_wm_c_delta; 

reg [47:0]count_wm_c;
reg [47:0]count_c;
reg       count_valid;
always @(posedge clk)
begin

	if(wmy_run==0)begin

		count_500ms <= 0;		
		count_c_pre <= 0 ;
		count_wm_c_pre <= 0;		
		count_c <= 0 ;
		count_wm_c <= 0;
		count_valid <= 0;	
		wmy_time<=0;
		sonyc_lost<=1;
	end//wmy_run = 1
	else
	begin	
	if(count_wm_c_delta[45:0]>count_c_delta[47:2])//不能正常工作
		begin
			sonyc_lost<=0;			
		end
		else
			sonyc_lost<=1;	
	
		 if(count_500ms==131071999)
		 begin		 
			count_500ms <= 0;
		   //get data;
			count_wm_c <= count_wm_c_pre;
			count_c <= count_c_pre;
		 			count_c_delta <= count_c_pre - count_c;
		 			count_wm_c_delta <= count_wm_c_pre - count_wm_c;			

				
			if(wmy_pause) begin
				count_valid <= 1;	
				wmy_time	<= wmy_time + 1;
			end
		 end
		 else if(sonyc)//同步后是否清零问题
		 begin
			count_500ms <= 0;
		 end
		 else
		 begin
//		 	count_c_delta <= 0;
//		 	count_wm_c_delta <= 0;	
			if(wmy_pause) 
				count_500ms <= count_500ms+1;
			count_valid <= 0;	
		 end 

		 if(wm_c==1 && wmy_pause) 
		  count_wm_c_pre <= count_wm_c_pre + 1;
		 
		 if(data_c==1 && wmy_pause) 
		  count_c_pre <= count_c_pre + 1;
		end
	end//wmy_run = 0	
	
	assign  data_count = count_c;
	assign  wmy_count = count_wm_c;
	assign  data_wmy_count_valid = count_valid;
	assign  wmy_time_500ms = wmy_time;
	
endmodule


//		0:Mbuf[0] <= 0;
// 	1:Mbuf[0] <= 1; 
// 
//		2:Mbuf[0] <= Mbuf[1] + Mbuf[0]; 
//		3:Mbuf[0] <= Mbuf[2] + Mbuf[0]; 
//		4:Mbuf[0] <= Mbuf[3] + Mbuf[0]; 
//		5:Mbuf[0] <= Mbuf[4] + Mbuf[1]; 
//		6:Mbuf[0] <= Mbuf[5] + Mbuf[0]; 
//		7:Mbuf[0] <= Mbuf[6] + Mbuf[2]; 
//		8:Mbuf[0] <= Mbuf[7] + Mbuf[3]+ Mbuf[2]+ Mbuf[1]; 
//		9:Mbuf[0] <= Mbuf[8] + Mbuf[3] ; 
//		10:Mbuf[0] <= Mbuf[9] + Mbuf[2] ; 
//		11:Mbuf[0] <= Mbuf[10] + Mbuf[1] ; 
//		12:Mbuf[0] <= Mbuf[11] + Mbuf[5]+ Mbuf[3]+ Mbuf[0] ; 
//		13:Mbuf[0] <= Mbuf[12] + Mbuf[3]+ Mbuf[2]+ Mbuf[0] ; 
//		14:Mbuf[0] <= Mbuf[13] + Mbuf[9]+ Mbuf[5]+ Mbuf[0] ; 
//		15:Mbuf[0] <= Mbuf[14] + Mbuf[0]  ; 
//		16:Mbuf[0] <= Mbuf[15] + Mbuf[11]+ Mbuf[2]+ Mbuf[0] ; 
//		17:Mbuf[0] <= Mbuf[16] + Mbuf[2]  ; 
//		18:Mbuf[0] <= Mbuf[17] + Mbuf[6]  ; 
//		19:Mbuf[0] <= Mbuf[18] + Mbuf[4]+ Mbuf[1]+ Mbuf[0] ; 
//		20:Mbuf[0] <= Mbuf[19] + Mbuf[2] ; 
//		21:Mbuf[0] <= Mbuf[20] + Mbuf[1] ; 
//		22:Mbuf[0] <= Mbuf[21] + Mbuf[0] ; 
//		23:Mbuf[0] <= Mbuf[22] + Mbuf[4] ; 
//		24:Mbuf[0] <= Mbuf[23] + Mbuf[6]+ Mbuf[1]+ Mbuf[0] ; 
//		25:Mbuf[0] <= Mbuf[24] + Mbuf[2] ;
// 
 
 


//		dn2[0] <= dn2[1] + dn2[0]; 
//		dn3[0] <= dn3[2] + dn3[0]; 
//		dn4[0] <= dn4[3] + dn4[0]; 
//		dn5[0] <= dn5[4] + dn5[1]; 
//		dn6[0] <= dn6[5] + dn6[0]; 
//		dn7[0] <= dn7[6] + dn7[2]; 
//		dn8[0] <= dn8[7] + dn8[3]+ dn8[2]+ dn8[1]; 
//		dn9[0] <= dn9[8] + dn9[3] ; 
//		dn10[0] <= dn10[9] + dn10[2] ; 
//		dn11[0] <= dn11[10] + dn11[1] ; 
//		dn12[0] <= dn12[11] + dn12[5]+ dn12[3]+ dn12[0] ; 
//		dn13[0] <= dn13[12] + dn13[3]+ dn13[2]+ dn13[0] ; 
//		dn14[0] <= dn14[13] + dn14[9]+ dn14[5]+ dn14[0] ; 
//		dn15[0] <= dn15[14] + dn15[0]  ; 
//		dn16[0] <= dn16[15] + dn16[11]+ dn16[2]+ dn16[0] ; 
//		dn17[0] <= dn17[16] + dn17[2]  ; 
//		dn18[0] <= dn18[17] + dn18[6]  ; 
//		dn19[0] <= dn19[18] + dn19[4]+ dn19[1]+ dn19[0] ; 
//		dn20[0] <= dn20[19] + dn20[2] ; 
//		dn21[0] <= dn21[20] + dn21[1] ; 
//		dn22[0] <= dn22[21] + dn22[0] ; 
//		dn23[0] <= dn23[22] + dn23[4] ; 
//		dn24[0] <= dn24[23] + dn24[6]+ dn24[1]+ dn24[0] ; 
//		dn25[0] <= dn25[24] + dn25[2] ;












