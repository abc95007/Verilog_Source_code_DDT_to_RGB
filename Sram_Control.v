`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:32:41 09/08/2017
// Design Name:
// Module Name:    Sram_Control
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
//
module Sram_Control(
input Clock,
input Reset,
input DDT_VSA_Inv,
input DDT_HSA_Inv,
input DDT_DE,
input [7:0]DDT_R,
input [7:0]DDT_G,
input [7:0]DDT_B,

//output wire [26:0]Data_Bus,
output wire EN,
output wire WE,

output [1:0]WE_Cnt,
output WE_Delay2,
output [26:0]Data_IN_Delay2,
output DDT_DE_Delay1,
output Line_Change,
output Addr_Jump,
output [15:0]DDT_Line_Cnt
    );

reg [26:0]Data_IN;
reg VSA_Delay0;
reg VSA_Delay1;
reg [1:0]WE_Cnt;
reg DDT_DE_Delay1;
reg [15:0]DDT_Line_Cnt;
wire Addr_Jump;
wire Line_Change;
wire VSA_Inv;
assign EN = 0;
//`include "Par.v"

//Frame_Clear
//VSA_Delay0;
assign Frame_Clear = VSA_Delay1 > VSA_Delay0 ? 1 : 0;
always @(negedge Clock or negedge Reset)
begin
	if(!Reset)
	begin
		VSA_Delay0 <= 0;
		VSA_Delay1 <= 0;
	end
	else
	begin
		VSA_Delay0 <= DDT_VSA_Inv;
		VSA_Delay1 <= VSA_Delay0;
	end
end

/////////////////////////////////////////////////////////

//Line_Change
always @(negedge Clock or negedge Reset)
begin
	if(!Reset)
		DDT_DE_Delay1 <= 0;
	else
		DDT_DE_Delay1 <= DDT_DE;
end
assign Line_Change = DDT_DE_Delay1 < DDT_DE ? 1 : 0;

//Addr_Jump
assign Addr_Jump = DDT_DE_Delay1 > DDT_DE ? 1 : 0;

//////////////////////////////////////////////////////////////

//[15:0]DDT_Line_Cnt;
wire [15:0]DDT_Line_Cnt_Next =		WE_Cnt[1:0] == 0									?	0									:
												WE_Cnt[1:0] == 2 && WE_Cnt[1:0] == 3		?	16'hffff							:
												Line_Change == 1 									?	DDT_Line_Cnt[15:0] + 1'b1	:	DDT_Line_Cnt[15:0];
always @(negedge Clock or negedge Reset)
begin
	if(!Reset)
		DDT_Line_Cnt[15:0] <= 0;
	else
		DDT_Line_Cnt[15:0] <= DDT_Line_Cnt_Next[15:0];
end
//////////////////////////////////////////////////////////////////

//[1:0]WE_Cnt_Next
wire [1:0]WE_Cnt_Next = WE_Cnt[1:0] == 2'b10			?	2'b10					:
								Frame_Clear == 1				?	WE_Cnt[1:0]	+1		:	WE_Cnt[1:0];
always @(negedge Clock or negedge Reset)
begin
	if(!Reset)
		WE_Cnt[1:0] <= 0;
	else
		WE_Cnt[1:0] <= WE_Cnt_Next[1:0];
end
//////////////////////////////////////////////////////////////////////

//assign Data_IN[26:0] = {DDT_B[7:0],DDT_G[7:0],DDT_R[7:0],DDT_DE};
wire [26:0]Data_IN_Next = {DDT_B[7:0],DDT_G[7:0],DDT_R[7:0]};
always @(negedge Clock or negedge Reset)
begin
	if(!Reset)
		Data_IN[26:0] <= 0;
	else
		Data_IN[26:0] <= Data_IN_Next[26:0];
end

//Data_IN_Delay
reg [26:0]Data_IN_Delay1;
reg [26:0]Data_IN_Delay2;
reg [26:0]Data_IN_Delay3;
reg [26:0]Data_IN_Delay4;

always @(negedge Clock or negedge Reset)
begin
	if(!Reset)
	begin
		Data_IN_Delay1[26:0] <= 0;
		Data_IN_Delay2[26:0] <= 0;
		Data_IN_Delay3[26:0] <= 0;
		Data_IN_Delay4[26:0] <= 0;
	end
	else
	begin
		Data_IN_Delay1[26:0] <= Data_IN[26:0];
		Data_IN_Delay2[26:0] <= Data_IN_Delay1[26:0];
		Data_IN_Delay3[26:0] <= Data_IN_Delay2[26:0];
		Data_IN_Delay4[26:0] <= Data_IN_Delay3[26:0];
	end
end

//WE
assign WE	=	WE_Cnt[1:0] == 2'b01 ?	0	:	1;
reg WE_Delay1;
reg WE_Delay2;
always @(negedge Clock or negedge Reset)
begin
	if(!Reset)
	begin
		WE_Delay1 <= 0;
		WE_Delay2 <= 0;
	end
	else
	begin
		WE_Delay1 <= WE;
		WE_Delay2 <= WE_Delay1;
	end
end


endmodule
