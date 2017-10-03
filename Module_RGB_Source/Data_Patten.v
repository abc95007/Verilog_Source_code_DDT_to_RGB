`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    14:56:34 09/04/2017
// Design Name:
// Module Name:    Data
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
module Data_patten(
input Sys_Clock,
input Reset,
input HSA,
input VSA,
input DE,

input [15:0]Pixel_Data_Cnt,
input [15:0]Line_Data_Cnt,

output wire [7:0]R,
output wire [7:0]G,
output wire [7:0]B
    );
wire [7:0]Data_R;
wire [7:0]Data_G;
wire [7:0]Data_B;
assign Data_R[7:0] = 8'd255;
assign Data_G[7:0] = 8'd255;
assign Data_B[7:0] = 8'd0;

assign R[7:0] = DE == 1 ? Data_R[7:0] : 0;
assign G[7:0] = DE == 1 ? Data_G[7:0] : 0;
assign B[7:0] = DE == 1 ? Data_B[7:0] : 0;

endmodule
