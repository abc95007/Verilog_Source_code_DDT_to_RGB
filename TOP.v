`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:16:52 08/31/2017
// Design Name:
// Module Name:    TOP
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
//`include "Par.v"

module TOP(
input  Clock_IN,
input  Reset_IN,
output Sys_Clock,
output Reset,

/*
//DDT outside to FPGA single    ******Mark******
input DDT_VSA,
input DDT_HSA,
input DDT_DE,
input DDT_Clock,
input [7:0]DDT_R,
input [7:0]DDT_G,
input [7:0]DDT_B,
*/

//DDT FPGA create inside single    ******Mark******
output DDT_VSA,
output DDT_HSA,
output DDT_DE,
output DDT_Clock,
output [7:0]DDT_R,
output [7:0]DDT_G,
output [7:0]DDT_B,

//SRAM
inout  [26:0]Data_Bus,
output [20:0]Addr,
output SRAM_Clock,
output EN,
output WE,
//debug
output Addr_Jump,
//RGB interface
output wire RGB_VSA,
output wire RGB_HSA,
output wire RGB_DE,
output wire RGB_PCLK,
output wire [7:0]RGB_R,
output wire [7:0]RGB_G,
output wire [7:0]RGB_B
    );
assign Reset = ~Reset_IN;

/////////////////////

wire VSA;
wire HSA;
wire VSA_Inv;
wire HSA_Inv;
wire DDT_VSA_Inv;
wire DDT_HSA_Inv;
wire DE;

// DDT Hight Active use
//assign DDT_VSA_Inv = ~DDT_VSA;
//assign DDT_HSA_Inv = ~DDT_HSA;

//	DDT Low Active use
assign DDT_VSA_Inv = DDT_VSA;
assign DDT_HSA_Inv = DDT_HSA;

PLL m1(
	.Clock_IN(Clock_IN),
	.Sys_Clock(Sys_Clock),
	.DDT_Clock(DDT_Clock)		//*******Mark*****
	);

M_RGB_Source m2(
	.Sys_Clock(Sys_Clock),
	.Reset(Reset),
	// RGB single
	.VSA(VSA),
	.HSA(HSA),
	.DE(DE)
	);

M_SRAM m3(
	.Sys_Clock(Sys_Clock),
	.DDT_Clock(DDT_Clock),
	.Reset(Reset),
	//DDT input
	.DDT_VSA_Inv(DDT_VSA_Inv),
	.DDT_HSA_Inv(DDT_HSA_Inv),
	.DDT_DE(DDT_DE),
	.DDT_R(DDT_R),
	.DDT_G(DDT_G),
	.DDT_B(DDT_B),
	// RGB single
	.VSA(VSA),
	.HSA(HSA),
	.DE(DE),
	// SRAM
	.SRAM_Clock(SRAM_Clock),
	.EN(EN),
	.WE(WE),
	.Data_Bus(Data_Bus),
	.Addr(Addr),
	//debug
	.Addr_Jump(Addr_Jump),
	// RGB interface
	.RGB_VSA(RGB_VSA),
	.RGB_HSA(RGB_HSA),
	.RGB_DE(RGB_DE),
	.RGB_PCLK(RGB_PCLK),
	.RGB_R(RGB_R),
	.RGB_G(RGB_G),
	.RGB_B(RGB_B)
	);


// DDT FPGA create inside single    ******Mark******
	wire DDT_VSA;
	wire DDT_HSA;
	wire DDT_DE;
	wire DDT_Clock;
	wire [7:0]DDT_R;
	wire [7:0]DDT_G;
	wire [7:0]DDT_B;

DDT m7(
	.DDT_Clock(DDT_Clock),
	.Reset(Reset),
	.DDT_VSA(DDT_VSA),
	.DDT_HSA(DDT_HSA),
	.DDT_DE(DDT_DE),
	.DDT_Pixel_Data_Cnt(DDT_Pixel_Data_Cnt),
	.DDT_Line_Data_Cnt(DDT_Line_Data_Cnt),
	.DDT_Pixel_Cnt(DDT_Pixel_Cnt),
	//.DDT_Line_Cnt(DDT_Line_Cnt),
	.DDT_Line_Clear(DDT_Line_Clear),
	.DDT_R(DDT_R),
	.DDT_G(DDT_G),
	.DDT_B(DDT_B)
);

M_Memory m8(
	.Sys_Clock(Sys_Clock),
	.DDT_Clock(DDT_Clock),
	.Reset(Reset),
	.EN(EN),
	.WE(WE),
	.Addr(Addr),
	.Dbus_in(Data_Bus),
	//.Dbus_out(Dbus_out)
	.Dbus_out(Dbus_out)
);


endmodule
