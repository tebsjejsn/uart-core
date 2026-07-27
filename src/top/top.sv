module top(
    input  logic       clk,
    input  logic       reset,
    input  logic       rx,
    input  logic       rd_en,
    input  logic [7:0] wr_data,
    input  logic       wr_en,
    output logic       tx,
    output logic       rx_F,
    output logic [7:0] rd_data,
    output logic       rx_E,
    output logic       tx_F,
    output logic       err
);
    uart_datapath dp (
        .clk,
        .reset,
        .rx,
        .rd_en,
        .wr_data,
        .wr_en,
        .tx,
        .rx_F,
        .rd_data,
        .rx_E,
        .tx_F,
        .err
    );
endmodule
