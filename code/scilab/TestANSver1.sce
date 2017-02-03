

//Neural computation


//basic functions


function [VO]=VDIS(e,VI)
    
    TE=max(size(VI));
    VO=zeros(1,TE);
    
    for elem=1:TE
            VO(elem)=e;
    end
        
endfunction


function [MO]=MDIS(e,MI)
    
    [TR,TC]=size(MI);
    MO=zeros(TR,TC);
    
    for r=1:TR
        for c=1:TC
            MO(r,c)=e;
        end 
    end
    
endfunction




function s=SumM(M)
    
    [TR,TC]=size(M);
    s=0;
     for r=1:TR
        for c=1:TC
            s = s + M(r,c);
        end 
    end
    
endfunction



function y=FGauss(x,cm,lambda)
    y=exp(-(x-cm)^2/lambda);
endfunction


function [MO]=EVFGauss(MI,cm,lambda)
    //Gaussian function for all the elements of the matrix
    [TR, TC]=size(MI);
    MO=zeros(TR,TC);
    
    for r=1:TR
        for c=1:TC
            MO(r,c)=FGauss(MI(r,c),cm,lambda);
        end 
    end
endfunction


function [MO]=MADD(MI1,MI2)
    
     [TR, TC]=size(MI1);
     MO=zeros(TR,TC);
     
    
     
    for r=1:TR
        for c=1:TC
            MO(r,c)=MI1(r,c)+MI2(r,c);
        end 
    end
    
    
endfunction




function [MO]=MSUB(MI1,MI2)
    
     [TR, TC]=size(MI1);
     MO=zeros(TR,TC);
     
    
     
    for r=1:TR
        for c=1:TC
            MO(r,c)=MI1(r,c)-MI2(r,c);
        end 
    end
    
    
endfunction




function [MO]=MMUL(MI1,MI2)
    
     [TR, TC]=size(MI1);
     MO=zeros(TR,TC);
     
    
     
    for r=1:TR
        for c=1:TC
            MO(r,c)=MI1(r,c)*MI2(r,c);
        end 
    end
    
endfunction


function [row,column]=CMC(MI)
    
     [TR, TC]=size(MI);
     
     
     //Rows
    s1=0;s2=0;
    for r=1:TR
        aux=0;
        for c=1:TC
            aux = MI(r,c) + aux;
        end
        s1 = s1 + aux*r;
        s2 = s2 + aux;
    end
    
    row = s1/s2;
    
    //Column
    
    s1=0;s2=0;
    for c=1:TC
        aux=0;
        for r=1:TR
            aux = MI(r,c) + aux;
        end
        s1 = s1 + aux*c;
        s2 = s2 + aux;
    end
    
    column=s1/s2;
    
endfunction


//***************  Artificial Neural System  ******

function [sa]=NGauss(sa)
    
    lambda=0.14;
    cm=0.25;
    sa=FGauss(sa,cm,lambda);
    
    
endfunction



function [y,sa]=ANSV1(e,sa)
    
     W1=[0.1 0.2 0.3; 0.6 0.5 0.4; 0.7 0.8 0.9];
     //W2=[0.1 0.2 0.3; 0.6 0.5 0.4; 0.7 0.8 0.9];
     W2=[0 0.0182 0; 0.6814 0 0.2645; 0 0.9984 0];
     //A1=[-0.3 -0.7 0.48; -0.7 -0.2 0.5; 0.2 0 0.9];
     //A1=[0 0 0; 0.350 1 0; 0.350 0 0.550];
     A1=[0 0 1;1 0 1; 0 1 0];
    

     Maux=zeros(3,3);
     
     [MO]=MDIS(e,Maux);
     [MO1]=MSUB(MO,W1);
     
     [sa]=NGauss(sa);
      [MO]=MDIS(sa,Maux);
     [MO2]=MSUB(MO,W2);
     
     
      [Maux]=MADD(MO1,MO2);
      [MO]=EVFGauss(Maux,0.0,0.15);
      
      [MO1]=MMUL(MO,A1);
      
      s1=SumM(MO1);
      s2=SumM(MO);
      
      
    y=s1/(s2+0.00000052);
    
    
    
endfunction



function [Rep]=plotbehavior(e)
    sa=rand();
    
    Rep=[];
    for ti=1:250
        [y,sa]=ANSV1(e,sa);
        Rep=[Rep; y];
     end
    
    
endfunction



//Second experiment


function [MO,sa]=ANSV2(e,sa)
    
     W1=[0.1 0.2 0.3; 0.6 0.5 0.4; 0.7 0.8 0.9];
     W2=[0.1 0.2 0.3; 0.6 0.5 0.4; 0.7 0.8 0.9];
     //A1=[-0.3 -0.7 0.48; -0.7 -0.2 0.5; 0.2 0 0.9];
     //A1=[0 0 0; 0.350 1 0; 0.350 0 0.550];
      A1=[0.1 0.1 0.1; 0.10 1 0.1; 0.1 0 0.1];
    
    
     Maux=zeros(3,3);
     
     [MO]=MDIS(e,Maux);
     [MO1]=MSUB(MO,W1);
     
     [sa]=NGauss(sa); //Chaotic neuron
     [MO]=MDIS(sa,Maux);
     [MO2]=MSUB(MO,W2);
     
     
      [Maux]=MADD(MO1,MO2);
      [MO]=EVFGauss(Maux,0.0,0.15);
      
      [MO]=MMUL(MO,A1);
       
      //[row,column]=CMC(MO);
      
      //CM=[row column];

    
    
endfunction




function [Rep]=plotbehavior2(e)
    //sa=rand();
    sa=0;
    Rep=[];
    for ti=1:500
        [MO,sa]=ANSV2(e,sa);
        Rep=[Rep; MO(2,2)];
    end
    //[Rep]=plotbehavior2(0.1);
 
    //plot(Rep(20:2500,1),Rep(20:2500,2),':*m')
    
endfunction



function [Rep]=plotbehavior3(e)
    //sa=rand();
    sa=0;
    Rep=[];
    for ti=1:450
        [MO,sa]=ANSV2(e,sa);
        Rep=[Rep; MO(:,1:2)];
    end
    
    
    
    for ti=1:50
        
        [MO,sa]=ANSV2(e,sa);
        //Rep=[Rep; MO(:,1:2)];
        Rep=[Rep; MO(2,1:2)];
    end
    
    //[Rep]=plotbehavior2(0.1);
 
    //plot(Rep(20:2500,1),Rep(20:2500,2),':*m')
    
endfunction




function [Rep]=plotbehavior4(e)
    sa=rand();
    
    Rep=[];
    for ti=1:250
        [y,sa]=ANSV1(e,sa);
        Rep=[Rep; y];
     end
    
    //A perturbation is given
    
    sa=0;
    
    for ti=1:25
        [y,sa]=ANSV1(e,sa);
        Rep=[Rep; y];
     end
    
    
    
endfunction


function [Rep]=plotbehavior5()
    
    //Applying different stimulus
    sa=rand();
    
    Rep=[];
    for ti=1:100
        [y,sa]=ANSV1(0.1,sa);
        Rep=[Rep; y];
     end
    
    
    
    for ti=1:100
        [y,sa]=ANSV1(0.5,sa);
        Rep=[Rep; y];
     end
     
     
      for ti=1:100
        [y,sa]=ANSV1(0.9,sa);
        Rep=[Rep; y];
     end
    
    
    
endfunction



function Report3()

    [Rep]=plotbehavior(0.1);
    
    Xk=Rep(50:250);
    
    Xkmo=Rep(49:249);
    
    plot(Xkmo,Xk,':*b');
    
     [Rep]=plotbehavior(0.5);
    
    Xk=Rep(50:250);
    
    Xkmo=Rep(49:249);
    
    plot(Xkmo,Xk,'-*g');
    
     [Rep]=plotbehavior(0.9);
    
    Xk=Rep(50:250);
    
    Xkmo=Rep(49:249);
    
    plot(Xkmo,Xk,'.-*k');
    
    legend('e=0.1','e=0.5','e=0.9')
     title('Performance of dynamic neural system with different stimmulus (e)')
    xlabel('X(k-1');
    ylabel('Y(k-1');
   
endfunction


function Report4()

    [Rep]=plotbehavior4(0.2);

    Xk=Rep(50:250);
    Xkmo=Rep(49:249);
    plot(Xkmo,Xk,':*b')
    
   
    Xk=Rep(250:275);
    Xkmo=Rep(249:274);
    
    plot(Xkmo,Xk,':*g')
    
    Xk=Rep(50:250);
    Xkmo=Rep(49:249);
    plot(Xkmo,Xk,':*b')
    
    
    title('Performance of dynamic neural system under perturbation (e=0.2)')
    xlabel('X(k)')
    ylabel('X(k+1)')
    
endfunction


function Report5()
    
    
    [Rep]=plotbehavior5();
    Xk=Rep(2:300);
    Xkmo=Rep(1:299);
    plot(Xkmo,Xk,':*b')
    
    Xk=Rep(20:100);
    Xkmo=Rep(19:99);
    plot(Xkmo,Xk,':or')
    
    Xk=Rep(120:200);
    Xkmo=Rep(119:199);
    plot(Xkmo,Xk,':or')
    
    Xk=Rep(220:300);
    Xkmo=Rep(219:299);
    plot(Xkmo,Xk,':or')
 

     title('Performance of dynamic neural system considering continuous change of stimulus')
    xlabel('X(k)')
    ylabel('X(k+1)')
    
    
    
    
    
endfunction


