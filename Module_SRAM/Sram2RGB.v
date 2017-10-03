`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:33:23 09/11/2017
// Design Name:
// Module Name:    Sram2RGB
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
/////////////////////////////////////////////////////////////////////////////
module Sram2RGB(
input Sys_Clock,
input DDT_Clock,
input Reset,
//SRAM
input EN,
input WE,
input WE_Delay2,
input [26:0]Data_IN_Delay2,
input DDT_DE_Delay1,
input Line_Change,
input Addr_Jump,
input [15:0]DDT_Line_Cnt,
input [1:0]WE_Cnt,
//RGB sync
input VSA,
input HSA,
input DE,
//SRAM BUS Addr
output wire SRAM_Clock,
output [26:0]Data_Bus,
output wire [20:0]Addr,
//RGB interface
output wire RGB_VSA,
output wire RGB_HSA,
output wire RGB_DE,
output wire RGB_PCLK,
output wire [7:0]RGB_R,
output wire [7:0]RGB_G,
output wire [7:0]RGB_B

    );

`include "Par.v"
reg [1:0]Curr_State;
reg [1:0]Next_State;

reg VSA_Delay1;
reg HSA_Delay1;
reg DE_Delay1;

parameter Initial = 	2'b00;
parameter Write = 	2'b01;
parameter Read = 		2'b10;

assign RGB_PCLK = Sys_Clock;

wire Clock;
assign Clock = WE == 0 ? DDT_Clock : Sys_Clock;

//state reg
always @(negedge Clock or negedge Reset)
if (!Reset)
	Curr_State <= Initial;
else
	Curr_State <= Next_State;

//next state
always @(*)
case	(Curr_State)
	Initial	:	if (EN == 0 && WE == 0)
						Next_State = Write ;
					else if (EN == 0 && WE == 1)
						Next_State = Read;
					else
						Next_State = Initial ;
	Read 		:  if (EN == 0 && WE == 0)
						Next_State = Write ;
					else
						Next_State = Read	;
	Write 	:  if (EN == 0 && WE == 1)
						Next_State = Read ;
					else
						Next_State = Write ;
	default :	Next_State = Initial;
endcase

assign Addr[20:0] = 			Curr_State == Initial				?	8'h00								:
									Curr_State == Write					?	Addr_Wirte[20:0]				:
									Curr_State == Read					?	Addr_Read[20:0]				:	8'h00	 ;

assign Data_Bus[26:0] = 	Curr_State == Initial				?	8'h00								:
									Curr_State == Write					?	Data_IN_Delay2[26:0]			:
									Curr_State == Read					?	27'hzzzzzzz						:	8'h00	 ;

assign SRAM_Clock = 			Curr_State == Initial				?	8'h00								:
									Curr_State == Write					?	DDT_Clock						:
									Curr_State == Read					?	Sys_Clock						:	Sys_Clock ;

always @ (negedge Sys_Clock or negedge Reset) begin
if(!Reset)
	begin
		VSA_Delay1 <= 0;
		HSA_Delay1 <= 0;
		DE_Delay1 <= 0;
	end
else
	begin
		VSA_Delay1 <= VSA;
		HSA_Delay1 <= HSA;
		DE_Delay1  <= DE;
	end
end

assign {RGB_B[7:0],RGB_G[7:0],RGB_R[7:0],RGB_DE,RGB_HSA,RGB_VSA} = {Data_Bus[23:16],Data_Bus[15:8],Data_Bus[7:0],DE_Delay1,!HSA_Delay1,!VSA_Delay1};

//Write SRAM
wire [20:0]Addr_Wirte_Next =  WE_Cnt[1:0] == 2'b00										? 0												:
										WE_Cnt[1:0] == 2'b10										? 21'hFFFF										:
										DDT_DE_Delay1 == 1 && Addr_Jump == 0				? Addr_Wirte[20:0] + 1'b1					:
										Addr_Jump == 1												? Source_Num * DDT_Line_Cnt[15:0]		: Addr_Wirte[20:0] ;
reg [20:0]Addr_Wirte;
always @(negedge DDT_Clock or negedge Reset)
if(!Reset)
	Addr_Wirte[20:0] <= 0;
else
	Addr_Wirte[20:0] <= Addr_Wirte_Next[20:0];

//Read SRAM
wire [20:0]Addr_Read_Next = 	VSA == 1 							?	0									:
										DE	== 1								?	Addr_Read[20:0] + 1'b1		:	Addr_Read[20:0]	;
reg [20:0]Addr_Read;
always @(negedge Sys_Clock or negedge Reset)
if(!Reset)
	Addr_Read[20:0] <= 0;
else
    Addr_Read[20:0] <= Addr_Read_Next[20:0];




endmodule
