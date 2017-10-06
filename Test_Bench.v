`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:14:58 08/31/2017
// Design Name:
// Module Name:    Test_Bench
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
module Test_Bench(
    );
reg Clock_IN;
wire DDT_Clock;
reg Reset_IN;
wire Sys_Clock;
wire Reset;
wire [26:0]Data_Bus;
wire [20:0]Addr;
wire EN;
wire WE;

wire RGB_VSA;
wire RGB_HSA;
wire RGB_DE;
wire RGB_PCLK;
wire [7:0]RGB_R;
wire [7:0]RGB_G;
wire [7:0]RGB_B;

TOP m(
.Clock_IN(Clock_IN),
.Reset_IN(Reset_IN),
.Sys_Clock(Sys_Clock),
.Reset(Reset),

//DDT outside single
.DDT_VSA(DDT_VSA),
.DDT_HSA(DDT_HSA),
.DDT_DE(DDT_DE),
.DDT_Clock(DDT_Clock),
.DDT_R(DDT_R),
.DDT_G(DDT_G),
.DDT_B(DDT_B),

//SRAM
.Data_Bus(Data_Bus),
.Addr(Addr),
.EN(EN),
.WE(WE),
//RGB interface
.RGB_VSA(RGB_VSA),
.RGB_HSA(RGB_HSA),
.RGB_DE(RGB_DE),
.RGB_PCLK(RGB_PCLK),
.RGB_R(RGB_R),
.RGB_G(RGB_G),
.RGB_B(RGB_B)
);
//assign DDT_Clock = Clock_IN;
always #1 Clock_IN= ~Clock_IN;	//42
initial
begin
Clock_IN = 0;
Reset_IN = 1;
#500
Reset_IN = 0;
end
endmodule
