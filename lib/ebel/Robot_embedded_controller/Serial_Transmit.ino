#include <arduino.h>

extern unsigned int IR_Line_1;
extern unsigned int IR_Line_2;
extern unsigned int IR_Line_3;
extern unsigned int IR_Line_4;
extern unsigned int IR_Line_5;

extern unsigned int IR_val;

extern unsigned long Mot_Pos_1;
extern unsigned long Mot_Pos_2;

int index = 0;

void send_sample() {
  unsigned long time;

  time = millis();

  Serial.print(time);
//  Serial.print(index); // Send Header
//  index += 1; index %= 8;
  Serial.print(",");
  Serial.print(Mot_Pos_1); // Send motor encode 1
  Serial.print(",");
  Serial.print(Mot_Pos_2); // Send motor encode 2
  Serial.print(",");
  Serial.print(IR_Line_1); // Send IR Line 1
  Serial.print(",");
  Serial.print(IR_Line_2); // Send IR Line 2
  Serial.print(",");
  Serial.print(IR_Line_3); // Send IR Line 3
  Serial.print(",");
  Serial.print(IR_Line_4); // Send IR Line 4
  Serial.print(",");
  Serial.print(IR_Line_5); // Send IR Line 5
  Serial.print(",");
  Serial.print(IR_val); // Send IR Dist
  Serial.print("\r\n"); // CRLF will mark end of samples
}

