//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:32:23 09/04/2017
// Design Name:
// Module Name:    Counter_Sync
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


module Counter_Sync(
input Sys_Clock,
input Reset,
output wire VSA,
output wire HSA,
output wire DE,
output reg [15:0]Pixel_Data_Cnt,
output reg [15:0]Line_Data_Cnt,
output reg [15:0]Pixel_Cnt,
output reg [15:0]Line_Cnt,
output wire Line_Clear
    );
`include "Par.v"

wire HBP;
wire HFP;
wire VBP;
wire VFP;
reg Line_Clock;

//Pixel Counter
wire [15:0]Pixel_Cnt_Next = Pixel_Cnt[15:0] < H_total - 1 ? Pixel_Cnt[15:0] + 1'b1 : 0;
always @(negedge Sys_Clock or negedge Reset)
begin
	if (!Reset)
		Pixel_Cnt[15:0] <= 0;
	else
		Pixel_Cnt[15:0] <= Pixel_Cnt_Next[15:0];
end

//Line_Clear
assign Line_Clear = Pixel_Cnt[15:0] == H_total -1	?	1 : 0;

//Line_Clock
wire Line_Clock_Next = Line_Clear == 1		?		~Line_Clock	: Line_Clock	;
always @(negedge Sys_Clock or negedge Reset)
begin
	if (!Reset)
		Line_Clock <= 0;
	else
		Line_Clock <= Line_Clock_Next;
end

//Line_Cnt
wire [15:0]Line_Cnt_Next = (Line_Clear == 1 ) && (Line_Cnt[15:0] == (V_total-1)) 	?	0								:
									(Line_Clear == 1 )													?	Line_Cnt[15:0] + 1'b1	:	Line_Cnt[15:0]	;
always @(negedge Sys_Clock or negedge Reset)
begin
	if (!Reset)
		Line_Cnt[15:0] <= 0;
	else
		Line_Cnt[15:0] <= Line_Cnt_Next[15:0];
end


//Pixel Data Counter
wire [15:0]Pixel_Data_Cnt_Next = Pixel_Cnt[15:0] >= (HFP_Num + HSA_Num + HBP_Num -1) && Pixel_Cnt[15:0] < (H_total-1) ? Pixel_Data_Cnt[15:0] + 1'b1 : 0 ;
always @(negedge Sys_Clock or negedge Reset)
begin
	if (!Reset)
		Pixel_Data_Cnt[15:0] <= 0;
	else
		Pixel_Data_Cnt[15:0] <= Pixel_Data_Cnt_Next[15:0];
end

//Line_Data_Cnt
wire [15:0]Line_Data_Cnt_Next = Line_Cnt[15:0] >= (VFP_Num + VSA_Num + VBP_Num) && Line_Cnt[15:0] <= (V_total) ? Line_Data_Cnt[15:0] + 1'b1 : 0 ;
always @(negedge HSA or negedge Reset)
begin
	if (!Reset)
		Line_Data_Cnt[15:0] <= 0;
	else
		Line_Data_Cnt[15:0] <= Line_Data_Cnt_Next[15:0];
end

//HFP
assign HFP = Pixel_Cnt[15:0] >=0 && Pixel_Cnt[15:0] <HFP_Num	? 1:0;

//HSA
assign HSA = Pixel_Cnt[15:0] >=HFP_Num && Pixel_Cnt[15:0] <HFP_Num + HSA_Num	? 1:0;

//HBP
assign HBP = Pixel_Cnt[15:0] >=HFP_Num + HSA_Num && Pixel_Cnt[15:0] <HFP_Num + HSA_Num + HBP_Num	? 1:0;

//VFP
assign VFP = Line_Cnt[15:0] >=0 && Line_Cnt[15:0] <VFP_Num	? 1:0;

//HSA
assign VSA = Line_Cnt[15:0] >=VFP_Num && Line_Cnt[15:0] <VFP_Num + VSA_Num	? 1:0;

//HBP
assign VBP = Line_Cnt[15:0] >=VFP_Num + VSA_Num && Line_Cnt[15:0] <VFP_Num + VSA_Num + VBP_Num	? 1:0;


assign DE =	Line_Cnt < VFP_Num + VSA_Num + VBP_Num ? 0 		:
				Pixel_Cnt >= HFP_Num + HSA_Num + HBP_Num  && Pixel_Cnt < H_total  ? 1 	: 0 ;

endmodule
