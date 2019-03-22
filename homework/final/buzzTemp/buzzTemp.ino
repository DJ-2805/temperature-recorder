int tempPin = A0;
int buzzPin = 2;
int lightP1 = 5;
int lightP2 = 6;


int numTones = 10;
int tones[] = {261, 277, 294, 311, 330, 349, 370, 392, 415, 440};
int timeRun = 19;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

  while(Serial.available()) {
    Serial.read();
  }

  int val = analogRead(tempPin);
  float volt = val*5.0/1023.0;
  float res = volt/(5-volt)*9.88*1000;
  float temp = 9.57e-04+3.15e-04*log(res)-1.17e-05*pow(log(res),2)+6.23e-07*pow(log(res),3);
  temp = pow(temp,-1) - 273.15;
  if(timeRun > 0)
    timeRun--;
  else if(timeRun == 0){
        temp = 0;
    tone(buzzPin,tones[7]);
    noTone(buzzPin);
    tone(buzzPin,tones[2]);
    noTone(buzzPin);
    tone(buzzPin,tones[5]);
    noTone(buzzPin);
    timeRun--;
  }


  Serial.println(temp);
  Serial.flush();

  int tempLevelOne = 24;
  int tempLevelTwo = 28;
  
  if(temp < tempLevelOne)
  {
    analogWrite(lightP1,0);
    analogWrite(lightP2,0);
    noTone(buzzPin);
    delay(1000);
  }
  else if(temp >= tempLevelOne && temp < tempLevelTwo)
  {
    if(temp >= tempLevelOne && temp < tempLevelOne+1){
      analogWrite(lightP1,25);
      analogWrite(lightP2,25);
      tone(buzzPin,tones[0]);

    }
    else if(temp >= tempLevelOne+1 && temp < tempLevelOne+2){
      analogWrite(lightP1,50);
      analogWrite(lightP2,50);
      tone(buzzPin,tones[1]);
    }
    else{
      analogWrite(lightP1,100);
      analogWrite(lightP2,100);
      tone(buzzPin,tones[3]);
    }
    delay(500);
    noTone(buzzPin);
  }
  else if(temp >= tempLevelTwo)
  {
    analogWrite(lightP1,255);
    analogWrite(lightP2,255);
    tone(buzzPin,tones[9]);

    delay(250);
    noTone(buzzPin);
  }
  delay(1000);
}
