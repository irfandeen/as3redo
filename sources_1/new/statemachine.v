`timescale 1ns / 1ps

module top(
    input wire        clk,
    input wire [15:0] sw,
    input wire btnR,
    output reg [3:0]  an = 4'b1111,
    output reg [6:0]  seg,
    output reg dp = 1
);

    reg [31:0] counter  = 0;
    reg [3:0]  state    = 0;
    reg   validState    = 1;
    
    always @ (posedge clk) begin
        if (counter + 1 == 100_000_000) begin
            counter <= 0;
            state   <= state + 1;
            if (state + 1 == 4'b0011) begin
                validState = 0;
            end
        end
        else begin
            counter <= counter + 1;
        end
    end
    
    // Output Logic
    always @ (state) begin
        if (validState) begin
            case (state)
                4'b0000:
                begin
                    an  <= 4'b0111;
                    seg <= 7'b0000_000;
                end
                
                4'b0001:
                begin
                    an  <= 4'b1011;
                    seg <= 7'b0000_000;
                end
                
                4'b0010:
                begin
                    an  <= 4'b1101;
                    seg <= 7'b0000_000;
                end
            endcase
        end
        else begin
            an  <= 4'b1110;
            seg <= 7'b0000_000;
        end
    end

endmodule

