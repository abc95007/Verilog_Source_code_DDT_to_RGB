module M_Memory(
	input Sys_Clock,
	input DDT_Clock,
	input Reset,
	input EN,
	input WE,
	input [20:0] Addr,
	input [26:0] Dbus_in,
	output reg [26:0] Dbus_out
 );
wire Clock;		//switch clock
reg [26:0] m [0:20];
reg [26:0] Data;

reg [1:0]curr_state;
reg [1:0]next_state;

//state parameter
parameter IDLE = 2'b00;
parameter Write = 2'b01;
parameter Read  = 2'b10;

//clock switch
assign Clock = EN == 0 && WE == 1 ? Sys_Clock	:	DDT_Clock;

always @ (posedge Clock or negedge Reset) begin
	if (!Reset)
		curr_state <= IDLE;
	else
		curr_state <= next_state;
end
// next state
always @ ( * ) begin
	case (curr_state)
		Write :
			if (EN == 0 && WE == 0)
				next_state = Write;
			else
				next_state = Read;
		Read	:
			if (EN == 0 && WE == 1)
				next_state = Read;
			else
				next_state = Write;
		IDLE	:
		if (EN == 0 && WE == 1)
			next_state = Read;
		else if (EN == 0 && WE == 0)
			next_state = Write;
		else
			next_state = IDLE;
	endcase
end

//output state
always @ ( * ) begin
	case(curr_state)
		IDLE:
			Data[26:0] = 8'hzz;
		Write:
		begin
			Data[26:0] = Dbus_in[26:0];
			m[Addr_Delay2] = Dbus_in[26:0];
		end
		Read:
		begin
			Data[26:0] = m[Addr];
			Dbus_out[26:0] = Data_Delay2[26:0];
		end
	endcase
end

// Addr_Delay  Write use
reg [20:0]Addr_Delay1;
reg [20:0]Addr_Delay2;
always @ (negedge Clock or negedge Reset) begin
	if (!Reset)
		begin
			Addr_Delay1[20:0] <= 8'h00;
			Addr_Delay2[20:0] <= 8'h00;
		end
	else
		begin
			Addr_Delay1[20:0] <= Addr[20:0];
			Addr_Delay2[20:0] <= Addr_Delay1[20:0];
		end
end

//Data_Delay1
reg [26:0]Data_Delay1;
reg [26:0]Data_Delay2;
always @ (posedge Clock or negedge Reset) begin
	if (!Reset)
	begin
		Data_Delay1[26:0] <= 0;
		Data_Delay2[26:0] <= 0;
	end
	else
	begin
		Data_Delay1[26:0] <= Data[26:0];
		Data_Delay2[26:0] <= Data_Delay1[26:0];
	end
end

endmodule
