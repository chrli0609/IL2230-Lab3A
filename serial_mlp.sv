module serial_mlp #(
    parameter N,
    parameter M,
    parameter QM,
    parameter QN,
    parameter WM,
    parameter WN
    ) (
    
    input logic clk, rst_n,
    input logic [QM + QN - 1 : 0] in [N-1],
    input logic [QM + QN - 1 : 0] out
    output logic 

    );


endmodule