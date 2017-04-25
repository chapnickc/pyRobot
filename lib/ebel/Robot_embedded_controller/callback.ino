#include <arduino.h>

unsigned char New_data = 0;
unsigned char Gather_data = 0;

unsigned int IR_Line_1 = 0;
unsigned int IR_Line_2 = 0;
unsigned int IR_Line_3 = 0;
unsigned int IR_Line_4 = 0;
unsigned int IR_Line_5 = 0;

unsigned int IR_val = 0;

unsigned long Mot_Pos_1 = 0;
unsigned long Mot_Pos_2 = 0;


// this function is called by the timer interrupt to collect data
// the time requirements of this function requires needs to be monitored
// closely, there should be a handshake between collection in the function
// and transmission outside the function

void callback() { 
  Gather_data = 1;
}

// doing the data gathering inside the ISR was messing up
// the timing of motor pulses

void callback_func() {
  if(Gather_data == 1) {
    if(New_data == 0) {
      // Sample the Wheel encoders - This is an I2C read
      Mot_Pos_1 = read_Motor_Encoder(0);
      Mot_Pos_2 = read_Motor_Encoder(1);
    
      // Sample the IR Line following sensors
      IR_Line_1 = read_IR_Line(0);
      IR_Line_2 = read_IR_Line(1);
      IR_Line_3 = read_IR_Line(2);
      IR_Line_4 = read_IR_Line(3);
      IR_Line_5 = read_IR_Line(4);
  
      // Sample the Wall Sensor - This is a low pass filtered analog read
      IR_val = read_IR_Distance(0);
    
      // Post new values to global varables
    
      // Update readiness indicator
      New_data = 1;
    }
    else {
      // If we make it here than the data coming out of this callback is not
      // being serviced fast enough. This probably means we are running the
      // data collection interrupt too fast.
    }
    Gather_data = 0;
  }
}

