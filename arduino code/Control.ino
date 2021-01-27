#include <LIDARLite.h>
#include <Servo.h>
#define Dir_pin 7
#define Step_pin 6
#define MS1 1
#define MS2 9
#define Enb 10

#define Mon 12
#define Trg 11


#define GLED 13
#define BLED 8

#define Gbtn 2
#define Rbtn 3
#define Wbtn 4

#define LL_Ad 0x62


Servo S1;
LIDARLite L1;

const int Ldr = A1;
int Ldv = 0;
int xi = 0;


int wbpc = 0; //mode select counter
int wbs = 0; //mode button state
int wbls = 0;

const float pi = 3.14159265;
const float d2r = pi / 180;
const float s2g = 0.2962962963; //0.15 for qs
int TSC = 0;
int SC = 0;

float R = 0;

float Maxldr = 0;
float curLd = 0;
unsigned long pulseWidth;
int Gtn = 0;


//boolean strt = true;
volatile bool Gbs = false;

void setup() {
  // initialize the LED pin as an output:





  Serial.begin(115200);
  S1.attach(5);


  pinMode(Trg, OUTPUT);
  digitalWrite(Mon, LOW);
  pinMode(Mon, INPUT);


  pinMode(Gbtn, INPUT);
  pinMode(Wbtn, INPUT);
  pinMode(Rbtn, INPUT);

  pinMode(GLED, OUTPUT);
  pinMode(BLED, OUTPUT);
  digitalWrite(GLED, LOW);
  digitalWrite(BLED, LOW);

  pinMode(MS1 , OUTPUT); //halfstep
  pinMode(MS2 , OUTPUT); //halfstep
  pinMode(Step_pin , OUTPUT); //step pin
  pinMode(Dir_pin , OUTPUT); //clockwise / antclockwise
  pinMode(Enb, OUTPUT);
  //
  digitalWrite(MS1, HIGH);
  //HS  //LOW Qs
  digitalWrite(MS2, LOW);
  //HS  //HIGH Qs



  //xi = S1.read();
  //if (xi != 19)
  //{
  //  S1.write(19); //Zero pos servo
  //  delay(400);
  //}
  Maxldr = analogRead(Ldr);
//
//
//  attachInterrupt(1, halt, RISING);
}

void loop()
{


  Calibrate();

  wbs = digitalRead(Wbtn);

  if ( wbs != wbls)
  {
    if (wbs == HIGH)
    {
      wbpc++;
    }

    delay(50);
  }
  wbls = wbs;

  while (digitalRead(Gbtn) != HIGH)
  {
    if (wbpc % 2 == 0)
    {
      digitalWrite(BLED, HIGH);
      digitalWrite(GLED, LOW);

    }
    else
    {
      digitalWrite(GLED, HIGH);
      digitalWrite(BLED, LOW);
    }

    if (digitalRead(Wbtn) == HIGH)
    {
      wbpc++;
    }

    delay(200);

  }

  if (wbpc % 2 == 0)
  {
    Lscan();
  }

  else
  {
    Tscan();
  }

}






void Step()
{

  digitalWrite(Dir_pin, HIGH);
  digitalWrite(Step_pin, HIGH);
  delay(1);
  digitalWrite(Step_pin, LOW);
  delay(2);
}


void Calibrate()
{
  xi = S1.read();
  if (xi != 19)
  {
    S1.write(19); //Zero pos servo
    delay(400);
  }

  Ldv = analogRead(Ldr);
  curLd = Ldv / Maxldr;
  while (curLd > 0.6)
  {
    Step();
    delay(10);
    Ldv = analogRead(Ldr);
    curLd = Ldv / Maxldr;
  }
  //  while(Ldv <= 120)
  //  {
  //    Step();
  //    delay(10);
  //    Ldv = analogRead(Ldr);
  //  }
  //
  //    while(Ldv > 100)
  //  {
  //    Step();
  //    SC++;
  //    Ldv = analogRead(Ldr);
  //
  //  }
}


void Lscan()
{
  digitalWrite(BLED, HIGH);
  digitalWrite(GLED, LOW);
  for (int i = 0 ; i < 10 ; i++)
  {
    R = 19.000;
    for (int j = 0 ; j < 1215 ; j++)
    {
      Step();
      Serial.println(Output (R, SC));
      delay(3);
      SC++;
    }

    SC = 0;

  }
}


void Tscan()
{

  for (int i = 0 ; i < 90 ; i++)
  {
    R = S1.read();
    for (int j = 0 ; j < 1215 ; j++)
    {
      Step();
      Serial.println(Output(R, SC));
      delay(3);
      SC++;
    }
    SC = 0;

    S1.write(19 + i);
    delay(200);

  }

}

//


//
//void halt()
//{
//  Gbs = digitalRead(Gbtn);
//  while(Gbs != HIGH)
//{
//  
//}
//  
//    
//  
//}



int dis()
{
  int thisd = 0;
  pulseWidth = pulseIn(Mon, HIGH); // Count how long the pulse is high in microseconds

  // If we get a reading that isn't zero, let's print it
  if (pulseWidth != 0)
  {
    pulseWidth = pulseWidth / 10; // 10usec = 1 cm of distance
    thisd = (pulseWidth); // Print the distance
  }

  return thisd;
}


String Output( float r , int sc)
{
  //  int radius = 0;
  //  if ((sc/100 == 1) || (sc/100 == 2) || (sc/100 == 3) || (sc/100 == 4) || (sc/100 == 5) || (sc/100 == 6))
  //  {
  //    radius = dis(true,LL_Ad);
  //  }
  //
  //  else
  //  radius = dis(false,LL_Ad);
  //
  float azi = ((sc * s2g) * d2r);
  float eli = (90 - (r - 19)) * d2r;
  int radius = 0;
  radius = dis();
  double x = radius * sin(eli) * cos(azi);
  double y = radius * sin(eli) * sin(azi);
  double z = radius * cos(eli);
  return (String(x, 5) + " " + String(y, 5) + " " + String(z, 5));
  //   return(String(sc)+ " " + String(r,4));
  //  return (String(radius) + " " + String(sc) + " " +String(r) + " " + " | " + String(x,4) + " " + String (y,4) + " " + String(z,4)  );
}
