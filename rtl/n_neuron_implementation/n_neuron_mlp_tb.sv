module n_neuron_mlp_tb #(parameter N = 5, parameter M = 3, parameter WIDTH = 8)();


//Inputs of the dut module
logic clk, rst_n, soc;  
logic signed [WIDTH-1:0] in [N-1:0];
//logic signed [WIDTH-1:0] bias;

//Outputs of the dut module
logic signed [WIDTH-1:0] out [N-1:0];
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


//clock generation
always begin
    #5ns clk = ~clk; 
    if (clk) clk_counter += 1;
end
/*
//The clock
initial begin
    clk = 0;
    
    forever begin
        $display("sjsangosnsoaoefganefaefa=====================================");
        $finish;
        #5;
        clk = ~clk;
        if (clk) clk_counter += 1;
        $display("clk_counter: %d",clk_counter);
    end
end
*/

//Start by resetting the dut
initial begin
    clk_counter = 0;
    clk = 0;
    rst_n = 0;
    #1;
    rst_n = 1;



    
    //Assign values to the weight memory
    foreach(dut.weights_memory.weights_memory[i])
        foreach(dut.weights_memory.weights_memory[i][j])
            foreach(dut.weights_memory.weights_memory[i][j][k])
                dut.weights_memory.weights_memory[i][j][k] = $random;

    //assign values to the bias memory
    foreach(dut.weights_memory.bias_memory[i])
        dut.weights_memory.bias_memory[i] = $random;
end


always @(posedge clk) begin

    //Start computation
    if (clk_counter % M == 0) begin
        soc = 1;
        
        foreach(in[i])
            in[i] = $random;
        
    end

    #2;
    if (clk_counter >= 3) begin
        $display("===================================================");
        $display("clk_counter: %d", clk_counter);
        $display("curr_state: %0s", dut.fsm.curr_state.name());
        $display("next_state: %0s", dut.fsm.next_state.name());
        $display("soc: %b", soc);
        $display("dut.soc: %b", dut.soc);
        $display("dut.fsm.soc: %b", dut.fsm.soc);
        foreach (in[i])
            $display("in[%0d]: %f", i, in[i]);
        foreach (dut.to_neurons[i])
            $display("dut.to_neurons[%0d]: %f", i, dut.to_neurons[i]);

        foreach (dut.loop_neuron[0].neuron.x[i]) 
            $display("dut.loop_neuron[0].neuron.x[%0d]: %f", i, dut.loop_neuron[0].neuron.x[i]);
        foreach (dut.loop_neuron[1].neuron.x[i]) 
            $display("dut.loop_neuron[1].neuron.x[%0d]: %f", i, dut.loop_neuron[1].neuron.x[i]);
        foreach (dut.loop_neuron[2].neuron.x[i]) 
            $display("dut.loop_neuron[2].neuron.x[%0d]: %f", i, dut.loop_neuron[2].neuron.x[i]);
        foreach (dut.loop_neuron[3].neuron.x[i]) 
            $display("dut.loop_neuron[3].neuron.x[%0d]: %f", i, dut.loop_neuron[3].neuron.x[i]);
        foreach (dut.loop_neuron[4].neuron.x[i]) 
            $display("dut.loop_neuron[4].neuron.x[%0d]: %f", i, dut.loop_neuron[4].neuron.x[i]);


        
        $display("dut.loop_neuron[0].neuron.w: %f", dut.loop_neuron[0].neuron.w);
        $display("dut.loop_neuron[1].neuron.w: %f", dut.loop_neuron[1].neuron.w);
        $display("dut.loop_neuron[2].neuron.w: %f", dut.loop_neuron[2].neuron.w);
        $display("dut.loop_neuron[3].neuron.w: %f", dut.loop_neuron[3].neuron.w);
        $display("dut.loop_neuron[4].neuron.w: %f", dut.loop_neuron[4].neuron.w);


        foreach (dut.weights_to_neurons[i])
            foreach(dut.weights_to_neurons[i][j])
                $display("dut.weights_to_neurons[%0d][%0d]: %f", i, j, dut.weights_to_neurons[i][j]);

        
        foreach (dut.weights_memory.weights_to_neurons[i])
            foreach(dut.weights_memory.weights_to_neurons[i][j])
                $display("dut.weights_memory.weights_to_neurons[%0d][%0d]: %f", i, j, dut.weights_memory.weights_to_neurons[i][j]);
        
        
        foreach(dut.weights_memory.weights_memory[i])
        foreach(dut.weights_memory.weights_memory[i][j])
            foreach(dut.weights_memory.weights_memory[i][j][k])
                $display("dut.weights_memory.weights_memory[%0d][%0d][%0d]: %f", i, j, k, dut.weights_memory.weights_memory[i][j][k]);
        
        $display("dut.weights_read_enable: %b", dut.weights_read_enable);
        $display("dut.fsm.m_reg: %d", dut.fsm.m_reg);
        $display("dut.layer_address: %d", dut.layer_address);
        $display("dut.fsm.eoc: %b", dut.fsm.eoc);
        $display("dut.eoc: %b", dut.eoc);
        $display("eoc: %b", eoc);

        $display("dut.bias_to_neurons: %f", dut.bias_to_neurons);
        $display("dut.to_neurons[0]:%f", dut.to_neurons[0]);
        $display("dut.weights_to_neurons[0][0]: %f", dut.weights_to_neurons[0][0]);
        $display("dut.loop_neuron[0].neuron.FRAC_BITS: %f", dut.loop_neuron[0].neuron.FRAC_BITS);
        $display("dut.to_neurons[0]*dut.weights_to_neurons[0][0]: %f", dut.to_neurons[0]*dut.weights_to_neurons[0][0]);
        $display("dut.bias_to_neurons<<dut.loop_neuron[0].neuron.FRAC_BITS: %f", dut.bias_to_neurons<<dut.loop_neuron[0].neuron.FRAC_BITS);
        $display("I calculate intermediate result myself: %f", dut.to_neurons[0]*dut.weights_to_neurons[0][0]+(dut.bias_to_neurons<<dut.loop_neuron[0].neuron.FRAC_BITS));

        foreach(dut.loop_neuron[0].neuron.intermediate_result[i])
            $display("dut.loop_neuron[0].neuron.intermediate_result[%0d]: %f", i, dut.loop_neuron[0].neuron.intermediate_result[i]);
        foreach(dut.loop_neuron[1].neuron.intermediate_result[i])
            $display("dut.loop_neuron[1].neuron.intermediate_result[%0d]: %f", i, dut.loop_neuron[1].neuron.intermediate_result[i]);
        foreach(dut.loop_neuron[2].neuron.intermediate_result[i])
            $display("dut.loop_neuron[2].neuron.intermediate_result[%0d]: %f", i, dut.loop_neuron[2].neuron.intermediate_result[i]);
        foreach(dut.loop_neuron[3].neuron.intermediate_result[i])
            $display("dut.loop_neuron[3].neuron.intermediate_result[%0d]: %f", i, dut.loop_neuron[3].neuron.intermediate_result[i]);
        foreach(dut.loop_neuron[4].neuron.intermediate_result[i])
            $display("dut.loop_neuron[4].neuron.intermediate_result[%0d]: %f", i, dut.loop_neuron[4].neuron.intermediate_result[i]);
        
        
        $display("dut.loop_neuron[0].neuron.result: %f", dut.loop_neuron[0].neuron.result);
        $display("dut.loop_neuron[1].neuron.result: %f", dut.loop_neuron[1].neuron.result);
        $display("dut.loop_neuron[2].neuron.result: %f", dut.loop_neuron[2].neuron.result);
        $display("dut.loop_neuron[3].neuron.result: %f", dut.loop_neuron[3].neuron.result);
        $display("dut.loop_neuron[4].neuron.result: %f", dut.loop_neuron[4].neuron.result);

        foreach(dut.results_from_neurons[i])
            $display("dut.results_from_neurons[%0d]: %f", i, dut.results_from_neurons[i]);

        foreach(out[i])
            $display("out[%0d]: %f", i, out);
    end


end



endmodule
