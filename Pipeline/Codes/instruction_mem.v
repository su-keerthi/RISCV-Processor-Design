`define ITEM 4096 
module instruction_mem(addr, instr);
input [63:0]addr;
output [31:0]instr;

//NOTE: wire when using continuous assignment, reg when using always block

reg [7:0] storage[0:`ITEM-1]; //making an array of 4096 bytes, each storage[i] conatins 1 byte

integer file_handle;
integer i = 0;
integer j, val;


//happens only at clk = 0
initial begin

    for (i = 0; i < `ITEM; i = i + 1)
        storage[i] = 8'h00;
    
    file_handle = $fopen("instructions.txt","r");
    //$display("file handle =%d", file_handle);

    if(file_handle == 0) begin
        $display("wasnt able to open the file");
        $finish;
    end
    
    i = 0;
    while($feof(file_handle) == 0 && i < `ITEM) begin
        j = $fscanf(file_handle, "%h\n", val);
        if(j == 1) begin //if successfully scanned
            storage[i] = val[7:0];
            i = i + 1;
        end
    end
$fclose(file_handle);
end

wire [11:0] a = addr[11:0];

//continuosly active and updates whenever addr changes   
assign instr = (a <= (`ITEM - 4)) ? { storage[a], storage[a+1], storage[a+2], storage[a+3] } : 32'h00000000;
endmodule

