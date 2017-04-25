#include <arduino.h>

#define MAX_IR_LINE_PINS 8

int ir_line_pin_list[MAX_IR_LINE_PINS];
unsigned char number_ir_line_attached = 0;

char attach_IR_Line(int pin) {
  Serial.println("IR Line Attach");
  if(number_ir_line_attached < MAX_PINS) {
    ir_line_pin_list[number_ir_line_attached] = pin;
    Serial.print("pin: ");
    Serial.print(pin);
    Serial.print(" : ");
    Serial.print(ir_line_pin_list[number_ir_line_attached]);
    Serial.print("\r\n");
    number_ir_line_attached ++;
    return (number_ir_line_attached-1);
  }
  else  {
    // if we get here we have tried to attach too many pins
    Serial.println("IR Line Attach Error ");
    return -1;
  }
}

// should the values be low pass filtered here or when they are used
int read_IR_Line(int sensor) {
  // may need to have a low pass filter
  int IR_val = 0;
  for(int i=0; i<10; i++) {
    IR_val += analogRead(ir_line_pin_list[sensor]);
  }
  IR_val = IR_val / 10;

  return IR_val;
}


