// lets set baud rate as 9600
//50 mhz system -> for every 5208 clocks the uart sends the data

//Baud Generator Module

module baud_generator(
        input wire clk;
        input wire rst_n;
        output reg baud_tick
);
        localparam clk_per_bit = 5208;

        reg [15:0] count;

        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                baud_tick<=0;
                count    <=0;
            end
            else 
            begin
                if (count == clk_per_bit - 1) begin
                    count       <= 0;
                    baud_tick   <= 1;
                end    
                else
                begin
                    count = count +1;
                    baud_tick   <= 0;
                end
            end
        end

endmodule
