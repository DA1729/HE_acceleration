module decrypt #(
    width = 16
) (
    input logic signed [width-1:0] c,
    output logic                   b
);

    parameter int p = 257;
    logic signed [width-1:0] c_mod_p;

always_comb begin
    c_mod_p = c % p;
    if (c_mod_p < 0)
        c_mod_p = c_mod_p + p;

    if (c_mod_p > (p >> 1))
        c_mod_p = c_mod_p - p;

    b = c_mod_p%2;
end


    
endmodule

