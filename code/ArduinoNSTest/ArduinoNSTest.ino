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

float aMat[3][3]  =  {{ 1, 1, 1},    
                        { 1, 1, 1},  
                        { 1, 1, 1}};
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:

  e = 0;//analogRead(pot);
  
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
      rMat[i][j] = rMat[i][j] * aMat[i][j];
    }
  }

  Serial.println("******************************");
  Serial.print("N(0,0) = ");
  Serial.println(rMat[0][0]);
  Serial.print("N(1,1) = ");
  Serial.println(rMat[1][1]);
  Serial.print("N(2,2) = ");
  Serial.println(rMat[2][2]);
  Serial.println("******************************");

  delay(500);
  
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


