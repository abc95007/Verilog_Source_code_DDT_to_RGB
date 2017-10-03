`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:04:22 09/28/2017
// Design Name:
// Module Name:    Module_SRAM
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
module M_SRAM(
	input Sys_Clock,
	input DDT_Clock,
	input Reset,
	//DDT input
	input DDT_VSA_Inv,
	input DDT_HSA_Inv,
	input DDT_DE,
	input [7:0]DDT_R,
	input [7:0]DDT_G,
	input [7:0]DDT_B,
	// RGB Single
	input VSA,
	input HSA,
	input DE,
	// SRAM
	output SRAM_Clock,
	output EN,
	output WE,
	output [26:0]Data_Bus,
	output wire [20:0]Addr,
	//debug
	output Addr_Jump,
	// RGB interface
	output wire RGB_VSA,
	output wire RGB_HSA,
	output wire RGB_DE,
	output wire RGB_PCLK,
	output wire [7:0]RGB_R,
	output wire [7:0]RGB_G,
	output wire [7:0]RGB_B
);
wire SRAM_Clock;
wire EN;
wire WE;
wire WE_Delay2;
wire [26:0]Data_IN_Delay2;
wire DDT_DE_Delay1;
wire Line_Change;
wire Addr_Jump;
wire [15:0]DDT_Line_Cnt;
wire [1:0]WE_Cnt;
wire VSA;
wire HSA;
wire DE;

Sram_Control m1(
.Sys_Clock(Sys_Clock),
.DDT_Clock(DDT_Clock),
.Reset(Reset),
// DDT single
.DDT_VSA_Inv(DDT_VSA_Inv),
.DDT_HSA_Inv(DDT_HSA_Inv),
.DDT_DE(DDT_DE),
.DDT_R(DDT_R),
.DDT_G(DDT_G),
.DDT_B(DDT_B),
//SRAM
.EN(EN),
.WE(WE),
.WE_Cnt(WE_Cnt),
.WE_Delay2(WE_Delay2),
.Data_IN_Delay2(Data_IN_Delay2),
.DDT_DE_Delay1(DDT_DE_Delay1),
.Line_Change(Line_Change),
.Addr_Jump(Addr_Jump),
.DDT_Line_Cnt(DDT_Line_Cnt)
);

Sram2RGB m2(
.Sys_Clock(Sys_Clock),
.DDT_Clock(DDT_Clock),
.Reset(Reset),
//SRAM
.EN(EN),
.WE(WE),
.WE_Delay2(WE_Delay2),
.Data_IN_Delay2(Data_IN_Delay2),
.DDT_DE_Delay1(DDT_DE_Delay1),
.Line_Change(Line_Change),
.Addr_Jump(Addr_Jump),
.DDT_Line_Cnt(DDT_Line_Cnt),
.WE_Cnt(WE_Cnt),
//RGB Sync
.VSA(VSA),
.HSA(HSA),
.DE(DE),
//SRAM BUS ADD
.SRAM_Clock(SRAM_Clock),
.Data_Bus(Data_Bus),
.Addr(Addr),
//RGB interface
.RGB_VSA(RGB_VSA),
.RGB_HSA(RGB_HSA),
.RGB_DE(RGB_DE),
.RGB_PCLK(RGB_PCLK),
.RGB_R(RGB_R),
.RGB_G(RGB_G),
.RGB_B(RGB_B)
);

endmodule
