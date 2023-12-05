`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/25 20:41:37
// Design Name: 
// Module Name: saturation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module saturation#(
    parameter N=4,
    parameter  WIDTH=8
)(
    input logic signed [2*WIDTH+N-1:0] intermediate_result,
    output logic signed [WIDTH-1:0] saturation_result
);
   
localparam int INT_BITS = (WIDTH == 32) ? 12 : ((WIDTH == 16) ? 6 : 3);
localparam int FRAC_BITS = (WIDTH == 32) ? 20 : ((WIDTH == 16) ? 10 : 5);

logic signed [2*INT_BITS+N-1:0] int_section;
logic signed [2*FRAC_BITS-1:0] frac_section;

always_comb begin
    int_section=intermediate_result[2*WIDTH+N-1:2*FRAC_BITS];
    if(int_section>(2**(INT_BITS-1)-1)||int_section<-(2**(INT_BITS-1))) begin
        saturation_result=(int_section<0)?(-2**(INT_BITS-1)):(2**(INT_BITS-1)-1);
        saturation_result=saturation_result<<FRAC_BITS;
    end else begin
        saturation_result={(int_section<0)?1'b1:1'b0,intermediate_result[2*FRAC_BITS+INT_BITS-2:2*FRAC_BITS], intermediate_result[2*FRAC_BITS-1:FRAC_BITS]};
    end
end
endmodule
