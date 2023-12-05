module serial_mlp #(
	parameter N, //Represents the number of inputs to the MLP (not necessarily the same as in parallel_neuron.sv)
	parameter M, //The number of layers in the MLP
 	parameter WIDTH
) (
					        
	input logic clk, rst_n,
	input logic [WIDTH - 1 : 0] in [N-1],
	output logic [WIDTH- 1 : 0] out
);
endmodule
