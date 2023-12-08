`include "../parallel_neuron.sv"

//This is for the N neuron implementation of the MLP

module n_neuron_mlp #(
    parameter N,
    parameter M,
    parameter WIDTH
) (
    input logic clk, rst_n, soc,
    input logic signed [WIDTH-1:0] in [N-1:0],
    //input logic signed [WIDTH-1:0] bias,
    output logic signed [WIDTH-1:0] out,
    output logic eoc
);

//Internal logic

//To send the weights from the weight memory to the neurons
//logic signed [WIDTH-1:0] weight [N-1:0];

//To send to result from the neurons to the register
logic signed [WIDTH-1:0] results_from_neurons [N-1:0];

//The registered values (that comes from the results of the neurons), will be used in the next iteration of neuron computations
logic signed [WIDTH-1:0] next_inputs_to_neurons [N-1:0];


//Intermediary logic to handle the input to the neurons (N number of weights for N number of neurons)
logic signed [WIDTH-1:0] to_neurons [N-1:0];

//Intermediary logic to handle to bias to the neurons
logic signed [WIDTH-1:0] bias_to_neurons;



//Input output of the fsm
logic [$clog2(M)-1:0] m_reg;
logic weights_read_enable, compute_enable;


//Instantiate the fsm
n_neuron_fsm #(N, M, WIDTH) fsm(
    .clk(clk),
    .rst_n(rst_n),
    .soc(soc),
    .m_reg(m_reg),
    .weights_read_enable(weights_read_enable),
    .compute_enable(compute_enable),
    .eoc(eoc)
);



//Input output logic for weights memory
logic read_enable;
logic [$clog2(M)-1:0] layer_address;
logic signed [WIDTH-1:0] weights_to_neurons [N-1:0] [N-1:0];



//instantiate weights memory
n_weights_memory #(N, M, WIDTH) weights_memory(
    .clk(clk),
    .rst_n(rst_n),
    .read_enable(read_enable),
    .layer_address(layer_address),
    .bias_to_neurons(bias_to_neurons),
    .weights_to_neurons(weights_to_neurons)
);

//Assign the the layer_address to m_reg
assign layer_address = m_reg;






//instantiate all the neurons
genvar i;
generate
    for (i = 0; i < N; i++) begin
        parallel_neuron #(N, WIDTH) neron(to_neurons, bias_to_neurons, weights_to_neurons[i], results_from_neurons[i]);
    end
endgenerate


always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        next_inputs_to_neurons <= '{N{'0}};
    end else begin
        next_inputs_to_neurons <= results_from_neurons;
    end

end

//always_comb


//To handle the inputs to the neurons
always_comb begin
    //First layer should receive inputs from input while the rest should receive it from the register
    if (m_reg == 0) begin
        to_neurons = in;
    end
    
    else begin
        to_neurons = next_inputs_to_neurons;
    end 

        
end




endmodule