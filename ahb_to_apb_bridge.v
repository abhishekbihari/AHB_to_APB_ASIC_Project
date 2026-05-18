module ahb_to_apb_bridge (

    input         HCLK,
    input         HRESETn,

    // AHB Signals
    input  [31:0] HADDR,
    input  [31:0] HWDATA,
    input         HWRITE,
    input         HSEL,
    input         HREADY,

    // APB Signals
    output reg [31:0] PADDR,
    output reg [31:0] PWDATA,
    output reg        PWRITE,
    output reg        PENABLE,
    output reg        PSEL
);

    // FSM States
    parameter IDLE   = 2'b00;
    parameter SETUP  = 2'b01;
    parameter ACCESS = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // State Register
    always @(posedge HCLK or negedge HRESETn) begin

        if (!HRESETn)
            state <= IDLE;
        else
            state <= next_state;

    end

    // Next State Logic
    always @(*) begin

        case(state)

            IDLE: begin

                if(HSEL && HREADY)
                    next_state = SETUP;
                else
                    next_state = IDLE;

            end

            SETUP: begin
                next_state = ACCESS;
            end

            ACCESS: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end

    // Output Logic
    always @(posedge HCLK or negedge HRESETn) begin

        if(!HRESETn) begin

            PADDR   <= 32'd0;
            PWDATA  <= 32'd0;
            PWRITE  <= 1'b0;
            PENABLE <= 1'b0;
            PSEL    <= 1'b0;

        end

        else begin

            case(state)

                IDLE: begin

                    PENABLE <= 1'b0;
                    PSEL    <= 1'b0;

                end

                SETUP: begin

                    PADDR   <= HADDR;
                    PWDATA  <= HWDATA;
                    PWRITE  <= HWRITE;

                    PSEL    <= 1'b1;
                    PENABLE <= 1'b0;

                end

                ACCESS: begin

                    PENABLE <= 1'b1;

                end

            endcase

        end

    end

endmodule