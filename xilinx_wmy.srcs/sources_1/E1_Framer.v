  	  
`timescale 1ns / 1ps   	 

module E1_Framer (
	input	           Clk16M           ,
	input              Rst              , 
 
	input               [6:0]	Frame_Head  , 
	input              Clk_E1           ,
 
	output reg         E1_Data_Out
);

//The CRC-4 generator polynomial: x**0 + x**1 + x**4 
function 	[3:0] CRC4;              
	input 	Di;
	input 	[3:0] CRC_Init; 	 
	reg 	[4:0] In;	   
	integer j;
	begin  		
		In = {CRC_Init, 1'b0};
		
		for (j=4; j>=1; j=j-1)
			begin
				if (j == 2 || j == 1)
					CRC4[j-1] = In[j-1] ^ In[4] ^ Di;
				else
					CRC4[j-1] = In[j-1];
			end	   
	end
endfunction	  
	

parameter	Mulframe_Head = 6'b001011; 	
parameter 	Stuff         = 1'b0;	 

//------------------------------------------
reg    [2:0]  Clk_E1_Dly  ;
reg           En_E1       ;
always @(posedge Clk16M or posedge Rst)//remove metastability
	begin	
		if (Rst)
		    Clk_E1_Dly <= 2'd0;
		else
		    Clk_E1_Dly <= {Clk_E1_Dly[1:0], Clk_E1};
		    
		if (Rst)
		    En_E1 <= 1'b0;
		else
		    En_E1 <= ~Clk_E1_Dly[1] & Clk_E1_Dly[2];//negedge
    end

reg	   [2:0]   Bit_Cnt          ;
reg	   [4:0]   Slot_Cnt         ;
reg	   [3:0]   Frame_Cnt        ;

always @(posedge Clk16M or posedge Rst)
	begin	
		if (Rst)
		    Bit_Cnt <= 0;
		else if (En_E1)
		    Bit_Cnt <= Bit_Cnt + 1;
		        
		if (Rst)
		    Slot_Cnt <= 0;
		else if (En_E1)
		    begin
		    	if (Bit_Cnt == 7)
		    	    Slot_Cnt <= Slot_Cnt + 1;
		    end	    
			
		if (Rst)
		    Frame_Cnt <= 0;
		else if (En_E1)
		    begin
		    	if (Bit_Cnt==7 && Slot_Cnt==31)
		    	     Frame_Cnt <= Frame_Cnt + 1;
		    end	     	  
	end

 

 

//-------------------------------------------------------------------------------	
reg      E1_Data_Out_NoCRC4   ;    
always @(posedge Clk16M or posedge Rst)
	begin 		
		if (Rst)
		    E1_Data_Out_NoCRC4 <= 1'b0;
		else if (En_E1)	
		    begin
		        if (Slot_Cnt==0 && ~Frame_Cnt[0] && Bit_Cnt==0)//CRC4 bit slot
		        	E1_Data_Out_NoCRC4 <= Stuff;	    	    		
		        else if (Slot_Cnt==0 && Frame_Cnt[0] && Bit_Cnt==0)
		        	begin
		        		case (Frame_Cnt[3:1])
		        			3'h0: E1_Data_Out_NoCRC4 <= Mulframe_Head[5];
		        			3'h1: E1_Data_Out_NoCRC4 <= Mulframe_Head[4];
		        			3'h2: E1_Data_Out_NoCRC4 <= Mulframe_Head[3];
		        			3'h3: E1_Data_Out_NoCRC4 <= Mulframe_Head[2];
		        			3'h4: E1_Data_Out_NoCRC4 <= Mulframe_Head[1];
		        			3'h5: E1_Data_Out_NoCRC4 <= Mulframe_Head[0]; 
		        			3'h6: E1_Data_Out_NoCRC4 <= 1'b1;
		        			3'h7: E1_Data_Out_NoCRC4 <= 1'b1;
		        			default: E1_Data_Out_NoCRC4 <= Stuff;
		        		endcase
		        	end	 	
		        else if (Slot_Cnt==0 && ~Frame_Cnt[0])	
		        	begin
		        		case (Bit_Cnt)
		        			3'h1: E1_Data_Out_NoCRC4 <= Frame_Head[6];
		        			3'h2: E1_Data_Out_NoCRC4 <= Frame_Head[5];
		        			3'h3: E1_Data_Out_NoCRC4 <= Frame_Head[4];
		        			3'h4: E1_Data_Out_NoCRC4 <= Frame_Head[3];	
		        			3'h5: E1_Data_Out_NoCRC4 <= Frame_Head[2];
		        			3'h6: E1_Data_Out_NoCRC4 <= Frame_Head[1];
		        			3'h7: E1_Data_Out_NoCRC4 <= Frame_Head[0];
		        			default:E1_Data_Out_NoCRC4 <= Stuff;
		        		endcase	 
		        	end	  
		        else if (Slot_Cnt==0 && Frame_Cnt[0] && Bit_Cnt==1)
		        	E1_Data_Out_NoCRC4 <= 1'b1;	 //part of the frame head	
 
		        else
		        	E1_Data_Out_NoCRC4 <= Stuff;
		    end        		
	end		
	
//------------------CRC4 Calculate
reg   [2:0]   Bit_Cnt_Dly         ;
reg   [4:0]   Slot_Cnt_Dly        ;
reg   [3:0]   Frame_Cnt_Dly       ;
always @(posedge Clk16M or posedge Rst)
    begin            
    	if (Rst)
    	    begin
                Bit_Cnt_Dly   <= 0;
                Slot_Cnt_Dly  <= 0;
                Frame_Cnt_Dly <= 0; 
            end
        else if (En_E1)
    	    begin
                Bit_Cnt_Dly   <= Bit_Cnt;
                Slot_Cnt_Dly  <= Slot_Cnt;
                Frame_Cnt_Dly <= Frame_Cnt; 
            end
    end           

reg            CRC4_Calc_End_Slot   ;	
always @(*)
    begin  	
    	if (Slot_Cnt_Dly==31 && Frame_Cnt_Dly[2:0]==7 && Bit_Cnt_Dly==7) 
    	    CRC4_Calc_End_Slot <= 1'b1;
    	else
    	    CRC4_Calc_End_Slot <= 1'b0;
    end  
      	   
reg    [3:0]    CRC4_Init    ;
reg    [3:0]    CRC4_Result  ;
always @(posedge Clk16M or posedge Rst)
	begin			
		if (Rst)
		    CRC4_Init <= 0;
		else if (En_E1)
		    begin
		        if (CRC4_Calc_End_Slot)
		        	CRC4_Init <= 0;
		        else
		        	CRC4_Init <= CRC4(E1_Data_Out_NoCRC4, CRC4_Init); 
			end
			
		if (Rst)
		    CRC4_Result <= 0;
		else if (En_E1)
		    begin
		        if (CRC4_Calc_End_Slot)
		        	CRC4_Result <= CRC4(E1_Data_Out_NoCRC4, CRC4_Init);		 
		    end
	end	  

always @(posedge Clk16M or posedge Rst)
	begin			
		if (Rst)	
		    E1_Data_Out <= 1'b0;
		else if (En_E1)
		    begin
		        if (Slot_Cnt_Dly==0 && ~Frame_Cnt_Dly[0] && Bit_Cnt_Dly==0)
		            begin
		            	case (Frame_Cnt_Dly[2:1])	
		            		3'h0: E1_Data_Out <= CRC4_Result[3];
		            		3'h1: E1_Data_Out <= CRC4_Result[2];
		            		3'h2: E1_Data_Out <= CRC4_Result[1];
		            		3'h3: E1_Data_Out <= CRC4_Result[0];
		            		default: E1_Data_Out <= Stuff;
		            	endcase	
		            end		  
		        else  	
	                E1_Data_Out <= E1_Data_Out_NoCRC4;
	        end       
    end        
	
endmodule
	

					
		
	
	

