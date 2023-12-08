module n_weights_memory #(N, M, WIDTH) (
    input logic clk, rst_n, read_enable,
    input logic [$clog2(M)-1:0] layer_address,
    output logic signed [WIDTH-1:0] weights_to_neurons [N-1:0] [N-1:0],
    output logic signed [WIDTH-1:0] bias_to_neurons
);

//Define the memory
logic signed [WIDTH-1:0] weights_memory [M-1:0] [N-1:0] [N-1:0]; // layer, neuron, weights
logic signed [WIDTH-1:0] bias_memory [M-1:0]; //each layer has the same bias



always_ff @(posedge clk, negedge rst_n) begin
    if(read_enable) begin
        weights_to_neurons = weights_memory[layer_address];
        bias_to_neurons = bias_memory[layer_address];
    end

end


endmodule