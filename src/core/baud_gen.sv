module baud_gen
#(
    parameter clk_rate = 100000000,
    parameter baud_rate = 9600
) (
    input  logic clk,
    input  logic reset,
    output logic tick
);
    localparam DIVISOR = clk_rate / (16 * baud_rate);
    logic [15:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            tick <= 0;
        end
        else if (counter == DIVISOR - 1) begin
            counter <= 0;
            tick <= 1;
        end
        else begin
            counter <= counter + 1;
            tick <= 0;
        end

    end
endmodule