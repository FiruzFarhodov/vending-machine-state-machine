// Description: FSM implementation with enumerated types, state history, and error recovery.
module vendingmachine(
  input clk,
  input reset,
  input  logic [1:0] user_selection,
  output logic [1:0] out
);

  logic enable;
  //vending machine output
  typedef enum {NA, LAYS, OREOS, WATER} item_t; 
  //vending machine status
  typedef enum {WAITING, SELECTING, DISPENSING} state_t;
  //user input
  typedef enum {NA_In, OPTION1, OPTION2, OPTION3} in_t; 
  
  //Instantiate the 3 states 
  state_t state, next_state, prev_state;
  in_t in;
  item_t item;

  // Continuous Output Assignment: Maps internal item enum directly to out port
  assign out = item;
  
  always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
      prev_state <= WAITING;
      state <= WAITING;
      in <= NA_In;
      enable <= 0;
    end
    else begin 
      prev_state <= state;
      state<= next_state; 
      //waits for user to select for the FSM to start loading
      if(user_selection != 0 && state == WAITING ) begin
      in <= in_t'(user_selection);
      enable <= 1;
      end else begin
        enable <= 0;
      end
       end
  end
  
  always_comb begin
  case(state) 
    
    WAITING : begin
      if(enable) 
        next_state = SELECTING;
    end
  
  	SELECTING : begin
      case(in) 
        
        OPTION1: begin
          item = LAYS;
          next_state = DISPENSING;
        end
        
        OPTION2 : begin
          item = OREOS;
          next_state = DISPENSING;
        end
        
        OPTION3 : begin
          item = WATER;
          next_state = DISPENSING;
        end
        
        default : begin
          item = NA;
          next_state = WAITING;
        end
        
      endcase
    end
      	
  	DISPENSING : begin
      //Returns to WAITING, as it waits for the next input values
		next_state = WAITING;  
      item = NA;
    end
    //For any invalid inputs this wil be registed to the output
    default: begin
      next_state = WAITING;
      item = NA;
    end
  endcase
  end

endmodule
