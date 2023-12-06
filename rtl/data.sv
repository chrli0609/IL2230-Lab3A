module data #(
    //Decide how big the shift register needs to be
    parameter N,
    parameter M,
    parameter WIDTH
) (
    //Need to have 2*N memory segments (one for each input and ouput in each neuron layer)
    input logic clk, rst_n, read_write_enable, //0 is read, 1 is write
    input logic [WIDTH-1:0] in_data,        //From one_neuron.results
    input logic [N-1:0] access_address,     //To specify which address space we are reading from/writing to

    output logic [WIDTH-1:0] out_data       //The data that is sent into the neuron for calculation (to be assigned to one_neuron.x)
);

//Two memories
logic [N-1:0] memory_for_input [N-1:0];     //For storing the input data (will be read and assigned to one_neuron.x)
logic [N-1:0] memory_store_output [N-1:0];  //For storing the output from the neuron (will be assigned from one_neuron.result)

always_ff @(posedge clk) begin
    //Read from memory
    if (read_write_enable) begin
        out_data = memory_for_input[access_address];
    end

    //Write from memory
    else begin
        memory_store_output[access_address] = in_data;
    end

end



endmodule