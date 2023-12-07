module data #(
    //Decide how big the shift register needs to be
    parameter N,
    parameter M,
    parameter WIDTH
) (
    //Need to have 2*N memory segments (one for each input and ouput in each neuron layer)
    input logic rst_n, write_enable,  //0 is read, 1 is write
    input logic shift,                          //For shifting all the data from memory_store_output to memory_for_input (used during the shift state)
    input logic [WIDTH-1:0] in_data,            //From one_neuron.results
    input logic [$clog2(N):0] write_address,         //To specify which address space we are reading from/writing to

    output logic [WIDTH-1:0] out_data [N-1:0]          //The data that is sent into the neuron for calculation (to be assigned to one_neuron.x)
);

//Two memories
logic [WIDTH-1:0] memory_for_input [N-1:0];         //For storing the input data (will be read and assigned to one_neuron.x)
logic [WIDTH-1:0] memory_store_output [N-1:0];      //For storing the output from the neuron (will be assigned from one_neuron.result)

always_comb begin
    //If we are NOT resetting
    if (rst_n) begin
        //If shift then we move all data from memory_store_output to memory_for input
        //NOTE: if we shift then we can neither read nor write!!!
        if (shift) begin
            memory_for_input = memory_store_output;
            memory_store_output = '{N{'0}};
        end
        else begin
            //Read from memory
                out_data = memory_for_input;

            //Write to memory
            if(write_enable) begin
                memory_store_output[write_address] = in_data;
            end
        end

    //If we are resetting
    end else begin
        memory_for_input = '{N{'0}};
        memory_store_output = '{N{'0}};
    end

end



endmodule