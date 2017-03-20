#include <Servo.h>

Servo pieDerecho;
Servo pieIzquierdo;
Servo piernaIzquierda;
Servo piernaDerecha;

float pieIzq;
float pieDer;
float piernaIzq;
float piernaDer;
long distance;
long pingTime;
float e = 0;
float sa = 0;
int pot = A0;

float eMat[3][3]  =  {{ 0, 0, 0},    
                        { 0, 0, 0},  
                        { 0, 0, 0}};

float saMat[3][3]  =  {{ 0, 0, 0},    
                        { 0, 0, 0},  
                        { 0, 0, 0}};                        

float m1[3][3]  =  {{ 0, 0, 0},    
                        { 0, 0, 0},  
                        { 0, 0, 0}};

float m2[3][3]  =  {{ 0, 0, 0},    
                        { 0, 0, 0},  
                        { 0, 0, 0}};

float w1[3][3]  =    {{ 0.1, 0.2, 0.3},    
                        { 0.6, 0.5, 0.4},  
                        { 0.7, 0.8, 0.9}};

float w2[3][3]  =    {{ 0.1, 0.2, 0.3},    
                        { 0.6, 0.5, 0.4},  
                        { 0.7, 0.8, 0.9}};

float rMat[3][3]  =  {{ 0, 0, 0},    
                        { 0, 0, 0},  
                        { 0, 0, 0}};

float aMat[3][3]  =  {{ 15, 1, 105},    //+85   //+15
                        { 1, 115, 1},  //+50
                        { 1, 1, 15}};   //+80
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pieDerecho.attach(10);
  pieIzquierdo.attach(11);
  piernaDerecha.attach(6);
  piernaIzquierda.attach(12);
  pinMode(9, OUTPUT);
  pinMode(8, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  e = getSensorValue();
  Serial.println(e);
  
  for(int i = 0;i < 3;i++){
    for(int j = 0;j < 3;j++){
      eMat[i][j] = e;
    }
  }

  for(int i = 0;i < 3;i++){
    for(int j = 0;j < 3;j++){
      m1[i][j] = w1[i][j] - eMat[i][j];
    }
  }

  sa = nGauss(sa);

  for(int i = 0;i < 3;i++){
    for(int j = 0;j < 3;j++){
      saMat[i][j] = sa;
    }
  }
  
  for(int i = 0;i < 3;i++){
    for(int j = 0;j < 3;j++){
      m2[i][j] = w2[i][j] - saMat[i][j];
    }
  }

  for(int i = 0;i < 3;i++){
    for(int j = 0;j < 3;j++){
      rMat[i][j] = m1[i][j] + m2[i][j];
    }
  }

  for(int i = 0;i < 3;i++){
    for(int j = 0;j < 3;j++){
      rMat[i][j] = gauss(rMat[i][j], 0.00, 0.15);
    }
  }

  for(int i = 0;i < 3;i++){
    for(int j = 0;j < 3;j++){
      rMat[i][j] = round (rMat[i][j] * aMat[i][j]);
    }
  }


  pieIzq = rMat[1][1] + 50.0;
  pieDer = rMat[0][2] + 15.0;
  piernaIzq = rMat[2][2] + 80.0;
  piernaDer = rMat[0][0] + 85.0;

  Serial.println("******************************");
  Serial.print("Pie Izquierdo: ");
  Serial.println(pieIzq);
  Serial.print("Pie Derecho: ");
  Serial.println(pieDer);
  Serial.print("pierna Izquierda: ");
  Serial.println(piernaIzq);
  Serial.print("pierna Derecha: ");
  Serial.println(piernaDer);
  Serial.println("******************************");
  
  pieDerecho.write(pieDer);
  pieIzquierdo.write(pieIzq);
  piernaIzquierda.write(piernaIzq);
  piernaDerecha.write(piernaDer);
  
  delay(700);

}

float nGauss(float x){
  float lambda = 0.14;
  float cm = 0.25; 
  x = gauss(x, cm, lambda);
  return x;
}

float gauss(float x, float cm, float lambda){
  float y;
  y = exp((-pow((x-cm), 2))/lambda);
  return y;
}

float getSensorValue(){
  float Stimulus;
  digitalWrite(9, LOW);
  delayMicroseconds(5);
  digitalWrite(9, HIGH);
  delayMicroseconds(10);
  pingTime = pulseIn(8, HIGH);
  distance = int(0.017*pingTime);
  Stimulus = constrain(distance, 0, 20);
  Stimulus = Stimulus/20;
  return Stimulus;
}

