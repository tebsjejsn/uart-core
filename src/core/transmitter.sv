module transmitter(
    input  logic       clk,
    input  logic       reset,
    input  logic       tick,
    input  logic       notE,
    input  logic [7:0] dataIn,
    output logic       tx,
    output logic       en
);
    // LOAD3 and LOAD4 removed
    typedef enum logic [2:0] {
        IDLE,
        LOAD1,
        LOAD2,
        START,
        SEND,
        FINISH
    } statetype;

    statetype state, nextState;

    logic [4:0] initialCount;
    logic [2:0] bitCount;
    logic [7:0] data;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            tx <= '1;
            en <= '0;
            initialCount <= '0;
            bitCount <= '0;
            data <= '0;
        end
        else 
            if (state == IDLE) begin
                initialCount <= '0;
                bitCount <= '0;
                tx <= '1;

                if (tick == '1 && notE == '1) begin
                    en <= '1;
                end
            end
            else if (state == LOAD1) begin
                en <= '0;
            end
            else if (state == LOAD2) begin
                // Data is valid on dataIn right now, capture it!
                data <= dataIn;
            end
            else if (state == START) begin
                tx <= '0;
                
                if (tick == '1)
                    if (initialCount != 5'd15)
                        initialCount <= initialCount + 1;
                    else
                        initialCount <= '0;
            end
            else if (state == SEND) begin
                tx <= data[0];

                if (tick == '1) begin
                    if (initialCount == 5'd15) begin
                        data <= data >> 1;

                        if (bitCount == 3'd7) begin
                            initialCount <= '0;
                            bitCount <= '0;
                        end
                        else begin
                            initialCount <= '0;
                            bitCount <= bitCount + 1;
                        end
                    end
                    else
                        initialCount <= initialCount + 1;
                end
            end
            else if (state == FINISH) begin
                tx <= '1;

                if (tick == '1)
                    if (initialCount == 5'd15)
                        initialCount <= '0;
                    else
                        initialCount <= initialCount + 1;
            end

            state <= nextState;
    end

    always_comb begin
        nextState = state;

        case (state)
            IDLE:
                if (tick == '1 && notE == '1)
                    nextState = LOAD1;
            LOAD1:
                nextState = LOAD2;
            LOAD2:
                nextState = START;
            START: 
                if (tick == '1 && initialCount == 5'd15)
                    nextState = SEND;
            SEND:
                if (tick == '1 && initialCount == 5'd15 && bitCount == 3'd7)
                    nextState = FINISH;
            FINISH:
                if (tick == '1 && initialCount == 5'd15)
                    nextState = IDLE;
            default:
                nextState = IDLE;
        endcase
    end
endmodule