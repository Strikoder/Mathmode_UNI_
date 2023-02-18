s=17.8;// начальное расстояние от лодки до катера   
fi=3*%pi/4;




function xt=f2(t) 
    xt=tan(fi)*t;
endfunction;


//функция, описывающая движение катера береговой охраны
function dr=f(tetha, r)
    dr=r/sqrt(22.04);
endfunction;



// случ1=0 + r0=s/5.8
//r0=s/5.8;
//tetha0=0;

//случае 2 
r0=s/3.8;
tetha0=-%pi; 

tetha=0:0.01:2*%pi;
r=ode(r0,tetha0,tetha,f);

t=0:1:40;



//функция, описывающая движение лодки браконьеров 


polarplot(tetha,r,style = color('green')); //построение траектории движения катера в полярных координатах
plot2d(t,f2(t),style = color('red'));
