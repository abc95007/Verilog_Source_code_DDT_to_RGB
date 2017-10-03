
module M_RGB_Source (
	input Sys_Clock,
	input Reset,
	output VSA,
	output HSA,
	output DE
	);

wire [15:0]Pixel_Data_Cnt;
wire [15:0]Line_Data_Cnt;
wire [15:0]Pixel_Cnt;
wire [15:0]Line_Cnt;
wire Line_Clear;
wire	[7:0]R;
wire	[7:0]G;
wire	[7:0]B;

Counter_Sync m1(
	.Sys_Clock(Sys_Clock),
	.Reset(Reset),
	.VSA(VSA),
	.HSA(HSA),
	.DE(DE),
	.Pixel_Data_Cnt(Pixel_Data_Cnt),
	.Line_Data_Cnt(Line_Data_Cnt),
	.Pixel_Cnt(Pixel_Cnt),
	.Line_Cnt(Line_Cnt),
	.Line_Clear(Line_Clear)
	);

Data_patten m2(
	.Sys_Clock(Sys_Clock),
	.Reset(Reset),
	.HSA(HSA),
	.VSA(VSA),
	.DE(DE),
	.Pixel_Data_Cnt(Pixel_Data_Cnt),
	.Line_Data_Cnt(Line_Data_Cnt),
	.R(R),
	.G(G),
	.B(B)
	);

endmodule //Module_RGB_Source
