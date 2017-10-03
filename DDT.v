`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:52:16 09/20/2017
// Design Name:
// Module Name:    DDT
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module DDT(
input DDT_Clock,
input Reset,
output wire DDT_VSA,
output wire DDT_HSA,
output wire DDT_DE,
output reg [15:0]DDT_Pixel_Data_Cnt,
output reg [15:0]DDT_Line_Data_Cnt,
output reg [15:0]DDT_Pixel_Cnt,
//output reg [15:0]DDT_Line_Cnt,
output wire DDT_Line_Clear,
output wire [7:0]DDT_R,
output wire [7:0]DDT_G,
output wire [7:0]DDT_B
    );
`include "DDT_Par.v"

wire DDT_HBP;
wire DDT_HFP;
wire DDT_VBP;
wire DDT_VFP;
reg [15:0]DDT_Line_Cnt;
reg DDT_Line_DDT_Clock;


//Pixel Counter
wire [15:0]DDT_Pixel_Cnt_Next = DDT_Pixel_Cnt[15:0] < H_total - 1 ? DDT_Pixel_Cnt[15:0] + 1'b1 : 0;
always @(negedge DDT_Clock or negedge Reset)
begin
	if (!Reset)
		DDT_Pixel_Cnt[15:0] <= 0;
	else
		DDT_Pixel_Cnt[15:0] <= DDT_Pixel_Cnt_Next[15:0];
end

//Line_Clear
assign DDT_Line_Clear = DDT_Pixel_Cnt[15:0] == H_total -1	?	1 : 0;

//Line_DDT_Clock
wire DDT_Line_DDT_Clock_Next = DDT_Line_Clear == 1		?		~DDT_Line_DDT_Clock	: DDT_Line_DDT_Clock	;
always @(negedge DDT_Clock or negedge Reset)
begin
	if (!Reset)
		DDT_Line_DDT_Clock <= 0;
	else
		DDT_Line_DDT_Clock <= DDT_Line_DDT_Clock_Next;
end

//Line_Cnt
wire [15:0]DDT_Line_Cnt_Next = (DDT_Line_Clear == 1 ) && (DDT_Line_Cnt[15:0] == (V_total-1)) 	?	0								:
									(DDT_Line_Clear == 1 )													?	DDT_Line_Cnt[15:0] + 1'b1	:	DDT_Line_Cnt[15:0]	;
always @(negedge DDT_Clock or negedge Reset)
begin
	if (!Reset)
		DDT_Line_Cnt[15:0] <= 0;
	else
		DDT_Line_Cnt[15:0] <= DDT_Line_Cnt_Next[15:0];
end


//Pixel Data Counter
wire [15:0]DDT_Pixel_Data_Cnt_Next = DDT_Pixel_Cnt[15:0] >= (HFP_Num + HSA_Num + HBP_Num -1) && DDT_Pixel_Cnt[15:0] < (H_total-1) ? DDT_Pixel_Data_Cnt[15:0] + 1'b1 : 0 ;
always @(negedge DDT_Clock or negedge Reset)
begin
	if (!Reset)
		DDT_Pixel_Data_Cnt[15:0] <= 0;
	else
		DDT_Pixel_Data_Cnt[15:0] <= DDT_Pixel_Data_Cnt_Next[15:0];
end

//Line_Data_Cnt
wire [15:0]DDT_Line_Data_Cnt_Next = DDT_Line_Cnt[15:0] >= (VFP_Num + VSA_Num + VBP_Num) && DDT_Line_Cnt[15:0] <= (V_total) ? DDT_Line_Data_Cnt[15:0] + 1'b1 : 0 ;
always @(negedge DDT_HSA or negedge Reset)
begin
	if (!Reset)
		DDT_Line_Data_Cnt[15:0] <= 0;
	else
		DDT_Line_Data_Cnt[15:0] <= DDT_Line_Data_Cnt_Next[15:0];
end

//HFP
assign DDT_HFP = DDT_Pixel_Cnt[15:0] >=0 && DDT_Pixel_Cnt[15:0] <HFP_Num	? 1:0;

//HSA
assign DDT_HSA = DDT_Pixel_Cnt[15:0] >=HFP_Num && DDT_Pixel_Cnt[15:0] <HFP_Num + HSA_Num	? 1:0;

//HBP
assign DDT_HBP = DDT_Pixel_Cnt[15:0] >=HFP_Num + HSA_Num && DDT_Pixel_Cnt[15:0] <HFP_Num + HSA_Num + HBP_Num	? 1:0;

//VFP
assign DDT_VFP = DDT_Line_Cnt[15:0] >=0 && DDT_Line_Cnt[15:0] <VFP_Num	? 1:0;

//HSA
assign DDT_VSA = DDT_Line_Cnt[15:0] >=VFP_Num && DDT_Line_Cnt[15:0] <VFP_Num + VSA_Num	? 1:0;

//HBP
assign DDT_VBP = DDT_Line_Cnt[15:0] >=VFP_Num + VSA_Num && DDT_Line_Cnt[15:0] <VFP_Num + VSA_Num + VBP_Num	? 1:0;

assign DDT_DE =  DDT_Line_Cnt < VFP_Num + VSA_Num + VBP_Num ? 0 		:

					  DDT_Pixel_Cnt >= HFP_Num + HSA_Num + HBP_Num  && DDT_Pixel_Cnt < H_total  ? 1 	: 0 ;


wire [7:0]DDT_Data_R;
wire [7:0]DDT_Data_G;
wire [7:0]DDT_Data_B;

assign DDT_Data_R[7:0] = DDT_Pixel_Data_Cnt[0] == 0 ? 0 : 8'd255 ;
assign DDT_Data_G[7:0] = DDT_Pixel_Data_Cnt[0] == 0 ?	0 : 8'd255 ;
assign DDT_Data_B[7:0] = DDT_Pixel_Data_Cnt[0] == 0 ? 0 : 8'd255 ;


assign DDT_R[7:0] = DDT_DE == 1 ? DDT_Data_R[7:0] : 0;
assign DDT_G[7:0] = DDT_DE == 1 ? DDT_Data_G[7:0] : 0;
assign DDT_B[7:0] = DDT_DE == 1 ? DDT_Data_B[7:0] : 0;





endmodule
