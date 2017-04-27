#include <arduino.h>
#include <Servo.h>

#define MAX_MOTOR_CNT 4

Servo servo1;
Servo servo2;
Servo servo3;
Servo servo4;

char motor_pin[MAX_MOTOR_CNT];
char motor_cnt = 0;

char attach_motor(int pin) {
  Serial.println("Motor Attach");

  if(motor_cnt < MAX_MOTOR_CNT) {
    if(motor_cnt == 0)
      servo1.attach(pin, 1000, 2000);
    else if(motor_cnt == 1)
      servo2.attach(pin, 1000, 2000);
    else if(motor_cnt == 2)
      servo3.attach(pin, 1000, 2000);
    else if(motor_cnt == 3)
      servo4.attach(pin, 1000, 2000);

    Serial.print(motor_cnt);
    Serial.print(" : ");
    Serial.println(pin);
    motor_cnt ++;
    return (motor_cnt-1);
  }
  else {
    // if we make it here then the number of attached motors is too large
    return -1;
  }   
}

// Somewhere speed-command needs to be changed to microseconds
void set_motor_speed(int motor, int mot_speed_us) {
  if(motor == 0)
    servo1.writeMicroseconds(mot_speed_us);  
  else if(motor == 1)
    servo2.writeMicroseconds(mot_speed_us);  
  else if(motor == 2)
    servo3.writeMicroseconds(mot_speed_us);  
  else if(motor == 3)
    servo4.writeMicroseconds(mot_speed_us);  
  else {
    // if we make it here then the number of attached motors is too large
  }   
}


