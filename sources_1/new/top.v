`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire btnL,
    input wire btnD,
    input wire btnC,
    input wire [15:0] sw,
    output reg [15:0] led = 0,
    output reg [6:0]  seg,
    output reg [3:0]  an,
    output reg        dp
);
    initial begin
        an  <= 4'hf;
        dp  <= 1'h1;
        seg <= 7'b111_1111;
    end

    reg [31:0] counter_1Hz = 0;
    reg [31:0] state       = 0;
    wire clk_1kHz, clk_1Hz, clk_10Hz, clk_100Hz;
    
    flexible_clock #( .CLK_DIV(50_000) ) i_clock_1kHz (
        .clk_in(clk),
        .clk_out(clk_1kHz)
    );
    
    flexible_clock #( .CLK_DIV(50_000_000) ) i_clock_1Hz (
        .clk_in(clk),
        .clk_out(clk_1Hz)
    );
    
    flexible_clock #( .CLK_DIV(50_000_00) ) i_clock_10Hz (
        .clk_in(clk),
        .clk_out(clk_10Hz)
    );
    
    flexible_clock #( .CLK_DIV(50_000_0) ) i_clock (
        .clk_in(clk),
        .clk_out(clk_100Hz)
    );
    
    reg MAX_LED = 0;
    reg locked = 1;
    
    always @ (posedge clk_1kHz) begin
        if (counter_1Hz + 1 == 1000) begin
            counter_1Hz <= 0;
            state       <= state + 1;
            if (led != 16'b0000_0111_1111_1111 && MAX_LED == 0) begin
                led <= (led << 1) | 1;
            end
            else if (led == 16'b0000_0111_1111_1111) begin
                MAX_LED <= 1;
            end
        end
        else begin
            counter_1Hz <= counter_1Hz + 1;
            if (MAX_LED == 1) begin
                if (sw[2] == 1) begin
                    led[2]   <= clk_100Hz;
                    led[1:0] <= 2'b11;
                end
                else if (sw[1] == 1) begin
                    led[2] <= 1;
                    led[1] <= clk_10Hz;
                    led[0] <= 1;
                end
                else if (sw[0] == 1) begin
                    led[2:1] <= 2'b11;
                    led[0]   <= clk_1Hz;
                end
                else begin
                    led[2:0] <= 3'b111;
                end
            end
        end
        
        if (MAX_LED == 1 && locked == 1 && an == 4'b1111) begin
            an  <= 4'b1110;
            seg <= 7'b1001_111;
        end
        else if (MAX_LED == 1 && locked == 1 && btnL == 1 && an == 4'b1110) begin
            an <= 4'b1101;
            seg <= 7'b1011_110;
        end
        else if (MAX_LED == 1 && locked == 1 && btnD == 1 && an == 4'b1101) begin
            an <= 4'b1011;
            seg <= 7'b0100_111;
        end
        else if (MAX_LED == 1 && locked == 1 && btnC == 1 && an == 4'b1011) begin
            an <= 4'b1110;
            locked <= 0;
            seg <= 7'b1001_111;
            led[15] <= 1;
        end
    end
    
endmodule
