`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:08:49 09/05/2017 
// Design Name: 
// Module Name:    Debouncer 
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
module Debouncer(
input Clock,
input Reset,
input Botten_IN,
input	[15:0]Pixel_Cnt,
input	[15:0]Line_Cnt,
output wire Botten
    );
`include "Par.v"	  
reg [19:0]Clock_Deb;

// Out1
wire [19:0]Clock_Deb_Next = Botten_IN == 0 ? 0 :
					Clock_Deb < H_total*V_total ? Clock_Deb + 1'b1 : 20'hFFFFF ;		

					
always @(posedge Clock or negedge Reset)
if(!Reset)
	Clock_Deb[19:0] <= 0;
else
	Clock_Deb[19:0] <= Clock_Deb_Next;

//Botten width
assign Botten = (Clock_Deb[19:0]	> 0)	&& (Clock_Deb[19:0] < (H_total*V_total)) && (Pixel_Cnt[15:0] == (H_total-1)) && (Line_Cnt[15:0]	==	(V_total-1))	?	1	:	0;	 
endmodule
