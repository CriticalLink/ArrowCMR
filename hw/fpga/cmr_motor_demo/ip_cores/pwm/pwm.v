`timescale 1ns / 1ps

module PWM_timer
(
    input wire clock,      //Clock input
    input wire reset,    //Active low reset input
    input wire en,       //Enable PWM input
    input wire tripN,    //Active low trip input
    input wire sinc0_trip,
    input wire sinc1_trip,
    input wire trip_reset,  //Trip reset
    input wire [15:0] ton_a,
    input wire [15:0] toff_a,    
    input wire [15:0] ton_b,
    input wire [15:0] toff_b,
    input wire [15:0] ton_c,
    input wire [15:0] toff_c,            
    input wire [15:0] deadtime,  //Dead time
    input wire pwm_sync,        
    output reg PWM_AL,             //PWM output - low side
    output reg PWM_AH,             //PWM output - high side
    output reg PWM_BL,             
    output reg PWM_BH,
    output reg PWM_CL,             
    output reg PWM_CH,
    output reg led_out,
    output reg fault_irq,
    output wire [7:0] status,
    output reg pwm_en_pin
    );
    
    parameter LENGTH = 4;    //Machine Size
    parameter sIDLE = 4'b0001, sNORMAL = 4'b0010, sTRIP = 4'b0100;    
    parameter ON = 2'b10, OFF = 2'b01;  
    parameter PWM_ON = 1'b0, PWM_OFF = 1'b1;  
    parameter LED_TIME_OUT = 2000;
    parameter NO_TRIP = 3'b000, EXT_TRIP = 3'b001, SINC0_TRIP = 3'b010, SINC1_TRIP = 3'b100;
    reg [1:0] DT_state_a, DT_state_b, DT_state_c;
    reg pwm_sync_old;
    
    reg[LENGTH-1:0] state;
    reg signed [15:0] TM_cnt;
    reg signed [15:0] DT_a_cnt, DT_b_cnt, DT_c_cnt;
    reg signed [15:0] ton_a_buff, toff_a_buff, ton_b_buff, toff_b_buff, ton_c_buff, toff_c_buff, deadtime_buff; //Buffered registers
    reg PWM_AL_pend, PWM_AH_pend, PWM_BL_pend, PWM_BH_pend, PWM_CL_pend, PWM_CH_pend;
    reg [31:0] led_cnt;
    reg [2:0] trip_status;
    reg trip_level;
   
   assign status = {trip_level,trip_status,state};   
   
//******************************************************************************************    
//Sequential Logic for state update at clock edges
//******************************************************************************************
      initial
        begin
          pwm_sync_old <= 1'b0;
          TM_cnt <= 0; 
          led_cnt <= 0;
          pwm_en_pin <= 1'b1; // Enable driver right away. Disable is always handled through gate drive signals
          PWM_AL_pend <= PWM_OFF;
          PWM_AH_pend <= PWM_OFF;
          PWM_BL_pend <= PWM_OFF;
          PWM_BH_pend <= PWM_OFF;
          PWM_CL_pend <= PWM_OFF;
          PWM_CH_pend <= PWM_OFF;           
          PWM_AH <= PWM_OFF;
          PWM_AL <= PWM_OFF;
          PWM_BH <= PWM_OFF;
          PWM_BL <= PWM_OFF;
          PWM_CH <= PWM_OFF;
          PWM_CL <= PWM_OFF;
          state <= sIDLE;
          DT_a_cnt <= 0;
          DT_b_cnt <= 0;
          DT_c_cnt <= 0;
          DT_state_a <=OFF;
          DT_state_b <=OFF;
          DT_state_c <=OFF;
          ton_a_buff<=0;
          toff_a_buff<=0;
          ton_b_buff<=0;
          toff_b_buff<=0;
          ton_c_buff<=0;
          toff_c_buff<=0;         
          deadtime_buff<=0;
          trip_status<=NO_TRIP;         
          fault_irq<=1'b0;
          trip_level<=1'b1;
      end  
 
      //Output Logic that determines each states output at clock edges
      always @(posedge clock)       
       begin
       
       trip_level<=tripN;
       
       if (reset==1'b1)
       begin
         state<=sIDLE;
         trip_status<=NO_TRIP;         
         fault_irq<=1'b0;
       end
       else if (state==sIDLE && (en==1'b1))
         begin
         state<=sNORMAL;         
         end
       else if (state==sNORMAL && ((en==1'b0) || (reset==1'b1)))
          state<=sIDLE;  
       else if (state==sNORMAL && ((tripN==1'b0) || (sinc0_trip==1'b0) || (sinc1_trip==1'b0)))
       begin   
         state<=sTRIP;
         fault_irq<=1'b1;
         
         if(tripN==1'b0)
         begin
           trip_status <= EXT_TRIP;
         end
         if(sinc0_trip==1'b0)
         begin
           trip_status <= SINC0_TRIP;
         end
         if(sinc1_trip==1'b0)
         begin
           trip_status <= SINC1_TRIP;
         end
         
       end
       else if (state==sTRIP && (tripN==1'b1) && (trip_reset==1'b1))
       begin    
         state <= sNORMAL; 
         trip_status<=NO_TRIP;
         fault_irq<=1'b0;         
       end  
       else if (state==sTRIP && ((en==1'b0) || (reset==1'b1)))
       begin    
         state <= sIDLE;
         trip_status<=NO_TRIP;  
         fault_irq<=1'b0;          
       end
       
       //Update buffered duty cycle value at timer boundaries         
       if(pwm_sync == 1'b1 && pwm_sync_old == 1'b0)
        begin                
          TM_cnt <= 0;  
          ton_a_buff<=ton_a;
          toff_a_buff<=toff_a;
          ton_b_buff<=ton_b;
          toff_b_buff<=toff_b;
          ton_c_buff<=ton_c;
          toff_c_buff<=toff_c;         
          deadtime_buff<=deadtime;
          
          led_cnt <= led_cnt + 1;
          if(led_cnt == LED_TIME_OUT)
          begin
             led_cnt <= 0;
             led_out = ~led_out;
          end
        end
        else if (state==sNORMAL  || state==sTRIP)
        begin
          TM_cnt <= TM_cnt+1;          // Update main PWM counter
        end
        
        pwm_sync_old <= pwm_sync;
                
       case (state)
        sIDLE: 
        begin
           PWM_AL_pend <= PWM_OFF;
           PWM_AH_pend <= PWM_OFF;
           PWM_BL_pend <= PWM_OFF;
           PWM_BH_pend <= PWM_OFF;
           PWM_CL_pend <= PWM_OFF;
           PWM_CH_pend <= PWM_OFF;           
           PWM_AH <= PWM_OFF;
           PWM_AL <= PWM_OFF;
           PWM_BH <= PWM_OFF;
           PWM_BL <= PWM_OFF;
           PWM_CH <= PWM_OFF;
           PWM_CL <= PWM_OFF;
           TM_cnt <= 0;
           DT_a_cnt <= 0;
           DT_b_cnt <= 0;
           DT_c_cnt <= 0;
           DT_state_a <=OFF;
           DT_state_b <=OFF;
           DT_state_c <=OFF;
        end
       
        sNORMAL: 
        begin             
        
        //Phase A
        // There is a delay of 2 clks from counter to PWM pins, so advance treshholds by 2. @CLK: PWM_command->PWM_xy_pend->PWM_pin
        if (TM_cnt < ton_a_buff-2 || TM_cnt >= toff_a_buff-2)   // Check if this is beginning or end of PWM period. If so HS should be OFF and LS ON.  
        begin          
          PWM_AH_pend <= PWM_OFF;    // Put duties in a pending variable. If dead time is inserted of if we are about to enter deadtime it's not safe to apply duties
          PWM_AL_pend <= PWM_ON;
        end        
        else if (TM_cnt >= ton_a_buff-2 && TM_cnt < toff_a_buff-2 )  // Check if this is the center of PWM period.  If so HS should be ON and LS OFF
        begin     
          PWM_AH_pend <= PWM_ON;  // Put duties in a pending variable. If dead time is inserted of if we are about to enter deadtime it's not safe to apply duties
          PWM_AL_pend <= PWM_OFF;
        end       
 
        // If there was a HS change from OFF->ON OR if there was a HS change from ON->OFF, enable dead time period
        if ((PWM_AH_pend == PWM_OFF && PWM_AH == PWM_ON && DT_state_a==OFF) || (PWM_AH_pend == PWM_ON && PWM_AH == PWM_OFF && DT_state_a==OFF))
        begin 
          DT_state_a<=ON;  // Set DT state
          DT_a_cnt<=0;     // Clear dead time counter so a full DT is inserted
          PWM_AL <= PWM_OFF;     // If dead time is active, keep PWM outputs off. Pending duties are ignored but stored for later use
          PWM_AH <= PWM_OFF;
        end
        else if (DT_a_cnt<deadtime_buff-1)
         begin
           DT_a_cnt <= DT_a_cnt + 1;           
           PWM_AL<=PWM_OFF;
           PWM_AH<=PWM_OFF;           
         end
        else if (DT_a_cnt==deadtime_buff-1) // Check if dead time just expired. That is, check if we are transitioning from dead time to normal operation
        begin
          PWM_AL<=PWM_AL_pend;        // Apply duty cycles which were pending during dead time
          PWM_AH<=PWM_AH_pend;
          DT_state_a<=OFF;            // Clear dead time state variable
        end 
        else
        begin
          PWM_AL<=PWM_AL_pend;        // Apply duty cycles which were pending during dead time
          PWM_AH<=PWM_AH_pend;
        end      

        //Phase B
        if (TM_cnt < ton_b_buff-2 || TM_cnt >= toff_b_buff-2)   // Check if this is beginning or end of PWM period. If so HS should be OFF and LS ON.  
        begin          
          PWM_BH_pend <= PWM_OFF;    // Put duties in a pending variable. If dead time is inserted of if we are about to enter deadtime it's not safe to apply duties
          PWM_BL_pend <= PWM_ON;
        end        
        else if (TM_cnt >= ton_b_buff-2 && TM_cnt < toff_b_buff-2 )  // Check if this is the center of PWM period.  If so HS should be ON and LS OFF
        begin     
          PWM_BH_pend <= PWM_ON;  // Put duties in a pending variable. If dead time is inserted of if we are about to enter deadtime it's not safe to apply duties
          PWM_BL_pend <= PWM_OFF;
        end       
 
        // If there was a HS change from OFF->ON OR if there was a HS change from ON->OFF, enable dead time period
        if ((PWM_BH_pend == PWM_OFF && PWM_BH == PWM_ON && DT_state_b==OFF) || (PWM_BH_pend == PWM_ON && PWM_BH == PWM_OFF && DT_state_b==OFF))
        begin 
          DT_state_b<=ON;  // Set DT state
          DT_b_cnt<=0;     // Clear dead time counter so a full DT is inserted
          PWM_BL <= PWM_OFF;     // If dead time is active, keep PWM outputs off. Pending duties are ignored but stored for later use
          PWM_BH <= PWM_OFF;
        end
        else if (DT_b_cnt<deadtime_buff-1)
         begin
           DT_b_cnt <= DT_b_cnt + 1;           
           PWM_BL<=PWM_OFF;
           PWM_BH<=PWM_OFF;           
         end
        else if (DT_b_cnt==deadtime_buff-1) // Check if dead time just expired. That is, check if we are transitioning from dead time to normal operation
        begin
          PWM_BL<=PWM_BL_pend;        // Apply duty cycles which were pending during dead time
          PWM_BH<=PWM_BH_pend;
          DT_state_b<=OFF;            // Clear dead time state variable
        end 
        else
        begin
          PWM_BL<=PWM_BL_pend;        // Apply duty cycles which were pending during dead time
          PWM_BH<=PWM_BH_pend;
        end
        
        //Phase C
        if (TM_cnt < ton_c_buff-2 || TM_cnt >= toff_c_buff-2)   // Check if this is beginning or end of PWM period. If so HS should be OFF and LS ON.  
        begin          
          PWM_CH_pend <= PWM_OFF;    // Put duties in a pending variable. If dead time is inserted of if we are about to enter deadtime it's not safe to apply duties
          PWM_CL_pend <= PWM_ON;
        end        
        else if (TM_cnt >= ton_c_buff-2 && TM_cnt < toff_c_buff-2 )  // Check if this is the center of PWM period.  If so HS should be ON and LS OFF
        begin     
          PWM_CH_pend <= PWM_ON;  // Put duties in a pending variable. If dead time is inserted of if we are about to enter deadtime it's not safe to apply duties
          PWM_CL_pend <= PWM_OFF;
        end       
 
        // If there was a HS change from OFF->ON OR if there was a HS change from ON->OFF, enable dead time period
        if ((PWM_CH_pend == PWM_OFF && PWM_CH == PWM_ON && DT_state_c==OFF) || (PWM_CH_pend == PWM_ON && PWM_CH == PWM_OFF && DT_state_c==OFF))
        begin 
          DT_state_c<=ON;  // Set DT state
          DT_c_cnt<=0;     // Clear dead time counter so a full DT is inserted
          PWM_CL <= PWM_OFF;     // If dead time is active, keep PWM outputs off. Pending duties are ignored but stored for later use
          PWM_CH <= PWM_OFF;
        end
        else if (DT_c_cnt<deadtime_buff-1)
         begin
           DT_c_cnt <= DT_c_cnt + 1;           
           PWM_CL<=PWM_OFF;
           PWM_CH<=PWM_OFF;           
         end
        else if (DT_c_cnt==deadtime_buff-1) // Check if dead time just expired. That is, check if we are transitioning from dead time to normal operation
        begin
          PWM_CL<=PWM_CL_pend;        // Apply duty cycles which were pending during dead time
          PWM_CH<=PWM_CH_pend;
          DT_state_c<=OFF;            // Clear dead time state variable
        end 
        else
        begin
          PWM_CL<=PWM_CL_pend;        // Apply duty cycles which were pending during dead time
          PWM_CH<=PWM_CH_pend;
        end 
      end  // sNORMAL       
                 
        sTRIP:
        begin
           PWM_AL <= PWM_OFF;
           PWM_AH <= PWM_OFF;
           PWM_BL <= PWM_OFF;
           PWM_BH <= PWM_OFF;
           PWM_CL <= PWM_OFF;
           PWM_CH <= PWM_OFF;  
        end
       
       endcase
       
       end    
endmodule
