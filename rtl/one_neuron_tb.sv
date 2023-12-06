module one_neuron_tb;

  // Parameters
  parameter int N=8;
  parameter int M=3;
  parameter int WIDTH=8;

  // Signals
  logic signed [WIDTH-1:0] x[N-1:0];
  logic signed [WIDTH-1:0] w[N*N*(M+1)-1:0];
  logic signed [WIDTH-1:0] bias[M:0];
  bit soc, clk, rst;
  logic signed [WIDTH-1:0] result[N-1:0];
  logic eoc;

  // Instantiate DUT
  one_neuron #(N, M, WIDTH) dut (.*);

  state_t state;
  logic signed [N-1:0] counter1;
  // Counter2 to take care of the number of layer shift
  logic signed [N-1:0] counter2;

  logic signed [WIDTH-1:0] x_in[N:0];
  logic signed [WIDTH-1:0] x_out[N-1:0];
  logic signed [WIDTH-1:0] w_in[N-1:0];
  logic signed [WIDTH-1:0] x_out_tmp;

  assign state=dut.state;
  assign counter1=dut.counter1;
  assign counter2=dut.counter2;
  assign x_in=dut.x_in;
  assign x_out=dut.x_out;
  assign w_in=dut.w_in;
  assign x_out_tmp=dut.x_out_tmp;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation

  // Test generation
  initial begin
    // Run the test for 100 cycles
    rst = 1;
    #10 rst = 0;
    repeat (100) begin
      // Generate random values for x, w, and bias
      foreach (x[i]) x[i] = $random;
      foreach (w[i]) w[i] = $random;
      foreach (bias[i]) bias[i] = $random;

      // Set soc to start the computation
      soc = 1;

      // Wait for a few cycles
      #20;

      // Clear soc to end the computation
      soc = 0;

      // Wait for the computation to complete
      wait(eoc);
      @(posedge clk);
      // Check the result
      //$display("Result: %p", result);
    end

    // Finish the simulation
    $finish;
  end

endmodule
