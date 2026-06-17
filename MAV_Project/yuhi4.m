clc,clearvars;

%4 bar
l1=7;
l2=2;
l3=6;
l4=4;
l5=15;

th2=0:0.1:2*pi;
th3=zeros(1,length(th2));
th4=zeros(1,length(th2));
bd=(l1^2+l2^2-2*l1*l2*cos(th2)).^0.5;
gama=acos((l3^2+l4^2-bd.^2)/(2*l3*l4));

for i=1:length(th2)
    th3(i)=2*atan((-l2*sin(th2(i))+l4*sin(gama(i)))/(l1+l3-l2*cos(th2(i))-l4*cos(gama(i))));
    th4(i)=2*atan((l2*sin(th2(i))-l3*sin(gama(i)))/(l4-l1-l2*cos(th2(i))-l3*cos(gama(i))));
end

%coordinates

bx=l2*cos(th2);
by=l2*sin(th2);

cx=l2*cos(th2)+l3*cos(th3);
cy=l2*sin(th2)+l3*sin(th3);

dx=l1;
dy=0;

for i=1:length(th2)
    p=abs(dy-cy(i));
    b=abs(dx-cx(i));
    h=(p^2+b^2)^0.5;
    slope=p/b;
    r=l5;
    gx(i)=cx(i)+r*b/h;
    gy(i)=cy(i)-r*p/h;

end

theta_flap =zeros(1,length(th2));
displacement = zeros(1,length(th2));
% Mechanical adavantage 
ma = zeros(1, length(th2));

for i=1:length(th2)
    %instantaneous mechanical advantage
    ma(i) = atan((dy-cy(i))/(dx-cx(i)));
    theta_flap(i) = atan((dx-cx(i))/(cy(i)-dy));
    displacement(i) = -cy(i);
    plot([-0,-by(i)],[0,bx(i)]);
    hold on;
    plot([-by(i),-cy(i)],[bx(i),cx(i)]);
    hold on;
    plot(-by(1:i),bx(1:i),'g.');
    hold on;
    plot([-cy(i),-dy],[cx(i),dx]);
    hold on;
    plot([-dy,-gy(i)],[dx,gx(i)]);
    hold on;
    %plot((cx(1:i)+dx)/2,(cy(1:i)+dy)/2,'c-');
    plot([cy(i)-2*l4,dy-2*l4],[cx(i),dx]);
    hold on;
    plot([dy-2*l4,gy(i)-2*l4],[dx,gx(i)]);
    hold on;
    plot(-gy(1:i),gx(1:i),'c-');
    hold on;
    axis([-20,12,-12,20]);
    drawnow;
    hold off;
end

%average mechanical advantage
MA = sum(abs(ma))/sum(abs(th2))