module serial_mlp #(
	parameter N, //Represents the number of inputs to the MLP (not necessarily the same as in parallel_neuron.sv)
	parameter M, //The number of layers in the MLP
 	parameter WIDTH
) (
					        
	input logic clk, rst_n, start,
	input logic [WIDTH - 1 : 0] in [N-1:0],
	output logic [WIDTH- 1 : 0] out
);


//Internal logic for the fsm
logic [$clog2(N)-1:0] n_reg;		//The number of bits required to be able to represent all neurons (N)
logic [$clog2(N)-1:0] n_next;

logic [$clog2(M)-1:0] m_reg;		//The number of bits required to be able to represent all layers (M)
logic [$clog2(M)-1:0] m_next;



//FSM states
typedef enum logic [1:0] {
	idle = 2'b00,
	calculate = 2'b01,
	shift = 2'b10
} state;

state curr_state, next_state;


//For moving the current state to the next state
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		curr_state <= idle;
	end else begin
		curr_state <= next_state;
	end
end


//For deciding which state to enter
always_comb begin
	
	case (curr_state)

	
	idle : begin
		if (start) next_state = calculate;
		else next_state = idle;
	end

	//If n == N then enter shift state, else keep running calculate
	calculate : begin
		if (n_reg == N) next_state = shift;
		else next_state = calculate;
	end

	//If m == M then we are done and we can reenter idle, else go back to calculate
	shift : begin
		if (m_reg == M) next_state = idle;
		else next_state = calculate;
	end

	endcase

end



endmodule
