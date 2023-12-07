module saturator #(
  parameter int N,
  parameter int WIDTH,
  parameter int WIDTH_FRACTIONAL
) (
  input logic signed [2*WIDTH + $clog2(N)-1:0] result,
  output logic signed [WIDTH-1:0] result_sat
);
  logic signed [2*WIDTH + $clog2(N)-WIDTH_FRACTIONAL-1:0] result_temp;
  assign result_temp = result [2*WIDTH + $clog2(N)-1:WIDTH_FRACTIONAL];

  always_comb begin
    if (result_temp > 2**(WIDTH-1)-1 ) begin
      result_sat=2**(WIDTH-1)-1;
    end
    else if (result_temp < -(2**(WIDTH-1))) begin
      result_sat=-(2**(WIDTH-1));
    end
    else begin
      result_sat = result_temp[WIDTH-1:0];
    end
  end
endmodule