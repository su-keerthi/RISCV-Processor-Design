`timescale 1ns/1ps
`include "seq_pro.v"
module seq_tb;

    reg clk;
    reg reset;
    integer cycle_count;

    seq_pro DUT (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cycle_count = 0;

        #20;
        reset = 0;
    end

    always @(posedge clk) begin
        if (!reset)
            cycle_count = cycle_count + 1;

        //check for all being zero
        if (!reset && DUT.instruction == 32'h00000000) begin
        dump_registers;
        $finish;
end
    end



    task dump_registers;
        integer file;
        integer i;
        begin
            file = $fopen("register_file.txt", "w");
            for (i = 0; i < 32; i = i + 1)
            $fwrite(file, "%016h\n", DUT.copy_reg_file.regs[i]);
            $fwrite(file, "%0d\n", cycle_count);
            $fclose(file);
        end
    endtask

endmodule