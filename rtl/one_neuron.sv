typedef enum {
  idle_state,
  compute_state,
  shift_state,
  result_state
} state_t;

// The module is implemented as an FSM
module one_neuron #(
  parameter int N=4,
  parameter int M=2,
  parameter int WIDTH=8
) (
  input logic signed [WIDTH-1:0] x_start [N-1:0],  // starting input data
  input logic signed [WIDTH-1:0] x_data [N-1:0],	  // internal memory data
  input logic signed [WIDTH-1:0] w [N-1:0][(1+N)-1:0] ,  // weight/bias input
  output logic [$clog2(M)-1:0] layer_addr,  // weight/bias adress indexed by layer
  output logic signed [WIDTH-1:0] data_out,		  // output data (one value)
  output logic [$clog2(N)-1:0] data_write_addr, //output data adress in data memory (indexed by neuron number)
  output logic data_write_en, shift_data,
  input bit soc,  // Start of computation
  input bit clk,
  input bit rstn,
  output logic signed [WIDTH-1:0] result[N-1:0],
  output logic eoc  // End of computation
);

  localparam int INT_BITS = (WIDTH == 32) ? 12 : ((WIDTH == 16) ? 6 : 3);
  localparam int FRAC_BITS = (WIDTH == 32) ? 20 : ((WIDTH == 16) ? 10 : 5);

  // Counter1 counts the number of neurons
  logic [$clog2(N)-1:0] counter1, next_counter1;
  // Counter2 counts the number of layers
  logic [$clog2(M)-1:0] counter2, next_counter2;

  // neuron signals
  logic signed [WIDTH-1:0] x_in[N-1:0];
  logic signed [WIDTH-1:0] bias_in;
  logic signed [WIDTH-1:0] w_in[N-1:0];
  logic signed [WIDTH-1:0] x_out_tmp;

  // Current state in the FSM
  state_t state, next_state;

  parallel_neuron #(N,WIDTH) PN(x_in,bias_in,w_in,x_out_tmp);

  // Combinational part
  always_comb begin
    x_in = '{default: '0};
    w_in = '{default: '0};
    bias_in = 0;
    data_write_en = 0;
    shift_data = 0;
    layer_addr = counter2;

    case (state)
      // do nothing and reset counters
      idle_state: begin
        // Initialize the sum with the bias
        // provided together with the soc signal
        next_counter1 = 0;
        next_counter2 = 0;
        eoc = 0;
        next_state = (soc == 1) ? compute_state : idle_state;

      end

      // Compute one neuron
      compute_state: begin
        if (counter2 == 0) begin
          x_in = x_start; // in first layer
        end
        else begin
          x_in = x_data;  // in other layers
        end
        bias_in = w[counter1][0]; // set bias for this neuron
        w_in = w[counter1][N:1];  // set weights for this neuron

        data_out = x_out_tmp;   // save data to data memory
        data_write_addr = counter1;
        data_write_en = 1;

        next_counter1 = counter1 + 1;
        next_state = (counter1 == N-1) ? shift_state : compute_state;
      end

      // change layers
      shift_state: begin
        next_counter2 = counter2 + 1;
        shift_data = 1; // shift output data to input in data memory; even after last layer!!
        next_counter1=0; // reset neuron counter
        next_state = (counter2 == M-1) ?  result_state:compute_state;
      end

      // output result
      result_state: begin
        eoc = 1;
        next_counter2=0;
        next_state = idle_state;
        result=x_data;
      end

      default: begin
        eoc = 0;
        next_state = idle_state;
        next_counter1 = 0;
        next_counter2 = 0;

      end

    endcase
  end

  // Update registers
  always_ff @(posedge clk) begin
    if (rstn == 0) begin
      counter1 <= 0;
      counter2 <= 0;
      state <= idle_state;
    end else begin
      counter1 <= next_counter1;
      counter2 <= next_counter2;
      state <= next_state;
    end
  end

endmodule
