module weight #(
    parameter N,
    parameter M,
    parameter WIDTH
)(
  input logic [$clog2(M)-1:0] layer_addr, //Need to have space for N*N*(M-1) words
  output logic signed [WIDTH-1:0] weights_out [N-1:0][(1+N)-1:0] // weights and bias for 1 layer
);
  logic signed [WIDTH-1:0] weights_memory [M-1:0] [N-1:0] [(1+N)-1:0]; // layer, neuron, weights+bias
  
  assign weights_out = weights_memory[layer_addr];
  
endmodule
