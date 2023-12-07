module parallel_neuron#(
    parameter  N=4,
    parameter  WIDTH=8
)(
    input logic signed [WIDTH-1:0] x[N-1:0],  // data input
    input logic signed [WIDTH-1:0] bias,
    input logic signed [WIDTH-1:0] w[N-1:0],  // weight/bias input
    output logic signed [WIDTH-1:0] result
);

//logic [2*WIDTH+N-1:0] intermediate_input;
logic signed [2*WIDTH+$clog2(N)-1:0] intermediate_result[N:0];
//logic signed [2*WIDTH+N-1:0] intermediate_input;
logic signed [WIDTH-1:0] saturation_result;
logic signed [WIDTH-1:0] activation_result;
localparam int INT_BITS = (WIDTH == 32) ? 12 : ((WIDTH == 16) ? 6 : 3);
localparam int FRAC_BITS = (WIDTH == 32) ? 20 : ((WIDTH == 16) ? 10 : 5);

always_comb begin 
    for(int i=0;i<=N;i=i+1) begin
        if (i==0) begin
          intermediate_result[i]=bias<<FRAC_BITS; // bias
        end else begin
          intermediate_result[i]=w[i-1]*x[i-1]+intermediate_result[i-1];
        end
    end
end

saturator #(N,WIDTH,FRAC_BITS) SAT (intermediate_result[N],saturation_result);
  relu #(WIDTH) RELU (saturation_result,result);

endmodule