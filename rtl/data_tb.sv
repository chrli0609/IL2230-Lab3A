module data_tb #(
    parameter N = 5,
    parameter M = 3,
    parameter WIDTH = 8)();

//Input output of the data module
logic clk, rst_n, read_write_enable, shift;
logic [WIDTH-1:0] in_data;
logic [N-1:0] access_address;
logic [WIDTH-1:0] out_data;


//To help see internal signals on waveform
logic [WIDTH-1:0] memory_for_input_dut [N-1:0] = dut.memory_for_input;
logic [WIDTH-1:0] memory_store_output_dut [N-1:0] = dut.memory_store_output;


//Variables for debugging
int clk_counter;

data #(N, M, WIDTH) dut(
    .clk(clk),
    .rst_n(rst_n),
    .read_write_enable(read_write_enable),
    .shift(shift),
    .in_data(in_data),
    .access_address(access_address),
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
    read_write_enable = $random;
    in_data = $random;
    access_address = $urandom_range(0, N-1);
    shift = 0;

    if (clk_counter % 10 == 0) shift = 1;

    #2;

    $display("____________________________________________");
    $display("clk_counter: %d", clk_counter);
    $display("rst_n: %b", rst_n);
    $display("read_write_enable: %b", read_write_enable);
    $display("in_data: %f", in_data);
    $display("access_address: %d", access_address);
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


    $display("out_data: %f", out_data);
end



endmodule