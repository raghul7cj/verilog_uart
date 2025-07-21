module Rx(
    input wire clk,
    input wire i_Rx_serial,
    output reg [7:0] Rx_data,      // serial in parallel out
    output reg data_valid
);

    reg [2:0] state;
    reg [7:0] data_byte_buffer;
    reg [12:0] Clk_count;
    reg [2:0] bit_count;

    localparam IDLE      = 3'b000;
    localparam STARTBIT  = 3'b001;
    localparam DATABITS  = 3'b010;
    localparam STOPBIT   = 3'b011;
    localparam CLEANUP   = 3'b100;
    localparam clk_per_bit = 5208;

    always @(posedge clk) begin
        case(state)
            IDLE: begin
                data_valid <= 0;
                Clk_count <= 0;
                bit_count <= 0;
                if (i_Rx_serial == 0) begin
                    state <= STARTBIT;
                end
            end

            STARTBIT: begin
                if (Clk_count == (clk_per_bit - 1)/2) begin
                    if (i_Rx_serial == 0) begin
                        Clk_count <= 0;
                        state <= DATABITS;
                        bit_count <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end else begin
                    Clk_count <= Clk_count + 1;
                end
            end

            DATABITS: begin
                if (Clk_count == clk_per_bit - 1) begin
                    Clk_count <= 0;
                    data_byte_buffer[bit_count] <= i_Rx_serial;
                    if (bit_count == 3'd7) begin
                        state <= STOPBIT;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end else begin
                    Clk_count <= Clk_count + 1;
                end
            end

            STOPBIT: begin
                if (Clk_count == clk_per_bit - 1) begin
                    data_valid <= 1;
                    Rx_data <= data_byte_buffer;
                    Clk_count <= 0;
                    state <= CLEANUP;
                end else begin
                    Clk_count <= Clk_count + 1;
                end
            end

            CLEANUP: begin
                data_valid <= 0;
                state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end

endmodule
