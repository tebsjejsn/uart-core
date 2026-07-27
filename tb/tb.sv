module tb();
    logic       clk;
    logic       reset;
    logic       rx;
    logic       rd_en;
    logic [7:0] wr_data;
    logic       wr_en;
    logic       tx;
    logic       rx_F;
    logic [7:0] rd_data;
    logic       rx_E;
    logic       tx_F;
    logic       err;

    integer     trace_file;
    integer     scan_line;
    logic [7:0] data;

    top dut (
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

    always begin
        #3;
        clk = ~clk;
    end

    initial begin
        wr_en = 0;
        wr_data = '0;
        rd_en = 0;

        trace_file = $fopen("data/inputs.txt", "r");
        if (trace_file == 0) begin
            $display("\nCould not open trace file");
            $stop;
        end
        
        clk = 0;
        reset = 1;
        #30;
        reset = 0;

        while (!$feof(trace_file)) begin
            
            @(negedge clk);
            
            if (tx_F == 0) begin 
                scan_line = $fscanf(trace_file, "%h", data);
                
                if (scan_line == 1) begin
                    wr_data = data;
                    wr_en = 1;
                    
                    @(negedge clk);
                    wr_en = 0;
                end
            end
        end

        #10000;
        $display("\nSUCCESS: Reached end of file");
        $stop;
    end
endmodule