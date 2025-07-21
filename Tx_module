module Tx(
        input clk,
        input baud_tick,
        input rst_n,
        input i_Tx_start,
        input [7:0] i_data,

        output reg o_Tx_Serial,
        output reg o_Tx_Done,
        output reg o_Tx_Active
);

//STANDARD FSM STATES OF AN UART
    localparam IDLE = 2'b00;
    localparam STARTBIT = 2'b01;
    localparam DATABITS = 2'b10;
    localparam STOPBIT = 2'b11;
    localparam clk_per_bit = 5208;

    reg [1:0]state = IDLE;
    reg [7:0]data_byte_buffer;
    reg [3:0]bit_count;

    //Control Tx FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            o_Tx_Active <= 0;
            o_Tx_Done <= 0;
            o_Tx_Serial <= 0;
        end else begin
            o_Tx_Done <= 0;

            case (state)
                IDLE:
                    begin
                        o_Tx_Serial <= 1'b1; 
                        bit_count <= 0 ;
                        if (i_Tx_start) begin
                            o_Tx_Active <=1;
                            data_byte_buffer <= i_data;
                            state <= STARTBIT;
                        end
                        else
                        begin
                            o_Tx_Active <=0;
                        end
                    end
                STARTBIT:
                    begin
                        o_Tx_Serial <= 0;
                        if (baud_tick) begin
                            state <= DATABITS;
                        end
                    end 
                DATABITS:
                    begin
                        if(baud_tick)
                        begin
                            o_Tx_Serial <= data_byte_buffer[bit_count]; 
                            if (bit_count == 3'b111)
                            begin
                                bit_count <= 3'b000;
                                state <= STOPBIT;
                            end
                            else
                            begin
                                bit_count <= bit_count + 1;
                            end
                        end
                    end
                STOPBIT:
                    begin
                        o_Tx_Serial <= 1'b1;
                        if (baud_tick) begin
                            o_Tx_Done   <= 1'b1;
                            state       <=IDLE;
                            o_Tx_Active <=1'b0;
                        end
                    end
                default: 
                    state <=IDLE;
            endcase
        end
    end

    
endmodule
