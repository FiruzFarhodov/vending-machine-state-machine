module tb;
  logic [1:0] user_selection;
  logic [1:0] out;
  logic reset;
  logic clk;
  
  //Instantiate Design Under Test
  vendingmachine DUT(
    .user_selection(user_selection),
    .reset(reset),
    .clk(clk),
    .out(out)
  );
  
  //Clock Generation: 2 time-unit periods
  always #1 clk = ~clk;
  
  initial begin
    
    //monitor FSM
    $monitor("Time: %d | clk: %d | reset: %d | selection:%d | out: %d", $time, clk, reset, user_selection, out);
    
    clk = 0;
    reset = 1;
    user_selection = 2'b10; // request option 2: OREOS
    #3
    reset = 0;

    
    #10
    $finish;

  end
  
  
  // will print out 2 for 1 clk and never again 
   
  
endmodule
