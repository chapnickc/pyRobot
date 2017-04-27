#include <arduino.h>

#define MAX_PINS 8

char pin_list[MAX_PINS];
unsigned char number_attached = 0;

char attach_IR_Distance(int pin) {
  if(number_attached < MAX_PINS) {
    pin_list[number_attached] = pin;
    number_attached ++;
    return (number_attached-1);
  }
  else  {
    // if we get here we have tried to attach too many pins
    return -1;
  }
}

// should the values be low pass filtered here or when they are used
int read_IR_Distance(int sensor) {
  // may need to have a low pass filter
  int IR_val = 0;
  for(int i=0; i<10; i++) {
    IR_val += analogRead(pin_list[sensor]);
  }
  IR_val = IR_val / 10;

  return IR_val;
}


