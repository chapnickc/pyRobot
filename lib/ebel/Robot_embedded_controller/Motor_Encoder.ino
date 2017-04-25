#include <arduino.h>
#include <I2C.h>
//https://rheingoldheavy.com/changing-the-i2c-library/
//Wayne Truchsess at DSSCircuits

I2C myI2C;

const unsigned int MC = 0x60;
const unsigned int MC1 = 0x20;
const unsigned int MC2 = 0x22;

void Motor_Encode_Init(int Num_Motors) {
  // renumber the motor encoders on the I2C chain
  myI2C.begin();
  myI2C.pullup(0);    // Disable Arduino Pull-up Resistors
  myI2C.setSpeed(0);  // Run at 100kHz
  myI2C.timeOut(50); // I2C action timeout 0.05 seconds
  
  ResetChain();
  ReNumberEncoder();
  ReadMotorStatus(MC1);
  ReadMotorStatus(MC2);
}

unsigned long read_Motor_Encoder(int motor) {
  unsigned long mot_pos = 0;
  if(motor == 0) {
    mot_pos = ReadRotation(MC1>>1);
  }
  else if(motor == 1) {
    mot_pos = ReadRotation(MC2>>1);
  }
  else {
    mot_pos = 0;
  }
  
  return mot_pos;
}

// These functions are not abstracted for more then two encoders

// Uncomment the Serial.write statements to debug
void ReadMotorStatus(int address) {
  unsigned char stat1, stat2, stat3, stat4;
  int ret;
  
//  Serial.println("Motor Status: ");
  ret = myI2C.read(address>>1, 0x20, 1, &stat1);
  if(ret != 0) {
//    Serial.write("I2C - M1_1 - Error: 0x");
//    Serial.print(ret);
//    Serial.write("\r\n");
  }
  ret = myI2C.read(address>>1, 0x21, 1, &stat2);
  if(ret != 0) {
//    Serial.write("I2C - M1_2 - Error: 0x");
//    Serial.print(ret);
//    Serial.write("\r\n");
  }
  ret = myI2C.read(address>>1, 0x22, 1, &stat3);
  if(ret != 0) {
//    Serial.write("I2C - M1_3 - Error: 0x");
//    Serial.print(ret);
//    Serial.write("\r\n");
  }
  ret = myI2C.read(address>>1, 0x23, 1, &stat4);
  if(ret != 0) {
//    Serial.write("I2C - M1_4 - Error: 0x");
//    Serial.print(ret);
//    Serial.write("\r\n");
  }
//  Serial.println(stat1, HEX);
//  Serial.println(stat2, HEX);
//  Serial.println(stat3, HEX);
//  Serial.println(stat4, HEX);
}

void ReNumberEncoder() {
  unsigned char ret;

  Serial.write("I2C - Change address 1\r\n");
//  Wire.beginTransmission(MC>>1); //change address
//  Wire.write(0x4D);
//  Wire.write(MC1);
//  ret = Wire.endTransmission();
  ret = myI2C.write(MC>>1, 0x4D, MC1);
  if(ret != 0) {
    Serial.write("I2C - 1 - Error: 0x");
    Serial.print(ret);
    Serial.write("\r\n");
  }
  delay(100);
  
  Serial.write("I2C - Change termination 1\r\n");
//  Wire.beginTransmission(MC1>>1); // Turn off termination
//  Wire.write(0x4B);
//  Wire.write(0x00);
//  ret = Wire.endTransmission();
  ret = myI2C.write(MC1>>1, 0x4B);
  if(ret != 0) {
    Serial.write("I2C - 2 - Error: 0x");
    Serial.print(ret);
    Serial.write("\r\n");
  }
  delay(100);
  
  Serial.write("I2C - Change address 2\r\n");
//  Wire.beginTransmission(MC>>1); // change address 2
//  Wire.write(0x4D);
//  Wire.write(MC2);
//  ret = Wire.endTransmission();
  ret = myI2C.write(MC>>1, 0x4D, MC2);
  if(ret != 0) {
    Serial.write("I2C - 3 - Errorr: 0x");
    Serial.print(ret);
    Serial.write("\r\n");
  }
}

void ReadVelocity(int address) {
  unsigned int velTmp;
  unsigned int vel;
  
  myI2C.read(address, 0x44, 2, (unsigned char *)&velTmp);

  vel = ((velTmp&0x00FF) << 8) + ((velTmp&0xFF00)>>8);
  
  Serial.write("Vel: ");
  Serial.print(vel);
  Serial.write("\r\n");
}

unsigned long ReadRotation(int address) {
  unsigned long rotLow;
  unsigned int rotHigh;
  unsigned long rot;
  myI2C.read(address, 0x40, 4, (unsigned char *)&rotLow);
//  myI2C.read(address, 0x40, 2, (unsigned char *)&rotHigh);

  rot = ((rotLow&0x00FF0000L)<<8) + ((rotLow&0xFF000000L)>>8) + ((rotLow&0x000000FFL)<<8) + ((rotLow&0x0000FF00L)>>8);  
//  Serial.write("rot: ");
//  Serial.print(rot);
//  Serial.write("\r\n");

  return rot;
}

void ResetChain() {
  myI2C.write(0x00, 0x4E);
}

