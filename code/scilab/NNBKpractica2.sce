

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

//Algoritmya Evolutionary computation 2004
//Proyect of simplification of algorithms
//Autor: Luis Torres T.
//All rights reserved
//May 2004
//Evolution Strategies and Genetic Algorithms
//Maxp


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

//Algoritmya Evolutionary computation 2004
//Proyect of simplification of algorithms
//Autor: Luis Torres T.
//All rights reserved
//May 2004
//Evolution Strategies and Genetic Algorithms
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


function [DataTrain,DataVal1,DataVal2,MRange] = GenTrainVal(DataExp,percent)
    //LMTT2006 Derechos reservados 2006

//Generation of training and validation databases

[NTPat NTCol]=size(DataExp);
//Shaking the information

for i=1:10*NTPat
    pos1 = round(rand()*NTPat+0.5);
    pos2 = round(rand()*NTPat+0.5);
    
    temp=DataExp(pos1,:);
    DataExp(pos1,:)=DataExp(pos2,:);
    DataExp(pos2,:)=temp;
end

//Normalization of information

//Normalization of the data;
[NTD NTCols]=size(DataExp); //columns of the data 
[NTR2,NTC2]=size(DataExp);
DataN=zeros(NTR2,NTC2);
//Matriz to save every range of the matrix
MRange=zeros(NTCols,2);//1-Lmin, 2-Lmax
for col=1:NTCols
    Lmax = max(DataExp(:,col)); //+max(DataExp(:,col))*0.1;
    Lmin = min(DataExp(:,col)); //-min(DataExp(:,col))*0.1;
    MRange(col,1)=Lmin; MRange(col,2)=Lmax;
    DataN(:,col)=(DataExp(:,col)-Lmin)./(Lmax-Lmin);
end

//Generation of Training data base
//percent=0.8;
posel=round(percent*NTPat);
DataTrain = DataN(1:posel,:);

//Generation of validation Data Base
//Direct experimental data
DataVal1 = DataN(posel:NTPat,:);


//Random NTPat data
DataVal2=zeros(NTPat,NTCols);
for d=1:100
    pos=round(rand()*NTPat+0.5);
    DataVal2(d,:) = DataN(pos,:);
end

endfunction

function y=fa(x)
     
if x>20 x=20; end
if x<-20 x=-20; end
x = exp(-x);
y = 1 / ( 1 + x );

endfunction

    function y=fad(x)
  
     y = fa(x)*(1-fa(x));
    
endfunction
  
  
    



function [m, ma, o, oa]=RandomWeights(TINP, TMID, TOUT)
//LMTT2006 Derechos reservados 2006
m = zeros(TMID,TINP);
o = zeros(TOUT, TMID);
ma = zeros(TMID, TINP);
oa = zeros(TOUT, TMID);

for x=1:TINP
    for y=1:TMID
              m(y,x) = rand() - 0.5;

    end
end
  
     for y=1:TMID
         for z=1:TOUT
                  o(z,y)=rand() - 0.5;
         end
     end
     
endfunction
   
function [sm,so,neto,netm] = ForwardBKG(VI,m,o)
//LMTT2006 Derechos reservados 2006
[TMID TINP] = size(m);
[TOUT TMID] = size(o);

neto=zeros(1,TOUT);
netm=zeros(1,TMID);

so = zeros(1,TOUT); //activation per ouput neuron
sm = zeros(1,TMID); //Activation per middle neuron

//TINP, TMID, TOUT,pause
    for y=1:TMID
         netm(y)=0;
    end
     for y=1:TMID
         for x=1:TINP
                  netm(y) = netm(y) + m(y,x) * VI(x);
                  
         end
                  sm(y) = fa(netm(y));
     end
     
     for z=1:TOUT
         neto(z)=0;
     end
     for z=1:TOUT
         for y=1:TMID
            neto(z) = neto(z) + o(z,y) * sm(y);
            
         end
         so(z) = fa(neto(z));
     end
     
   endfunction
     

function [em,eo] = BackwardBKG(DO, netm, m, o, so, neto)
  //LMTT2006 Derechos reservados 2006
  //desired output DO

[TMID TINP] = size(m);
[TOUT TMID] = size(o);

eo=zeros(1,TOUT);
em=zeros(1,TMID);
sum1=0;
 
      for z=1:TOUT
          eo(z)=(DO(z) - so(z))*fad(neto(z));
      end
          sum1=0;
      for y=1:TMID
          sum1=0;
          for z=1:TOUT
            sum1 = sum1 + eo(z)*o(z,y);
          end
             em(y) = fad(netm(y))*sum1;
     end
endfunction     
     
function [m, ma, o, oa] = LearningBKG(VI, m, ma, sm, em, o, oa, eo, ETA, ALPHA)
//LMTT2006 Derechos reservados 2006
[TMID TINP] = size(m);
[TOUT TMID] = size(o);

for z=1:TOUT
         for y=1:TMID
             o(z,y) = o(z,y) + ETA*eo(z)*sm(y) + ALPHA*oa(z,y);
             oa(z,y) = ETA*eo(z)*sm(y);
         end
end

for y=1:TMID
  
        for x=1:TINP
            m(y,x) = m(y,x) + ETA*em(y) * VI(x) + ALPHA*ma(y,x);
            ma(y,x) = ETA*em(y)*VI(x);
        end
    end
    
endfunction
  

function [m,o, errcm, MRange]=TestNNBK(NTEpochs)
//Programador: Dr. Luis M. Torres TreviÃ±o
//LMTT2006 Derechos reservados 2014
clf
//Sensor Izquierdo	Sensor derecho	Angulo del servo
//S1	S2	A  encabezado

ExpData=[0.19	0.01	0.12
0.19	0.01	0.12
0.86	0.37	0.12
0.88	0.42	0.11
0.77	0.44	0.07
0.72	0.42	0.02
0.63	0.38	0.01
0.6	0.11	0.04
0.6	0.18	0.01
0.87	0.36	0.11
0.87	0.34	0.14
0.86	0.28	0.17
0.87	0.31	0.18
0.85	0.25	0.22
0.83	0.09	0.22
0.87	0.12	0.29
0.86	0.14	0.38

];
 
// Using a backpropagation neural network

TINP =2+1; //Neuronas de la capa de entrada mas polarización
TMID = 5; //Neuronas de la capa media
TOUT = 1; //Neuronas de la capa externa
ETA = 0.25; //Constante de aprendizaje : entre 0.25 y 0.01
ALPHA = 0.125; //parÃ¡metro de momento:menor que uno y positivo
//NTEpochs=20;
noe=0;
// o-out, r-resultante o esperado, m-medio, e-error, i-input
x=0;y=0;w=1;pat=0;cuenta=0;

[m, ma, o, oa]=RandomWeights(TINP, TMID, TOUT); //se generan pesos aleatorios


[DataTrain,DataVal1,DataVal2,MRange] = GenTrainVal(ExpData,0.8);
[NTPat NTC] = size(DataTrain); 
XI = zeros(NTPat,TINP); //plus bias
YO = zeros(NTPat, TOUT);

//Input-Output Especifications -----------------------------se OMITE

//x1 sensor izquierdo
XI(:,1) = DataTrain(:,1);
// x2 sensor derecho
XI(:,2) = DataTrain(:,2);
//  Bias
XI(:,3) = DataTrain(:,2)*0+1;

//y angulo del servo
YO = DataTrain(:,3);

//End of the data structure

for z=1:TOUT
    eo(z) = 1;
end
Errg=[];
emin=10000000;

for noe=1:NTEpochs
etotal=0;

//Shaking
M=[XI YO];

[M] = shaking(M);

[pat NTcol] = size(M);

XI = M(:,1:NTcol-1);

YO = M(:,NTcol);

// aprendizaje obligatorio, patrÃ³n por patrÃ³n
for w=1:NTPat
       
        VI=XI(w,:);
        DO = YO(w,:);
        [sm,so,neto,netm] = ForwardBKG(VI,m,o);
        [em,eo] = BackwardBKG(DO, netm, m, o, so, neto);
        [m, ma, o, oa] = LearningBKG(VI, m, ma, sm, em, o, oa, eo, ETA, ALPHA);
        
        //' error:',eo(1),' salida n:  ',so,' salida real:  ',sr(1,w),
        etotal= eo*eo + etotal;             
end
    
    errcm = 0.5*sqrt(etotal);
    //noe,errcm,
    
    if errcm<emin
        emin=errcm;
    end
    
    Errg=[Errg emin];
    
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Test Training
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Ynn=[];
for w=1:NTPat
     VI=XI(w,:);
     DO = YO(w,:);
     [sm,so,neto,netm] = ForwardBKG(VI,m,o);
     a=[DO so];
     Ynn = [Ynn; a];
end

plot(Ynn)
legend('Real', 'Predicted'),pause

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Define the structures for validation
[NTPat NTC] = size(DataVal2); 
XI = zeros(NTPat,TINP); //plus bias
YO = zeros(NTPat, TOUT);

//x1
XI(:,1) = DataVal2(:,1);
// x2 
XI(:,2) = DataVal2(:,2);
// Bias 
XI(:,3) = DataVal2(:,2)*0+1;

//y
YO = DataVal2(:,3);

//End of the data structure

Ynn=[];
for w=1:NTPat
     VI=XI(w,:);
     DO = YO(w,:);
     [sm,so,neto,netm] = ForwardBKG(VI,m,o);
     a=[DO so];
     Ynn = [Ynn; a];
end

clf
plot(Ynn(:,1),'.-k')
plot(Ynn(:,2),'x:b')
legend('Real', 'Predicted'),
xlabel('Test patterns')
ylabel('Response')

//Store the weights for the model.

//save m
//save o

// ////***Probar el modelo ****
// 'Probar modelo'
// pause
// 
// VR=[255 27 55 15],
//         
//     //Normalize input
//     for col=1:4
//         Lmax=MRange(col,1); Lmin=MRange(col,2);
//         VRN(col)=(VR(col)-Lmin)./(Lmax-Lmin);
//     end
//     
//     //Give a input vector;
//      VI = [VRN 1]; 
//      [sm,so,neto,netm] = ForwardBKG(VI,m,o);
//     //VO,pause
//     
//     
//     //desnormalize
//     
//     R = desnormalization(so,MRange(6,2),MRange(6,1)),
pause    
clf
plot(Errg)
xlabel('Training epochs')
ylabel('Error')

endfunction
    
    
function [R]=UseNNBK(X,m,o,MRange)

//Sensor Izquierdo
x1n = normalization(X(1),MRange(1,1),MRange(1,2));
//Sensor Derecho
x2n = normalization(X(2),MRange(2,1),MRange(2,2));


     Xn = [x1n x2n 1];

     [sm,so,neto,netm] = ForwardBKG(Xn, m, o);

     //Desnormalization 
     //Diameter (mm)
     R = desnormalization(so, MRange(3,1), MRange(3,2)),

endfunction

