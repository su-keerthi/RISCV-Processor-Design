`timescale 1ns/1ps
`include "alu.v"

module alu_64_bit_tb;
    reg [63:0] a, b;
    reg [3:0] opcode;
    wire [63:0] result;
    wire cout, carry_flag, overflow_flag, zero_flag;
    integer pass_count = 0, total_tests = 22;
    
    // Control codes
    localparam  ADD_Oper  = 4'b0000,
                SLL_Oper  = 4'b0001,
                SLT_Oper  = 4'b0010,
                SLTU_Oper = 4'b0011,
                XOR_Oper  = 4'b0100,
                SRL_Oper  = 4'b0101,
                OR_Oper   = 4'b0110,
                AND_Oper  = 4'b0111,
                SUB_Oper  = 4'b1000,
                SRA_Oper  = 4'b1101;
    
    // Instantiate the ALU wrapper
    alu_64_bit uut(
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .cout(cout),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag),
        .zero_flag(zero_flag)
    );

    task run_test;
        input [4:0] test_number;
        input [63:0] test_a, test_b, expected_result;
        input [3:0] test_opcode;
        input exp_carry, exp_overflow, exp_zero;
        begin
            a = test_a;
            b = test_b;
            opcode = test_opcode;
            #10;
            $display("Test %d:", test_number);
            $display("A: %016h", a);
            $display("B: %016h", b);
            $display("Opcode: %b", test_opcode);
            $display("Result: %016h", result);
            $display("Flags: C=%b, O=%b, Z=%b", carry_flag, overflow_flag, zero_flag);
            
            if (result === expected_result && 
                carry_flag === exp_carry && 
                overflow_flag === exp_overflow && 
                zero_flag === exp_zero) begin
                pass_count = pass_count + 1;
                $fdisplay(file_handle, "Test %0d, Status: PASS", test_number);
            end else begin
                $fdisplay(file_handle, "Test %0d, Status: FAIL", test_number);
                $display("Expected: result=%016h, carry=%b, overflow=%b, zero=%b", 
                        expected_result, exp_carry, exp_overflow, exp_zero);
                $display("Got:      result=%016h, carry=%b, overflow=%b, zero=%b\n", 
                        result, carry_flag, overflow_flag, zero_flag);
            end
        end
    endtask

    integer file_handle;

    initial begin
        file_handle = $fopen("alu_results.txt", "w");

        // Check if file opened successfully
        if (file_handle == 0) begin
            $display("Error: Could not open file for writing.");
            $finish;
        end
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_64_bit_tb);

        pass_count = 0;

        // Test cases
        run_test(1, 64'h7FFFFFFFFFFFFFFF, 64'h0000000000000001, 64'h8000000000000000, ADD_Oper, 0, 1, 0);
        run_test(2, 64'hFFFF0000FFFF0000, 64'h00000000FFFF0000, 64'hFFFF0000FFFF0000, OR_Oper, 0, 0, 0);
            // ADD: signed overflow (+max + 1)
        run_test(1,  64'h7FFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0001, 64'h8000_0000_0000_0000, ADD_Oper, 0, 1, 0);

        // ADD: unsigned carry (all ones + 1 => 0 with carry)
        run_test(2,  64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0001, 64'h0000_0000_0000_0000, ADD_Oper, 1, 0, 1);

        // ADD: no carry, no overflow
        run_test(3,  64'h0000_0000_0000_0005, 64'h0000_0000_0000_0007, 64'h0000_0000_0000_000C, ADD_Oper, 0, 0, 0);

        // ADD: negative + negative => overflow (signed)
        run_test(4,  64'h8000_0000_0000_0000, 64'h8000_0000_0000_0000, 64'h0000_0000_0000_0000, ADD_Oper, 1, 1, 1);
        // SUB: 5 - 3 = 2 (no borrow => carry=1)
        run_test(5,  64'h0000_0000_0000_0005, 64'h0000_0000_0000_0003, 64'h0000_0000_0000_0002, SUB_Oper, 1, 0, 0);

        // SUB: 3 - 5 = -2 (borrow => carry=0), result = 2's complement
        run_test(6,  64'h0000_0000_0000_0003, 64'h0000_0000_0000_0005, 64'hFFFF_FFFF_FFFF_FFFE, SUB_Oper, 0, 0, 0);

        // SUB: signed overflow: (min) - 1 => overflow
        run_test(7,  64'h8000_0000_0000_0000, 64'h0000_0000_0000_0001, 64'h7FFF_FFFF_FFFF_FFFF, SUB_Oper, 1, 1, 0);

        // SUB: equal => zero
        run_test(8,  64'h1234_5678_9ABC_DEF0, 64'h1234_5678_9ABC_DEF0, 64'h0000_0000_0000_0000, SUB_Oper, 1, 0, 1);
        run_test(9,  64'hFFFF_0000_FFFF_0000, 64'h0F0F_0F0F_0F0F_0F0F, 64'h0F0F_0000_0F0F_0000, AND_Oper, 0, 0, 0);
        run_test(10, 64'hFFFF_0000_FFFF_0000, 64'h0F0F_0F0F_0F0F_0F0F, 64'hFFFF_0F0F_FFFF_0F0F, OR_Oper,  0, 0, 0);
        run_test(11, 64'hAAAA_AAAA_AAAA_AAAA, 64'h5555_5555_5555_5555, 64'hFFFF_FFFF_FFFF_FFFF, XOR_Oper, 0, 0, 0);
        run_test(12, 64'hFFFF_FFFF_FFFF_FFFF, 64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0000, XOR_Oper, 0, 0, 1);
        // SLL: 1 << 1 = 2
        run_test(13, 64'h0000_0000_0000_0001, 64'h0000_0000_0000_0001, 64'h0000_0000_0000_0002, SLL_Oper, 0, 0, 0);

        // SLL: 1 << 63 = MSB set
        run_test(14, 64'h0000_0000_0000_0001, 64'h0000_0000_0000_003F, 64'h8000_0000_0000_0000, SLL_Oper, 0, 0, 0);

        // SRL: 0x8000.. >> 1 = 0x4000.. (logical, fills 0)
        run_test(15, 64'h8000_0000_0000_0000, 64'h0000_0000_0000_0001, 64'h4000_0000_0000_0000, SRL_Oper, 0, 0, 0);

        // SRL: all ones >> 8 = 00FF..FF
        run_test(16, 64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0008, 64'h00FF_FFFF_FFFF_FFFF, SRL_Oper, 0, 0, 0);

        // SRA: -1 >> 8 = -1 (arithmetic keeps 1s)
        run_test(17, 64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0008, 64'hFFFF_FFFF_FFFF_FFFF, SRA_Oper, 0, 0, 0);

        // SRA: 0x8000.. >> 1 = 0xC000.. (fills with 1)
        run_test(18, 64'h8000_0000_0000_0000, 64'h0000_0000_0000_0001, 64'hC000_0000_0000_0000, SRA_Oper, 0, 0, 0);
        // SLT signed: -1 < 0 => 1
        run_test(19, 64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0000, 64'h0000_0000_0000_0001, SLT_Oper, 0, 0, 0);

        // SLTU unsigned: 0xFFFF.. > 0 => false => 0
        run_test(20, 64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0000, 64'h0000_0000_0000_0000, SLTU_Oper, 0, 0, 1);

        // SLT signed: min < 1 => 1
        run_test(21, 64'h8000_0000_0000_0000, 64'h0000_0000_0000_0001, 64'h0000_0000_0000_0001, SLT_Oper, 0, 0, 0);

        // SLTU unsigned: 1 < min? yes (because min has MSB=1 huge) => 1
        run_test(22, 64'h0000_0000_0000_0001, 64'h8000_0000_0000_0000, 64'h0000_0000_0000_0001, SLTU_Oper, 0, 0, 0);


        $display("Passed %0d/%0d tests", pass_count, total_tests);
        $fdisplay(file_handle, "Passed %0d/%0d tests", pass_count, total_tests);
        #10 $finish;
    end
endmodule