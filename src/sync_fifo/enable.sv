module enable(
    input  logic clk,
    input  logic reset,
    input  logic WE2,
    input  logic RE1,
    output logic WriteLast
);
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            WriteLast <= '0;
        else if (WE2 && !RE1)
            WriteLast <= '1;
        else if (RE1 && !WE2)
            WriteLast <= '0;
    end
endmodule