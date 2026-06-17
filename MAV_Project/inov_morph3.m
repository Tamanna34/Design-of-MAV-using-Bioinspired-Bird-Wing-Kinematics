%with this code, we want to change the dimesions of the links of this
%mechanism where some of the parameters are optimised and we get maximum
%flap and highest velocity at the end links too

clc,clearvars;

%4 bar
l1=7;
l2=2;
l31=4.5;
l32=1.5;
l3=6;
l4=3;
l5=6;
l6=3.5;%this was earlier 4 and it can run at 3 too a/c grashof but we want to reduce it below 3 somehow
l7=8;

th2=0:0.1:6*pi;
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

ex=(l31*cx+l32*bx)/(l31+l32);
ey=(l31*cy+l32*by)/(l31+l32);

%ratios for f m=l4+l5, n=l5
m=l4+l5;
n=l5;
fx=(m*dx-n*cx)/(m-n);
fy=(m*dy-n*cy)/(m-n);

%solve for gx and gy using the concept of
%point at a distance on a line
for i=1:length(th2)
    p=abs(dy-cy(i));
    b=abs(dx-cx(i));
    h=(p.^2+b.^2).^0.5;
    slope=p/b;

    r=l4+l5+l6;
    gx(i)=ex(i)+r*b/h;
    gy(i)=ey(i)-r*p/h;
end

%solve for hx and hy using the concept of
%point at a distance on a line
for i=1:length(th2)
    p=abs(fy(i)-gy(i));
    b=(fx(i)-gx(i));
    h=(p.^2+b.^2).^0.5;
    slope=p/b;

    r=l7;
    hx(i)=fx(i)-r*b/h;
    hy(i)=fy(i)-r*p/h;
end

for i=1:length(th2)
    %for 1 side of the wing
    plot3([0,bx(i)],[0,0],[0,by(i)]);
    hold on;
    plot3([bx(i),cx(i)],[0,0],[by(i),cy(i)]);
    hold on;
    plot3([cx(i),dx],[0,0],[cy(i),dy]);
    hold on;
    plot3([dx,fx(i)],[0,0],[dy,fy(i)]);
    hold on;
    plot3([ex(i),gx(i)],[0,0],[ey(i),gy(i)]);
    hold on;
    plot3([fx(i),hx(i)],[0,0],[fy(i),hy(i)]);
    hold on;
    %plot((cx(1:i)+dx)/2,(cy(1:i)+dy)/2,'c--');
    %other side of the wing
    plot3([0-2*l2,-bx(i)-2*l2],[0,0],[0,by(i)]);
    hold on;
    plot3([-bx(i)-2*l2,-cx(i)-2*l2],[0,0],[by(i),cy(i)]);
    hold on;
    plot3([-cx(i)-2*l2,-dx-2*l2],[0,0],[cy(i),dy]);
    hold on;
    plot3([-dx-2*l2,-fx(i)-2*l2],[0,0],[dy,fy(i)]);
    hold on;
    plot3([-ex(i)-2*l2,-gx(i)-2*l2],[0,0],[ey(i),gy(i)]);
    hold on;
    plot3([-fx(i)-2*l2,-hx(i)-2*l2],[0,0],[fy(i),hy(i)]);
    hold on;
    % Axis and Labels
    axis([-25, 17, -26, 26, -15, 10]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z'); 
    grid on;
    drawnow;
    hold off;
    
end

view(3);  % Set view to 3D
axis equal;  % Equal scaling for all axes

whos



