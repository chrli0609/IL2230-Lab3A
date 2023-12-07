module one_neuron_tb;

  // Parameters
  localparam int N=8;
  localparam int M=3;
  localparam int WIDTH=8;

  // Signals
  logic signed [WIDTH-1:0] x_start [N-1:0];  // starting input data
  logic signed [WIDTH-1:0] x_data [N-1:0];	  // internal memory data
  logic signed [WIDTH-1:0] w [N-1:0][(1+N)-1:0];  // weight/bias input
  logic [$clog2(M)-1:0] layer_addr;  // weight/bias adress indexed by layer
  logic signed [WIDTH-1:0] data_out;	  // output data (one value)
  logic [$clog2(N)-1:0] data_write_addr; //output data adress in data memory (indexed by neuron number)
  logic data_write_en, shift_data;
  logic soc, clk, rstn;
  logic signed [WIDTH-1:0] result[N-1:0];
  logic eoc;

  // Instantiate DUT
  one_neuron #(N, M, WIDTH) dut (.*);

  //state_t state;
  logic [$clog2(N)-1:0]counter1;
  logic [$clog2(M)-1:0]counter2;

  logic signed [WIDTH-1:0] x_in[N-1:0];
  logic signed [WIDTH-1:0] w_in[N-1:0];
  logic signed [WIDTH-1:0] bias_in;
  logic signed [WIDTH-1:0] x_out_tmp;

  //assign state=dut.state;
  assign counter1=dut.counter1;
  assign counter2=dut.counter2;

  assign x_in=dut.x_in;
  assign w_in=dut.w_in;
  assign bias_in=dut.bias_in;
  assign x_out_tmp=dut.x_out_tmp;

  // mem data
  logic signed [WIDTH-1:0] weights [M-1:0] [N-1:0] [(1+N)-1:0];
  logic signed [WIDTH-1:0] data_1[N-1:0];
  logic signed [WIDTH-1:0] data_2[N-1:0];
  initial begin
    data_1='{default: '0};
    data_2='{default: '0};
  end
  assign x_data = data_2;
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Simulate data memory
  // read, write and shift data
  initial forever begin
    @(posedge clk) begin
      if (data_write_en == 1) begin
        data_1[data_write_addr] = data_out;
      end
      if (shift_data) begin
        data_2 = data_1;
      end
    end
  end

  // simulate weight memory
  assign w = weights[layer_addr];


  //debug
  logic signed [WIDTH-1:0] w00;
  assign w00 = w[0][0];
  logic signed [WIDTH-1:0] w00_;
  assign w00_ = weights[1][0][0];
  logic signed [WIDTH-1:0] d0_0;
  assign d0_0 = data_1[1];
  logic signed [WIDTH-1:0] d1_0;
  assign d1_0 = data_2[1];
  



  // Test generation
  initial begin
    // Run the test for 100 cycles
    rstn = 0;
    soc=0;
    #10 rstn = 1;
    repeat (10) begin
      // Generate random values for weights (+ bias) and input data
      foreach (x_start[i]) x_start[i] = $random >> 2;
      for (int i = 0; i<M; i++) begin
        for (int j = 0; j<N; j++) begin
          for (int k = 0; k<N+1; k++) begin
            weights[i][j][k] = $random >> 2;
          end
        end
      end

      // Set soc to start the computation
      soc = 1;
      #20;
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
