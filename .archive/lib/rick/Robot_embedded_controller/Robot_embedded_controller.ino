#include <arduino.h>
#include <TimerThree.h> // this requires a MEGA 2560

unsigned char IR_DIST_PIN = A0;    // PIN #, IR ranging sensor
unsigned char IR_DIST = 0;         // IR ranging sensor measurement

unsigned char IR_LINE_PIN_1 = A5;  // PIN #, LEFT-most line following sensor
unsigned char IR_LINE_PIN_2 = A4;
unsigned char IR_LINE_PIN_3 = A3;  // PIN #, MIDDLE line following sensor
unsigned char IR_LINE_PIN_4 = A2;
unsigned char IR_LINE_PIN_5 = A1;  // PIN #, RIGHT-most line following sensor

unsigned char IR_LINE_SEN_1 = 0;   // LEFT-most line following sensor measurement
unsigned char IR_LINE_SEN_2 = 0;
unsigned char IR_LINE_SEN_3 = 0;   // MIDDLE line following sensor measurement
unsigned char IR_LINE_SEN_4 = 0;
unsigned char IR_LINE_SEN_5 = 0;   // RIGHT-most line following sensor measurement

unsigned char MOT_PIN_1 = 6;       // PIN #, LEFT motor
unsigned char MOT_PIN_2 = 7;       // PIN #, RIGHT motor

unsigned char MOT_1 = 0;           // LEFT motor speed value
unsigned char MOT_2 = 0;           // RIGHT motor speed value

extern unsigned char New_data;
extern unsigned char Gather_data;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  
  Motor_Encode_Init(2);
  IR_DIST = attach_IR_Distance(IR_DIST_PIN);

  IR_LINE_SEN_1 = attach_IR_Line(IR_LINE_PIN_1);
  IR_LINE_SEN_2 = attach_IR_Line(IR_LINE_PIN_2);
  IR_LINE_SEN_3 = attach_IR_Line(IR_LINE_PIN_3);
  IR_LINE_SEN_4 = attach_IR_Line(IR_LINE_PIN_4);
  IR_LINE_SEN_5 = attach_IR_Line(IR_LINE_PIN_5);

  MOT_1 = attach_motor(MOT_PIN_1);
  MOT_2 = attach_motor(MOT_PIN_2);
  
  Timer3.initialize(100000); // Init timer three and set to 100mS period
  Timer3.attachInterrupt(callback); // attach function to be called at timer interval

  set_motor_speed(MOT_1, 1500);
  set_motor_speed(MOT_2, 1500);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Gather_data == 1) {
    callback_func();    
  }
  
  if(New_data != 0) { // New data forms a handshake
    send_sample();
    New_data = 0;
  }

  serial_receive_tick(); // check to see if any serial datga has been received
}

