module counter(
    input  logic [5:0] a,
    input  logic       s,
    output logic [5:0] y
);
    always_comb begin
        if (s)
            if (a != 6'd63)
                y = a + 1;
            else
                y = '0;
        else
            y = a;
    end
endmodule