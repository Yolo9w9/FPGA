module dpll_easy(
				input wire reset_n,
				input wire clk,
				input wire din,
				output reg dclock,
				output reg dvalid);
				
reg [31:0]	phase;

reg din0;
reg edge_flag;

reg [15:0]	count;

always@(posedge clk)
begin
	din0 <= din;
	edge_flag <= (din0 ^ din);
end


always@(posedge clk)
begin
	if(edge_flag)
	begin
		count <= 0;
	end
	else
	begin
		if(count==63)	count <= 0;
		else				count <= count + 1;
	end
	
	
	dclock <= count[5];//7 127 254 要改
	dvalid <= count[5:0]==31;
end

endmodule


