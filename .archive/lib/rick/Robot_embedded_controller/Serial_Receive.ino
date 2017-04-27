#include <arduino.h>

#define HEAD 0
#define M1 1
#define M2 2
#define TAIL 3

// need to think about motor control messages
void serial_receive_tick() {
  while(Serial.available() > 0) { // Serial data waiting in buffer
    int x = Serial.read();
    Serial.println(x, HEX);
    process_serial_read(x);
  }
}

int read_state = HEAD;

int mot1_speed = 0;
int mot2_speed = 0;

// Packet 0x55 M1 M2 0xAA - 4 packed bytes, no spaces.
void process_serial_read(int c) {
  
  switch(read_state) {
    case HEAD:
      if(c == 0x55) {
        read_state = M1; // This should make a number between 1500-384 <-> 1500+384
      }
      else {
        read_state = HEAD;
      }
      break;
    case M1:
      if((c & 0x80) != 0) { // c should be a negative number
        c = ~c + 1;
        c = 0 - (c & 0x00FF);
      }
      mot1_speed = c*3+1500; // This should make a number between 1500-384 <-> 1500+384
      read_state = M2;
      break;
    case M2:
      if((c & 0x80) != 0) { // c should be a negative number
        c = ~c + 1;
        c = 0 - (c & 0x00FF);
      }
      mot2_speed = c*3+1500; // This should make a number between 1500-384 <-> 1500+384
      read_state = TAIL;
      break;
    case TAIL:
      if(c == 0xAA) { // If we find a correct tail then update the speeds
        set_motor_speed(0, mot1_speed); // speed is in microseconds with 1000 being full one direction and 2000 being full the other direction
        set_motor_speed(1, mot2_speed);
      }
      read_state = HEAD; // Return to looking for a head reguardless
      break;
    default:
      read_state = HEAD;
      break;
  }
}

