function [ExpData]=ExpDataD(firstV,discValue,lastV,colTorque)
    DataICAEEG10=ReadDataEEG1();
    TorqueD=ReadDataTorque1();

    DataICAEEG11=DataICAEEG10(firstV:discValue:lastV,:);    //Graficando, el canal 11 muestra respuesta aprox. en ese rango
    TorqueD1=TorqueD(firstV:discValue:lastV,:);

    [m,n]=size(DataICAEEG11);
    j=1;
    
    //EEG Canales  10 y 11 son para control
    //Cuando en el canal 11 existe un valor de 100, se está ejecutando el experimento 
    for i=1:m
        if DataICAEEG11(i,11)==100 then
            dataEEGD(j,:)=DataICAEEG11(i,:);
            dataTorqueD(j,:)=TorqueD1(i,:);
            j=j+1;
        end
    end

    //ColTorque: Tiempo(1),Cadera(2),Rodilla(3),tobillo(4)
    ExpData=[dataEEGD(:,1:9) dataTorqueD(:,colTorque)];
    
    subplot(131)
    plot(DataICAEEG10(:,1:9))
    plot(TorqueD(:,colTorque),'r')
    plot(DataICAEEG10(:,11),'k')
    a=get("current_axes")//get the handle of the newly created axes
    a.data_bounds=[0,min(DataICAEEG10);120000,100];
    a.title.text="Original data"
    a.title.font_size = 4;
    
    subplot(132)
    plot(DataICAEEG11(:,1:9))
    plot(TorqueD1(:,colTorque),'r')
    plot(DataICAEEG11(:,11),'k')
    a=get("current_axes")//get the handle of the newly created axes
    a.data_bounds=[0,min(DataICAEEG11);m,max(TorqueD1)];
    a.title.text="Discretized data"
    a.title.font_size = 4;

    subplot(133)
    plot(dataEEGD(:,1:9))
    plot(dataTorqueD(:,colTorque),'r')
    a=get("current_axes")//get the handle of the newly created axes
    [o,p]=size(dataEEGD)
    a.data_bounds=[0,min(dataEEGD);o,max(dataTorqueD)];
    a.title.text="ExpData"
    a.title.font_size = 4;


endfunction

//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1
//Desnormalization
//Interval [0, 1] -> [LMIN, LMAX]

function a=desnormalization(Vn,LMIN,LMAX)

a=Vn*LMAX+LMIN*(1-Vn);

if a>LMAX
    a=LMAX;
end
if a<LMIN
    a=LMIN;
end

endfunction

//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1
//Normalization. Interval [LMIN, LMAX] -> [0, 1]

function a=normalization(Van,LMIN,LMAX)

a=(Van-LMIN)/((LMAX-LMIN)+0.000001);

if a>1
    a=1;
end
if a<0
    a=0;
end

endfunction


//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1
//Maxp function
function [posmax, valmax]=maxp(V)

temp=size(V);
NTB=max(temp);

posmax=0;
valmax=0;
for b=1:NTB
    if V(b)>valmax
        valmax=V(b);
        posmax=b;    
    end
end


endfunction


//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1
//Maxp


function [posmin, valmin]=minp(V)

temp=size(V);
NTB=max(temp);

posmin=0;
valmin=1000000000;
for b=1:NTB
    if V(b)<valmin
        valmin=V(b);
        posmin=b;    
    end
end

endfunction



//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1
//shaking
function [M] = shaking(M)

[NTPat NTCol]=size(M);
//Shaking the information

for i=1:10*NTPat
    pos1 = round(rand()*NTPat+0.5);
    pos2 = round(rand()*NTPat+0.5);
    
    temp=M(pos1,:);
    M(pos1,:)=M(pos2,:);
    M(pos2,:)=temp;
  end
  
endfunction


//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1


function [DataTrain,DataVal2,MRange] = GenTrainVal(DataExp,DataVal)


[NTPat NTCol]=size(DataExp);
//Shaking the information

for i=1:10*NTPat
    pos1 = round(rand()*NTPat+0.5);
    pos2 = round(rand()*NTPat+0.5);
   
    temp=DataExp(pos1,:);
    DataExp(pos1,:)=DataExp(pos2,:);
    DataExp(pos2,:)=temp;
end

//Normalization of the data;
[NTD NTCols]=size(DataExp); //columns of the data 
[NTR2,NTC2]=size(DataExp);
DataN=zeros(NTR2,NTC2);
//Matriz to save every range of the matrix
MRange=zeros(NTCols,2);//1-Lmin, 2-Lmax
for col=1:NTCols
    Lmax = max(DataExp(:,col)); 
    Lmin = min(DataExp(:,col)); 
    MRange(col,1)=Lmin; MRange(col,2)=Lmax;
    DataN(:,col)=(DataExp(:,col)-Lmin)./(Lmax-Lmin);
end

//Generation of Training data base
//percent=100%
DataTrain = DataN;

//Otra ventana (DataVal)

[NTPat NTCol]=size(DataVal);
//Shaking the information

for i=1:10*NTPat
    pos1 = round(rand()*NTPat+0.5);
    pos2 = round(rand()*NTPat+0.5);
    
    temp=DataVal(pos1,:);
    DataVal(pos1,:)=DataVal(pos2,:);
    DataVal(pos2,:)=temp;
end

//Normalization of the data;
[NTD NTCols]=size(DataVal); //columns of the data 
[NTR2,NTC2]=size(DataVal);
DataN=zeros(NTR2,NTC2);
//Matriz to save every range of the matrix
for col=1:NTCols
    Lmax = max(DataVal(:,col)); 
    Lmin = min(DataVal(:,col)); 
    DataN(:,col)=(DataVal(:,col)-Lmin)./(Lmax-Lmin);
end

//Generation of Training data base
//percent=100%
DataVal2 = DataN;

endfunction


//Neural net code begin here...
//Activation function

function y=fa(x)
     
if x>20 x=20; end
if x<-20 x=-20; end
x = exp(-x);
y = 1 / ( 1 + x );

endfunction



//Derivate of activation function

function y=fad(x)
  
     y = fa(x)*(1-fa(x));
    
endfunction
  
  
    

//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1


function [M, MA, O, OA]=RandomWeights(TI, TM, TO)
//build 

M = zeros(TM,TI);
O = zeros(TO, TM);
MA = zeros(TM, TI);
OA = zeros(TO, TM);

for i=1:TI
    for n=1:TM
              M(n,i) = rand() - 0.5;

    end
end
  
     for n=1:TM
         for o=1:TO
                  O(o,n)=rand() - 0.5;
         end
     end
     
endfunction
   

   
//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1   
function [SM,SO,NO,NM] = ForwardBKG(X,M,O)

[TM TI] = size(M);
[TO TM] = size(O);

NO=zeros(1,TO); //Integrated signal before activation function output neuron
NM=zeros(1,TM); //Integrated signal before activation function middle neuron

SO = zeros(1,TO); //Activation per Ouput neuron
SM = zeros(1,TM); //Activation per Middle neuron


    for n=1:TM
         NM(n)=0;
    end

     for n=1:TM
         for i=1:TI
                  NM(n) = NM(n) + M(n,i) * X(i);
         end
                  SM(n) = fa(NM(n));
     end
     
     for o=1:TO
         NO(o) = 0;
     end
     
     for o=1:TO
         for n=1:TM
            NO(o) = NO(o) + O(o,n) * SM(n);
            
         end
         SO(o) = fa(NO(o));
     end
     
endfunction
     

   
//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1  
function [EM,EO] = BackwardBKG(YD,SO, NM, M, NO, O)

[TM TI] = size(M);
[TO TM] = size(O);

EO=zeros(1,TO);
EM=zeros(1,TM);

sum1=0;
 
      for o=1:TO
          EO(o)=(YD(o) - SO(o))*fad(NO(o));
      end
      for n=1:TM
          sum1=0;
          for o=1:TO
            sum1 = sum1 + EO(o)*O(o,n);
          end
             EM(n) = fad(NM(n))*sum1;
     end
endfunction     
     
function [M, MA, O, OA] = LearningBKG(X, M, MA, SM, EM, O, OA, EO, ETA, ALPHA)


[TM TI] = size(M);
[TO TM] = size(O);

for o=1:TO
         for n=1:TM
             O(o,n) = O(o,n) + ETA*EO(o)*SM(n) + ALPHA*OA(o,n);
             OA(o,n) = ETA*EO(o)*SM(n);
         end
end

for n=1:TM
        for i=1:TI
            M(n,i) = M(n,i) + ETA*EM(n) * X(i) + ALPHA*MA(n,i);
            MA(n,i) = ETA*EM(n)*X(i);
        end
    end
    
endfunction
  
function DataICAEEG10=ReadDataEEG1()
    
    [DataICAEEG10]=read('S1_P2_ICAEEG10.txt',-1,11);
    
endfunction


function TorqueD=ReadDataTorque1()
    
    
[TorqueD]=read('TorqueData.txt',-1,4);
    
endfunction



function [M,O, errcm, Errg,MRange,Ynn]=TestBK1(ExpData,ValData,NE) 
//NE - epochs
 
// Using a backpropagation neural network

TI =9+1; //Inpout neurons plus one (bias)
TM = 20; //Inner neurons
TO = 1; //Output neurons
ETA = 0.5; //0.25 //Constante de aprendizaje : entre 0.25 y 0.01
ALPHA = 0.15;//0.125 //parametro de momento:menor que uno y positivo


//Uniform Random Inicialization
[M, MA, O, OA]=RandomWeights(TI, TM, TO);

//Normalization
[DataTrain,DataVal2,MRange] = GenTrainVal(ExpData,ValData);
[NP NC] = size(DataTrain); //NUmber of patterns NP

//Auxiliar structures
XI = zeros(NP,TI); //plus bias
YO = zeros(NP,TO);

//*******************************
//Input-Output Especifications for Training
//*******************************      

//x1 
XI(:,1) = DataTrain(:,1);
// x2
XI(:,2) = DataTrain(:,2);
// x3 
XI(:,3) = DataTrain(:,3);
// x4 
XI(:,4) = DataTrain(:,4);
// x5 
XI(:,5) = DataTrain(:,5);
// x6 
XI(:,6) = DataTrain(:,6);
// x7 
XI(:,7) = DataTrain(:,7);
// x8 
XI(:,8) = DataTrain(:,8);
// x9 
XI(:,9) = DataTrain(:,9);
//  Bias
XI(:,10) = DataTrain(:,9)*0+1;

//y angulo del servo
YO = DataTrain(:,10);

//End of the data structure

Errg=[];
emin=10000000;

for noe=1:NE
etotal=0;

//Shaking to generate random positions of patterns
AX=[XI YO];
[AX] = shaking(AX);
[NP NC] = size(AX);
XI = AX(:,1:NC-1);
YO = AX(:,NC);

//forced learning pattern by pattern
for p=1:NP
       
        X=XI(p,:);
        YD = YO(p,:);
        
        [SM,SO,NO,NM] = ForwardBKG(X,M,O);
        [EM,EO] = BackwardBKG(YD,SO, NM, M, NO, O);
        [M, MA, O, OA] = LearningBKG(X, M, MA, SM, EM, O, OA, EO, ETA, ALPHA);
        etotal= EO*EO + etotal;   
             
end
    
    errcm = 0.5*sqrt(etotal);
  
    
    
    if errcm<emin
        emin=errcm;
    end
    
    Errg=[Errg emin];
    
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Test Training
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Ynnt=[];
for p=1:NP
     X=XI(p,:);
     YD = YO(p,:);
    [SM,SO,NO,NM] = ForwardBKG(X,M,O);
     a=[YD SO];
     Ynnt = [Ynnt; a];
end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Define the structures for validation
[NP NC] = size(DataVal2); 
XI = zeros(NP,TI); //plus bias
YO = zeros(NP,TO);

//x1
XI(:,1) = DataVal2(:,1);
// x2 
XI(:,2) = DataVal2(:,2);
//x1
XI(:,3) = DataVal2(:,3);
//x1
XI(:,4) = DataVal2(:,4);
//x1
XI(:,5) = DataVal2(:,5);
//x1
XI(:,6) = DataVal2(:,6);
//x1
XI(:,7) = DataVal2(:,7);
//x1
XI(:,8) = DataVal2(:,8);
//x1
XI(:,9) = DataVal2(:,9);
// Bias 
XI(:,10) = DataVal2(:,9)*0+1;

//y
YO = DataVal2(:,10);

//End of the data structure

Ynn=[];
for p=1:NP
     X=XI(p,:);
     YD = YO(p,:);
     [SM,SO,NO,NM] = ForwardBKG(X,M,O);
     a=[YD SO];
     Ynn = [Ynn; a];
end

clf

subplot(131)
plot(Ynnt)
legend('Real', 'Predicted'),

subplot(132)
plot(Ynn(:,1),'.-k')
legend('Real', 'Predicted'),
xlabel('Test patterns')
ylabel('Response')
plot(Ynn(:,2),'x:b')
legend('Real', 'Predicted'),
xlabel('Test patterns')
ylabel('Response')

subplot(133)
plot(Errg)
xlabel('Training epochs')
ylabel('Error')

endfunction

//All rights reserved
//Dr. Luis M. Torres-Treviño
//Review 2016 june
//LMTT062016v1  
    
function [Rn, YnnN]=UseNNBK(ValData,M,O,MRange)
[m,n]=size(ValData);
for f=1:m
x1n = normalization(ValData(f,1),MRange(1,1),MRange(1,2));
x2n = normalization(ValData(f,2),MRange(2,1),MRange(2,2));
x3n = normalization(ValData(f,3),MRange(3,1),MRange(3,2));
x4n = normalization(ValData(f,4),MRange(4,1),MRange(4,2));
x5n = normalization(ValData(f,5),MRange(5,1),MRange(5,2));
x6n = normalization(ValData(f,6),MRange(6,1),MRange(6,2));
x7n = normalization(ValData(f,7),MRange(7,1),MRange(7,2));
x8n = normalization(ValData(f,8),MRange(8,1),MRange(8,2));
x9n = normalization(ValData(f,9),MRange(9,1),MRange(9,2));

     Xn = [x1n x2n x3n x4n x5n x6n x7n x8n x9n 1];
     Xnn(f,:)=[x1n x2n x3n x4n x5n x6n x7n x8n x9n 1];
     [SM,SO,NO,NM] = ForwardBKG(Xn, M, O);

     //Desnormalization 
     //Diameter (mm)
     R(f,1) = desnormalization(SO, MRange(10,1), MRange(10,2)),
     Rn(f,1)=SO;
end
ValDataN=normalization(ValData,MRange(10,1),MRange(10,2));
YnnD=[R ValData(:,10)];
YnnN=[Rn ValDataN(:,10)];//DataN(:,10)];
plot(Rn,'r')
plot(ValDataN(:,10),'b')
endfunction

function [press, sst, R2Pred]=statistics(YnnN, ValData)
    [sstD, col]=size(YnnN);
    Verr=YnnN(:,1)-YnnN(:,2);
    press=sum(Verr.^2)
    YO=YnnN(:,2);
    sst=YO'*YO-sum(YO.*2)/sstD
    R2Pred=1-press/sst
endfunction

    







