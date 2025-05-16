module mont_mod_red #(
    n = 256, 
    K = 16
) (
    input logic [31:0] C,            // the integer to be reduced modulo q
    output logic [31:0] Res          // Res = C . inv(R) mod q, where R = 2^(wL)
);



    // w = the word size   
    // L = number of MAC units required
    // the MAC performs the operation: X.Y + Z + C_in

    // inputs for the first MAC unit

    parameter logic [15:0] q = 16'h0D01;        // NTT friendly prime (3329)
    logic C_in_1;
    logic signed [8:0]  X_1;
    logic [15:9] Y_1;
    logic [31:9] Z_1;

    assign X_1 = -C[8:0];           // 2s compliment of the least significant word of C
    assign Y_1 = q[15:9];           // Ys always equate to the higher part of q, i.e., q_h
    assign Z_1 = C[31:9];           // higher part of C
    assign C_in_1 = C[8] | X_1[8];  // the carry_in flag

    logic [23:0] C_1;               // output for the first MAC unit
    assign C_1 = X_1*Y_1 + Z_1 + C_in_1; 


    // inputs of the second MAC unit
    logic C_in_2;
    logic signed [8:0]  X_2;
    logic [15:9] Y_2;
    logic [31:9] Z_2;

    assign X_2 = -C_1[8:0];           // 2s compliment of the least significant word of C1
    assign Y_2 = q[15:9];             // Ys always equate to the higher part of q, i.e., q_h
    assign Z_2 = C_1[23:9];           // higher part of C1
    assign C_in_2 = C_1[8] | X_2[8];  // the carry_in flag

    logic [15:0] C_2;               // output for the second MAC unit
    assign C_2 = X_2*Y_2 + Z_2 + C_in_2; 


    logic [15:0] T_4;                 // for additional correction check 

    assign T_4 = C_2 - q;

    always_comb begin
        
        if ($signed(T_4) < 0)
            Res = C_2;
        else
            Res = T_4;
    end


    
endmodule