module n_neuron_mlp_tb #(
    parameter N = 5,
    parameter M = 3,
    parameter WIDTH = 8)();


//Inputs of the dut module
logic clk, rst_n, soc;  
logic signed [WIDTH-1:0] in [N-1:0];
//logic signed [WIDTH-1:0] bias;

//Outputs of the dut module
logic [WIDTH-1:0] out;
logic eoc;


//Logic to help with debugging
int clk_counter;


//Instantiate the dut
n_neuron_mlp #(N, M, WIDTH) dut(
    .clk(clk),
    .rst_n(rst_n),
    .soc(soc),
    .in(in),
    .out(out),
    .eoc(eoc)
);


initial begin
    //Open waveform
    $dumpfile("dump.vcd");
    $dumpvars(1, n_neuron_mlp_tb);
end

//The clock
always begin
    #5;
    clk = ~clk;
    if (clk) clk_counter += 1;
end

//Start by resetting the dut
initial begin
    clk_counter = 0;
    clk = 0;
    rst_n = 0;
    #1;
    rst_n = 1;

    //Assign values to the weight memory
    for (int i = 0; i < M; i++) begin
        for (int j = 0; i < N; j++) begin
            for (int k = 0; k < (N+1); k++) begin
                dut.weights_memory.weights_memory[i][j][k] = $random;
            end
        end
    end
    
end


always @(posedge clk) begin

    //Start computation
    if (clk_counter % M == 0) begin
        soc = 1;
        for (int i = 0; i < N; i++) begin
            in[i] = $random;
        end
    end


    $display("clk_counter: %d", clk_counter);
    $display("soc: %b", soc);
    $display("in[0]: %f", in[0]);
    $display("in[1]: %f", in[1]);
    $display("in[2]: %f", in[2]);
    $display("in[3]: %f", in[3]);
    $display("in[4]: %f", in[4]);
    $display("out: %f", out);


end











endmodule