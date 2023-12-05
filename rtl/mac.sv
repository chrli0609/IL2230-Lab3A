module mac #(parameter N = 4, parameter WIDTH=8) (  
    //current_clk_stage means the current clk step, can use genvar to instantiate each MAC step
    input logic signed [WIDTH-1:0] a,
    input logic signed [WIDTH-1:0] b,
    input logic signed [2*WIDTH+N-1:0] c,
    output logic signed [2*WIDTH+N-1:0] result
);

always_comb begin
    result=a*b+c;
end

endmodule