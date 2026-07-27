module uart_datapath(
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
    logic       tick;
    logic [7:0] ReceiverOut;
    logic       ReceiverEn;
    logic       TransmitterE;
    logic       TransmitterNotE;
    logic [7:0] TransmitterIn;
    logic       TransmitterEn;

    baud_gen #(.clk_rate(100000000), .baud_rate(9600)) baudgen (
        .clk,
        .reset,
        .tick
    );

    receiver rcvr (
        .clk,
        .reset,
        .tick,
        .rx,
        .data(ReceiverOut),
        .en(ReceiverEn),
        .err
    );

    transmitter trnmtr (
        .clk,
        .reset,
        .tick,
        .notE(TransmitterNotE),
        .dataIn(TransmitterIn),
        .tx,
        .en(TransmitterEn)
    );

    fifo_datapath dprec (
        .clk,
        .reset,
        .WR(ReceiverEn),
        .RD(rd_en),
        .WD2(ReceiverOut),
        .RD1Out(rd_data),
        .F(rx_F),
        .E(rx_E)
    );

    fifo_datapath dptrans (

        .clk,
        .reset,
        .WR(wr_en),
        .RD(TransmitterEn),
        .WD2(wr_data),
        .RD1Out(TransmitterIn),
        .F(tx_F),
        .E(TransmitterE)
    );

    assign TransmitterNotE = ~TransmitterE;
endmodule