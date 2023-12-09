module n_neuron_fsm #(parameter N, parameter M, parameter WIDTH) (
    input logic clk, rst_n, soc,
    output logic [$clog2(M)-1:0] m_reg,
    output logic weights_read_enable, compute_enable, eoc
);

//define iterator variable (iterate over the layers)
logic [$clog2(M)-1:0] m_next;

//Just to register the eoc signal
logic eoc_next;

//register the weights_read_enable signal
logic next_weights_read_enable;

//Define states
typedef enum logic [1:0] {
    IDLE = 2'b00,
    COMPUTE = 2'b01,
    ERROR = 2'b10
} state;

state curr_state, next_state;


//For handling state transitions
always_comb begin
    case (curr_state)

        IDLE : begin
            if (soc) next_state = COMPUTE;
            else next_state = IDLE;
        end

        COMPUTE : begin
            if (m_reg < M) next_state  = COMPUTE;
            else next_state = IDLE;
        end

        default : next_state = ERROR;

    endcase
end



//For handling the control signals
always_comb begin
    case (curr_state)

        IDLE : begin
            m_next = 0;

            if (next_state == COMPUTE) weights_read_enable = 1;
            else weights_read_enable = 0;
            compute_enable = 0;
            eoc_next = 0;
        end

        COMPUTE : begin
            weights_read_enable = 1;
            compute_enable = 1;

            m_next = m_reg + 1;

            if (m_reg == M) eoc_next = 1;
        end


    endcase

end

//For registering the logic signals
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        m_reg <= 0;
        eoc <= 0;
    end else begin
        m_reg <= m_next;
        eoc <= eoc_next;
    end

end


//For registering the state
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) curr_state = IDLE;
    else curr_state = next_state;
end


endmodule