module encryption #(
    width = 16
)(
    input logic                       b,          // bit to be encrypted
    input logic signed [width - 1:0]  x,          
    input logic signed [width - 1:0]  k,
    output logic signed [width - 1:0] c
);

    parameter int p = 257;

    always_comb begin
        c = b + 2*x + k * p;
    end
    
endmodule