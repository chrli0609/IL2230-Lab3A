module n_neuron_fsm #(parameter N, parameter M, parameter WIDHT) (
    input logic clk, rst_n, soc,
    output logic [$clog2(M)-1:0] m_reg,
    output logic weights_read_enable, compute_enable, eoc
);

//define iterator variable (iterate over the layers)
logic [$clog2(M)-1:0] m_next;

//Just to register the eoc signal
logic eoc_next;

//Define states
typedef enum logic {
    IDLE = 1'b0,
    COMPUTE = 1'b1
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

        default : next_state = IDLE;

    endcase
end



//For handling the control signals
always_comb begin
    case (curr_state)

        IDLE : begin
            m_next = 0;

            weights_read_enable = 0;
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


always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        m_reg <= 0;
        eoc <= 0;
    end else begin
        eoc <= eoc_next;
    end

end


endmodule