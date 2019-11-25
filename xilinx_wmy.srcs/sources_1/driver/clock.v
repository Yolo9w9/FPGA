  module clock 
 (
 // Clock in ports
  input         clk,          //65.536M
  // Clock out ports
  output        clock_32768k,
  output   reg     valid_32768k,
  output        clock_16384k,
  output   reg      valid_16384k,
  output        clock_8192k,
  output   reg      valid_8192k,
  output        clock_4096k,
  output   reg      valid_4096k,
  output        clock_2048k,
  output    reg     valid_2048k,  
  output        clock_1024k,
  output    reg     valid_1024k,
  output        clock_512k,
  output    reg     valid_512k,
  output        clock_256k,
  output    reg     valid_256k,
  output        clock_128k,
  output    reg     valid_128k,
  output        clock_64k,
  output    reg     valid_64k,
  output        clock_32k,
  output    reg     valid_32k,
  output        clock_16k,
  output     reg    valid_16k,
  output        clock_8k,
  output    reg     valid_8k,
  output        clock_4k,
  output    reg     valid_4k,
  output        clock_2k,
  output    reg     valid_2k
  
 );
  
  
reg [15:0]	div_count;

initial
begin
	div_count <= 0;
end
always@(posedge clk)
begin
	div_count <= div_count + 1;
end



assign clock_32768k = div_count[0];
assign clock_16384k = div_count[1];
assign clock_8192k = div_count[2];
assign clock_4096k = div_count[3];
assign clock_2048k = div_count[4];
assign clock_1024k = div_count[5];
assign clock_512k = div_count[6];
assign clock_256k = div_count[7];
assign clock_128k = div_count[8];
assign clock_64k = div_count[9];
assign clock_32k = div_count[10];
assign clock_16k = div_count[11];
assign clock_8k = div_count[12];
assign clock_4k = div_count[13];
assign clock_2k = div_count[14];



wire  valid_clock_code_in;
initial
begin
	valid_32768k <= 0;
	valid_16384k <= 0;
	valid_8192k <= 0;
	valid_4096k <= 0;
	valid_2048k <= 0;
	valid_1024k <= 0;
	valid_512k <= 0;
	valid_256k <= 0;
	valid_128k <= 0;
	valid_64k <= 0;
	valid_32k <= 0;
	valid_16k <= 0;
	valid_8k <= 0;
	valid_4k <= 0;
	valid_2k <= 0;
end

always@(posedge clk)
begin
	valid_32768k <= (div_count[0]==(1'h1-1));
	valid_16384k <= (div_count[1:0]==(2'h3-1));
	valid_8192k <= (div_count[2:0]==(3'h7-1));
	valid_4096k <= (div_count[3:0]==(4'hf-1));
	valid_2048k <= (div_count[4:0]==(5'h1f-1));
	valid_1024k <= (div_count[5:0]==(6'h3f-1));
	valid_512k <= (div_count[6:0]==(7'h7f-1));
	valid_256k <= (div_count[7:0]==(8'hff-1));
	valid_128k <= (div_count[8:0]==(9'h1ff-1));
	valid_64k <= (div_count[9:0]==(10'h3ff-1));
	valid_32k <= (div_count[10:0]==(11'h7ff-1));
	valid_16k <= (div_count[11:0]==(12'hfff-1));
	valid_8k <= (div_count[12:0]==(13'h1fff-1));
	valid_4k <= (div_count[13:0]==(14'h3fff-1));
	valid_2k <= (div_count[14:0]==(15'h7fff-1));
end
  
endmodule
