module data #(
    //Decide how big the shift register needs to be
    parameter N,
    parameter M,
    parameter WIDTH
) (
    //Need to have 2*N memory segments (one for each input and ouput in each neuron layer)
    input logic rst_n, 
    input logic write_enable,
    input logic eoc,  
    input logic shift_data,                          //For shifting all the data from memory_store_output to memory_for_input (used during the shift state)
    input logic [WIDTH-1:0] in_data,            //From one_neuron.results
    input logic [$clog2(N):0] data_write_addr,         //To specify which address space we are reading from/writing to
    input logic clk,

    output logic [WIDTH-1:0] out_data [N-1:0]          //The data that is sent into the neuron for calculation (to be assigned to one_neuron.x)
);

//Two memories
logic [WIDTH-1:0] memory_reg [N-1:0];         //For storing the input data (will be read and assigned to one_neuron.x)
logic [WIDTH-1:0] memory_data [N-1:0];      //For storing the output from the neuron (will be assigned from one_neuron.result)

always @(posedge clk) begin
    if(!rst_n) begin
        memory_reg = '{N{'0}};
        memory_data = '{N{'0}};
    end
    else if(eoc) begin
        out_data = memory_reg;
    end
    else if(shift_data) begin
        memory_data = memory_reg;
    end 
    else begin //write_enable == 1
        memory_reg[data_write_addr] = in_data;
    end
end


endmodule