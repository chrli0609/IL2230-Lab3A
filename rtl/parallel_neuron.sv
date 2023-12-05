module parallel_neuron#(
    parameter  N=4,
    parameter  WIDTH=8
)(
    input logic clk,
    input logic rst,
    input logic signed [WIDTH-1:0] x[N:0],  // data input
    input logic signed [WIDTH-1:0] w[N:0],  // weight/bias input
    output logic signed [WIDTH-1:0] result
);

//logic [2*WIDTH+N-1:0] intermediate_input;
logic signed [2*WIDTH+N-1:0] intermediate_result[N:0];
//logic signed [2*WIDTH+N-1:0] intermediate_input;
logic signed [WIDTH-1:0] saturation_result;
logic signed [WIDTH-1:0] activation_result;
localparam int INT_BITS = (WIDTH == 32) ? 12 : ((WIDTH == 16) ? 6 : 3);
localparam int FRAC_BITS = (WIDTH == 32) ? 20 : ((WIDTH == 16) ? 10 : 5);

always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        result<=0;
    end else begin
        result<=activation_result;
    end
end

genvar i;   
generate
for(i=0;i<=N;i=i+1) begin
    if (i==0) begin
        mac #(N,WIDTH) MAC (1<<FRAC_BITS,x[i],0,intermediate_result[i]);
    end else begin
        mac #(N,WIDTH) MAC (w[i],x[i],intermediate_result[i-1],intermediate_result[i]);
    end
end
saturation #(N,WIDTH) SAT (intermediate_result[N],saturation_result);
sigmoid SIG (saturation_result,activation_result);
endgenerate

endmodule