`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:44:33 09/19/2017 
// Design Name: 
// Module Name:    Reset_Debouncer 
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
module Reset_Debouncer(
input Clock,
input Reset_IN,
output reg Reset
    );
wire Reset_IN_Inv = ~Reset_IN;
	 
reg [19:0]Reset_Deb_Cnt;

wire [19:0]Reset_Deb_Cnt_Next = Reset_Deb_Cnt[19:0] == 20'hFFFFE ? 20'hFFFFF	: Reset_Deb_Cnt[19:0] + 1'b1; 
always @(negedge Clock or negedge Reset_IN_Inv)
begin
	if(!Reset_IN_Inv)
		Reset_Deb_Cnt[19:0] <= 0;
	else
		Reset_Deb_Cnt[19:0] <= Reset_Deb_Cnt_Next[19:0];
end

wire Reset_Next = Reset_Deb_Cnt[19:0] < 20'hFFFFE && Reset_Deb_Cnt[19:0] > 20'hFFFF0 ?	0 : 1 ;
always @(negedge Clock or negedge Reset_IN_Inv)
begin
	if(!Reset_IN_Inv)
		Reset <= 1;
	else
		Reset <= Reset_Next;
end


endmodule
