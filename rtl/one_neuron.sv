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
    input logic signed [WIDTH-1:0] x[N-1:0],  // data input
    input logic signed [WIDTH-1:0] w[N*N*(M+1)-1:0],  // weight/bias input
    input logic signed [WIDTH-1:0] bias[M:0],
    input bit soc,  // Start of computation
    input bit clk,
    input bit rst,
    output logic signed [WIDTH-1:0] result[N-1:0],
    output logic eoc  // End of computation
);

  // Counter1 to take care of the number of one layer input
  logic signed [N-1:0] counter1, next_counter1;
  // Counter2 to take care of the number of layer shift
  logic signed [N-1:0] counter2, next_counter2;

  logic signed [WIDTH-1:0] x_in[N:0];
  logic signed [WIDTH-1:0] x_out[N-1:0];
  logic signed [WIDTH-1:0] w_in[N-1:0];
   logic signed [WIDTH-1:0] x_out_tmp;

  // Current state in the FSM
  state_t state, next_state;

  parallel_neuron #(N,WIDTH) PN(x_in,w_in,x_out_tmp);

  // Combinational part
  always_comb begin
    case (state)

      idle_state: begin
        // Initialize the sum with the bias
        // provided together with the soc signal
        next_counter1 = 0;
        next_counter2 = 0;
        x_in={x,bias[counter2]};
        eoc = 0;
        next_state = (soc == 1) ? compute_state : idle_state;

      end

      // Compute the result
      compute_state: begin
        for (int i = 0; i < N; i++) begin
            w_in[i] = w[counter2*N*N + counter1*N + i];
        end
        next_counter1 = counter1 + 1;
        x_out[counter1]=x_out_tmp;
        next_state = (counter1 == N-1) ? shift_state : compute_state;
        
      end

      // Indicate the end of the result
      shift_state: begin
        next_counter2 = counter2 + 1;
        x_in={x_out,bias[counter2+1]};
        next_counter1=0;
        next_state = (counter2 == M) ?  result_state:compute_state;
      end

      result_state: begin
        eoc = 1;
        next_counter2=0;
        next_state = idle_state;
        result=x_out;
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
    if (rst == 1) begin
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
