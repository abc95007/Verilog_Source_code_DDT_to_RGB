`timescale 1ns/100ps
module M_Clock_Switch (
   // Outputs
   out_clk,
   // Inputs
   clk_a, clk_b, select
   );

   input clk_a;
   input clk_b;
   input select;

   output out_clk;
wire   out_clk;

reg q1,q2,q3,q4;
wire or_one, or_two,or_three,or_four;

always @ (posedge clk_a)
begin
    if (clk_a == 1'b1)
    begin
       q1 <= q4;
       q3 <= or_one;
    end
end

always @ (posedge clk_b)
begin
    if (clk_b == 1'b1)
    begin
        q2 <= q3;
        q4 <= or_two;
    end
end

assign or_one   = (!q1) | (!select);
assign or_two   = (!q2) | (select);
assign or_three = (q3)  | (clk_a);
assign or_four  = (q4)  | (clk_b);

assign out_clk  = or_three & or_four;

endmodule
