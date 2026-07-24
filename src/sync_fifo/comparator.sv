module comparator
#(
    parameter width=6
) (
    input  logic [width-1:0] A1,
    input  logic [width-1:0] A2,
    input  logic             WriteLast,
    output logic             E,
    output logic             F
);
    always_comb begin
        F = '0;
        E = '0;

        if (A1 == A2)
            if (WriteLast)
                F = '1;
            else
                E = '1;
    end
endmodule