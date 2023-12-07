module data_tb #(
    parameter N = 5,
    parameter M = 3,
    parameter WIDTH = 8)();

//Input output of the data module
logic clk, rst_n, write_enable, shift;
logic [WIDTH-1:0] in_data;
logic [$clog2(N):0] write_address;
logic [WIDTH-1:0] out_data [N-1:0];


//To help see internal signals on waveform
logic [WIDTH-1:0] memory_for_input_tmp [N-1:0];
logic [WIDTH-1:0] memory_store_output_tmp [N-1:0];


//Variables for debugging
int clk_counter;
logic test_passed;


data #(N, M, WIDTH) dut(
    .rst_n(rst_n),
    .write_enable(write_enable),
    .shift(shift),
    .in_data(in_data),
    .write_address(write_address),
    .out_data(out_data)
);



initial begin
    //Open waveform
    $dumpfile("dump.vcd");
    $dumpvars(1, data_tb);
end


always begin
    #5;
    clk = ~clk;
    if (clk) clk_counter += 1;
end


initial begin
    clk = 0;
    rst_n = 0;
    #1;
    rst_n = 1;
    shift = 0;
end

always @(posedge clk) begin

    memory_for_input_tmp = dut.memory_for_input;
    memory_store_output_tmp = dut.memory_store_output;

    #1;

    write_enable = $random;
    in_data = $random;
    write_address = $urandom_range(0, N-1);
    shift = 0;

    if (clk_counter % 10 == 0) shift = 1;

    #1;

    test_passed = 0;

    //Make assertions
    if (!shift) begin
        if (write_enable) begin
            if (in_data == dut.memory_store_output[write_address]) test_passed = 1;
        end

        if (out_data == dut.memory_for_input) test_passed = 1;
    end else begin
        if (dut.memory_for_input == memory_store_output_tmp && dut.memory_store_output == '{N{'0}}) test_passed = 1;
    end

    if (test_passed) $display("TEST PASSED!");
    else $display("TEST FAILED\n",
        "rst_n: %b \n", rst_n,
        "write_enable: %b \n", write_enable,
        "in_data: %f \n", in_data,
        "write_address: %d \n", write_address,
        "shift: %b \n",
        "memory_for_input[0]: %f \n", dut.memory_for_input[0],
        "memory_for_input[1]: %f \n", dut.memory_for_input[1],
        "memory_for_input[2]: %f \n", dut.memory_for_input[2],
        "memory_for_input[3]: %f \n", dut.memory_for_input[3],
        "memory_for_input[4]: %f \n", dut.memory_for_input[4],
        "memory_store_output[0]: %f \n", dut.memory_store_output[0],
        "memory_store_output[1]: %f \n", dut.memory_store_output[1],
        "memory_store_output[2]: %f \n", dut.memory_store_output[2],
        "memory_store_output[3]: %f \n", dut.memory_store_output[3],
        "memory_store_output[4]: %f \n", dut.memory_store_output[4],
        "out_data[0]: %f \n", out_data[0],
        "out_data[1]: %f \n", out_data[1],
        "out_data[2]: %f \n", out_data[2],
        "out_data[3]: %f \n", out_data[3],
        "out_data[4]: %f \n", out_data[4]
        );

        #1;
    
end


endmodule




/*
    $display("____________________________________________");
    $display("clk_counter: %d", clk_counter);
    $display("rst_n: %b", rst_n);
    $display("write_enable: %b", write_enable);
    $display("in_data: %f", in_data);
    $display("write_address: %d", write_address);
    $display("shift: %b", shift);


    $display("memory_for_input[0]: %f", dut.memory_for_input[0]);
    $display("memory_for_input[1]: %f", dut.memory_for_input[1]);
    $display("memory_for_input[2]: %f", dut.memory_for_input[2]);
    $display("memory_for_input[3]: %f", dut.memory_for_input[3]);
    $display("memory_for_input[4]: %f", dut.memory_for_input[4]);

    $display("memory_store_output[0]: %f", dut.memory_store_output[0]);
    $display("memory_store_output[1]: %f", dut.memory_store_output[1]);
    $display("memory_store_output[2]: %f", dut.memory_store_output[2]);
    $display("memory_store_output[3]: %f", dut.memory_store_output[3]);
    $display("memory_store_output[4]: %f", dut.memory_store_output[4]);
    //for (int i = 0; i < N; i++) begin
    //    $display("memory_for_input["+i+"]: %f", dut.memory_for_input[i]);
    //end
    
    //for (int i = 0; i < N; i++) begin
    //    $display("memory_store_output["+i+"]: %f", dut.memory_store_output[i]);
    //end


    $display("out_data[0]: %f", out_data[0]);
    $display("out_data[1]: %f", out_data[1]);
    $display("out_data[2]: %f", out_data[2]);
    $display("out_data[3]: %f", out_data[3]);
    $display("out_data[4]: %f", out_data[4]);
    */