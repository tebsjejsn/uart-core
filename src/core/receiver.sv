module receiver(
    input  logic       clk,
    input  logic       reset,
    input  logic       tick,
    input  logic       rx,
    output logic [7:0] data,
    output logic       en,
    output logic       err
);
    typedef enum logic [1:0] {
        IDLE,
        START,
        SAMPLE,
        FINISH
    } statetype;

    statetype state;
    statetype nextState;

    logic       rxSync1;
    logic       rxSync2;
    logic [7:0] word;
    logic [4:0] initialCount;
    logic [2:0] bitCount;

    always_ff @(posedge clk) begin
        rxSync1 <= rx;
        rxSync2 <= rxSync1;
    end

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            initialCount <= '0;
            bitCount <= '0;
            word <= '0;
        end
        else begin
            if (state == IDLE) begin
                initialCount <= '0;
                bitCount <= '0;
                word <= '0;
            end
            else if (state == START) begin
                if (tick == '1) 
                    if (initialCount == 5'd7)
                        initialCount <= '0;
                    else
                        initialCount <= initialCount + 1;
            end
            else if (state == SAMPLE) begin
                if (tick == '1) begin
                    if (initialCount == 5'd15) begin
                        word <= word >> 1;
                        word[7] <= rxSync2;

                        if (bitCount == 3'd7) begin
                            initialCount <= '0;
                            bitCount <= '0;
                        end
                        else begin
                            bitCount <= bitCount + 1;
                            initialCount <= '0;
                        end
                    end
                    else
                        initialCount <= initialCount + 1;
                end
            end
            else if (state == FINISH) begin
                if (tick == '1) begin
                    if (initialCount != 5'd15) begin
                        initialCount <= initialCount + 1;
                    end
                    else
                        initialCount <= '0;
                end
            end
            state <= nextState;
        end
    end

    always_comb begin
        nextState = state;
        data = '0;
        en = '0;
        err = '0;

        case (state)
            IDLE:
                if (rxSync2 == '0)
                    nextState = START;
            START:
                if (tick == '1 && initialCount == 5'd7)
                    nextState = SAMPLE;
            SAMPLE:
                if (tick == '1 && initialCount == 5'd15)
                    if (bitCount == 3'd7)
                        nextState = FINISH;
            FINISH: 
                if (tick == '1 && initialCount == 5'd15)
                    if (rxSync2 == '1) begin
                        nextState = IDLE;

                        data = word;
                        en = '1;
                        err = '0;
                    end
                    else begin
                        nextState = IDLE;
                        err = '1; 
                    end
            default: nextState = IDLE;
        endcase
    end
endmodule