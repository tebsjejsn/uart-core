module datapath(
    input  logic        clk,
    input  logic        reset,
    input  logic        WR,
    input  logic        RD,
    input  logic [31:0] WD2,
    output logic [31:0] RD1Out,
    output logic        F,
    output logic        E
);
    logic [5:0]  A1Next;
    logic [5:0]  A1;
    logic [5:0]  A2Next;
    logic [5:0]  A2;
    logic        WriteLast;
    logic [31:0] RD1Next;
    logic        WE2;
    logic        RE1;

    flopr #(.width(6)) A1_flopr (
        .clk,
        .reset,
        .d(A1Next),
        .q(A1)
    );

    flopr #(.width(6)) A2_flopr (
        .clk,
        .reset,
        .d(A2Next),
        .q(A2)
    );

    flopr #(.width(32)) RD1 (
        .clk,
        .reset,
        .d(RD1Next),
        .q(RD1Out)
    );

    counter A1_count (
        .a(A1),
        .s(RE1),
        .y(A1Next)
    );

    counter A2_count (
        .a(A2),
        .s(WE2),
        .y(A2Next)
    );

    comparator cmp (
        .A1,
        .A2,
        .WriteLast,
        .E,
        .F
    );

    enable en (
        .clk,
        .reset,
        .WE2,
        .RE1,
        .WriteLast
    );

    reg_file rf (
        .clk,
        .A2,
        .WD2,
        .WE2,
        .A1,
        .RE1,
        .RD1(RD1Next)
    );

    assign WE2 = WR && !F;
    assign RE1 = RD && !E;
endmodule