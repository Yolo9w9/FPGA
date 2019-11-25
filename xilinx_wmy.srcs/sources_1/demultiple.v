module demultiple(
						input wire sclk,
						input wire sd,
						input wire clk,
						input wire reset_n,
						output reg source_valid,
						input wire [7:0]	head,
						
						
						input wire      reg04,//重新同步
						input wmy_run,	//运行1，停�?0
						input   wmy_pause,//暂停0，继�?1	
						
						
						
						output reg [7:0]	source_data0,
						output reg [7:0]	source_data1,
						output reg [7:0]	source_data2,
						output reg [7:0]	source_data3,
						output reg slot_sync,
						
				output [47:0]data_count,//收码计数�?
				output [47:0]wmy_count,//误码计数�?
				output [31:0]wmy_time_500ms,//误码计时
            output  data_wmy_count_valid,//误码仪计数有效，每格500ms计算�?�?		
						
						
						
						output reg FS
						);
			
						
						



						
reg [2:0]	state;						

reg [7:0]	data;
reg 			valid;
reg [7:0]	count;
reg find_frame_head;	
reg [4:0]	cnt;




reg valid0;
reg [7:0]	data0;
reg sop0;
reg eop0;


initial
begin
	state = 0;
	data = 0;
	valid = 0;
	count = 0;
	find_frame_head = 0;
	cnt = 0;
	valid0 = 0;
	data0 = 0;
	sop0 = 0;
	eop0 = 0;
	FS = 0;
	slot_sync = 0;
	
end

reg      reg04_buf = 1'b0;
reg      reg04_buf1 = 1'b0;

reg preFS;
always@(posedge sclk)
	if(wmy_run==0)begin
		state <= 0;	
				find_frame_head <= 1'b0;	
		slot_sync <= 1'b0;	
	end//wmy_run = 1
 
	else
	begin

	preFS <=   (data[6:0]==head[6:0]) && (count==8);
	FS <= (slot_sync) && preFS;
	data <= {data[6:0],sd};
	
	data0 <= data;
	valid0 <= valid;
	sop0 <= valid && (cnt==0);
	eop0 <= valid && (cnt==31);
	
	
	if(count[2:0]==7)	
	begin
		valid <= 1'b1;
		cnt <= count[7:3];
	end
	else
	begin
		valid <= 1'b0;
	end

	if(find_frame_head)	count <= 10;
	else						count <= count + 1;
	
	
	reg04_buf <= reg04;
	reg04_buf1 <= reg04_buf;
			
	if((reg04_buf ^ reg04_buf1))
	begin
		state <= 0;	
		find_frame_head <= 1'b0;	
		slot_sync <= 1'b0;				 
	end
	else
	
	case(state)
	3'd0:
	begin
		if(data[6:0]==head[6:0])
		begin
		   slot_sync <= 1'b1;
			find_frame_head <= 1'b1;
			state <= 3'd1;
		end
		else
		begin
		   slot_sync <= 1'b0;
			find_frame_head <= 1'b0;
			state <= 3'd0;		
			slot_sync <= 1'b0;	
		end
		
	end
	3'd1:
	begin
		find_frame_head <= 1'b0;
		if(count==8)
		begin
				state <= 3'd2;			
		end
	end
	3'd2:
	begin
		if(count==8)
		begin
			if(data[6:0]==head[6:0])		begin slot_sync <= 1'b1;state <= 3'd3;end
			else					begin slot_sync <= 1'b0; state <= 3'd0;end
		end	
	end
	3'd3:
	begin
		find_frame_head <= 1'b0;
		if(count==8)
		begin
				state <= 3'd4;			
		end
	end
	3'd4:
	begin
		if(count==8)
		begin
			if(data[6:0]==head[6:0])		begin slot_sync <= 1'b1;state <= 3'd3;end
			else			begin slot_sync <= 1'b0;state <= 3'd1;end		//begin state <= 3'd1;end
		end	
	end	
	
	
	

	endcase
	
	
end



 

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
reg [5:0]sclk_dly;
reg [5:0]FS_dly;
always @(posedge clk)
begin

sclk_dly<={sclk_dly,sclk};
FS_dly<={FS_dly,FS};

	if(wmy_run==0)begin

		count_500ms <= 0;		
		count_c_pre <= 0 ;
		count_wm_c_pre <= 0;		
		count_c <= 0 ;
		count_wm_c <= 0;
		count_valid <= 0;	
		wmy_time<=0;
 
	end//wmy_run = 1
	else
	begin	
 
		 if(count_500ms==131071999)
		 begin		 
			count_500ms <= 0;
		   //get data;
			count_wm_c <= count_c_pre[47:8]-(count_wm_c_pre==0?0:(count_wm_c_pre+2));
			count_c <= count_c_pre[47:8];
 

				
			if(wmy_pause) begin
				count_valid <= 1;	
				wmy_time	<= wmy_time + 1;
			end
		 end
//		 else if(state == 0;)//同步后是否清零问�?
//		 begin
//			count_500ms <= 0;
//		 end
		 else
		 begin
//		 	count_c_delta <= 0;
//		 	count_wm_c_delta <= 0;	
			if(wmy_pause) 
				count_500ms <= count_500ms+1;
			count_valid <= 0;	
		 end 

		 if(FS_dly[2:1]==2'b01 && wmy_pause) 
		  count_wm_c_pre <= count_wm_c_pre + 2;
		 
		 if(sclk_dly[2:1]==2'b01 && wmy_pause) 
		  count_c_pre <= count_c_pre + 1;
		end
	end//wmy_run = 0	
	
	assign  data_count = count_c;
	assign  wmy_count = count_wm_c;
	assign  data_wmy_count_valid = count_valid;
	assign  wmy_time_500ms = wmy_time;
	



























reg rdreq;
wire [9:0]	demultiple_fifo_q;
wire rdempty;
wire [3:0]	rdusedw;
wire wrfull;

reg aclr;
initial
begin
	rdreq = 0;
	aclr = 0;
end
always@(posedge clk)
begin
	aclr <= (~reset_n) | wrfull && (~slot_sync);
end
//demultiple_fifo demultiple_fifo_inst(
//	.aclr(),
//	.data({sop0,eop0,data0}),
//	.rdclk(clk),
//	.rdreq(rdreq),
//	.wrclk(sclk),
//	.wrreq(valid0),
//	.q(demultiple_fifo_q),
//	.rdempty(rdempty),
//	.wrfull(wrfull),
//	.rdusedw(rdusedw));
	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
fifo_generator_0 fifo_generator_inst0 (
  .clk(clk),                    // input wire clk
   .srst(aclr),                  // input wire srst
  .din({sop0,eop0,data0}),                    // input wire [9 : 0] din
  .wr_en(sclk),                // input wire wr_en
  .rd_en(rdreq),                // input wire rd_en
  .dout(demultiple_fifo_q),                  // output wire [9 : 0] dout
  .full(wrfull),                  // output wire full
 
  .empty(rdempty),                // output wire empty
 
   .data_count(rdusedw) 
);

	
reg valid1;
reg [7:0]	data1;
reg sop1;
reg eop1;

reg [4:0]	channel;
reg sop2,eop2;
reg valid2;
reg [7:0]	data2;


reg [7:0]	d0,d1,d2,d3,d4,d5,d6,d7;
reg valid3;
reg en;

reg [15:0]	ccc;

	
initial
begin
	valid1 = 0;
	data1 = 0;
	sop1 = 0;
	eop1 = 0;
	channel = 0;
	sop2 = 0;
	eop2 = 0;
	valid2 = 0;
	data2 = 0;
	d0 = 0;
	d1 = 0;
	ccc = 0;
end	
always@(posedge clk)
begin
	if(rdusedw[3]==1'b1)	en <= 1'b1;
	
	
	if(ccc==2047)	ccc <= 0;
	else				ccc <= ccc + 1;
	if(ccc==2047)	rdreq <= en;
	else				rdreq <= 0;
	
	
	
	valid1 <= rdreq;
	data1 <= demultiple_fifo_q[7:0];
	sop1 <= demultiple_fifo_q[9];
	eop1 <= demultiple_fifo_q[8];
	
	valid2 <= valid1;
	data2 <= data1;
	sop2 <= sop1;
	eop2 <= eop1;
	if(sop1)
	begin
		channel <= 0;
	end
	else
	begin
		if(valid1)	channel <= channel + 1;
	end
	if(valid2)
	begin
		case(channel)
		5'd0:d0 <= data2;
		5'd1:d1 <= data2;
		5'd2:d2 <= data2;
		5'd3:d3 <= data2;

		endcase
	end	
	valid3 <= eop2 && valid2;
	
	source_valid <= valid3;
	if(valid3 && slot_sync)
	begin
		source_data0 <= d0;
		source_data1 <= d1;
		source_data2 <= d2;
		source_data3 <= d3;
	end
end	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

endmodule

