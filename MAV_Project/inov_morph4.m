clc,clearvars;

%4 bar for flap
L1=7;
L2=2;
L3=6;
L4=4;
L5=15;

%4 bar for morph
l1=7.5;
l2=2;
l3=6;
l4=4;
l41=0.5*l4;
l42=l41;
l5=6;
l6=6;
l7=1.5;
l8=8;

%for flap
th2=0:0.1:2*pi;
TH3=zeros(1,length(th2));
TH4=zeros(1,length(th2));
BD=(L1^2+L2^2-2*L1*L2*cos(th2)).^0.5;
GAMA=acos((L3^2+L4^2-BD.^2)/(2*L3*L4));

%for morph
th3=zeros(1,length(th2));
th4=zeros(1,length(th2));
bd=(l1^2+l2^2-2*l1*l2*cos(th2)).^0.5;
gama=acos((l3^2+l4^2-bd.^2)/(2*l3*l4));

% capital ones for flap and small ones for morph
for i=1:length(th2)
    TH3(i)=2*atan((-L2*sin(th2(i))+L4*sin(GAMA(i)))/(L1+L3-L2*cos(th2(i))-L4*cos(GAMA(i))));
    TH4(i)=2*atan((L2*sin(th2(i))-L3*sin(GAMA(i)))/(L4-L1-L2*cos(th2(i))-L3*cos(GAMA(i))));
    th3(i)=2*atan((-l2*sin(th2(i))+l4*sin(gama(i)))/(l1+l3-l2*cos(th2(i))-l4*cos(gama(i))));
    th4(i)=2*atan((l2*sin(th2(i))-l3*sin(gama(i)))/(l4-l1-l2*cos(th2(i))-l3*cos(gama(i))));
end

%coordinates for flap

BX=L2*cos(th2);
BY=L2*sin(th2);

CX=L2*cos(th2)+L3*cos(TH3);
CY=L2*sin(th2)+L3*sin(TH3);

DX=L1;
DY=0;

for i=1:length(th2)
    P=abs(DY-CY(i));
    B=abs(DX-CX(i));
    H=(P^2+B^2)^0.5;
    SLOPE=P/B;
    R=L5;
    GX(i)=CX(i)+R*B/H;
    GY(i)=CY(i)-R*P/H;

end

%coordinates for morph

bx=l2*cos(th2);
by=l2*sin(th2);

cx=l2*cos(th2)+l3*cos(th3);
cy=l2*sin(th2)+l3*sin(th3);

dx=l1;
dy=0;

%ratios for point e m=l41, n=l42
m=l41;
n=l42;
ex=(m*dx+n*cx)/(m+n);
ey=(m*dy+n*cy)/(m+n);

%ratios for point g m=l3+l5, n=l5
m=l3+l5;
n=l5;
gx=(m*cx-n*bx)/(m-n);
gy=(m*cy-n*by)/(m-n);

%fnding point f
for i=1:length(th2)
    c=((ex(i)-gx(i))^2+(ey(i)-gy(i))^2)^0.5;
    a=l6;
    b=l7;
    C=(a^2+c^2-b^2)/(2*a*c);
    S=(1-C^2)^0.5;
    fx(i)=ex(i)+a/c*(gx(i)-ex(i))*C+a/c*(gy(i)-ey(i))*S;
    fy(i)=ey(i)+a/c*(gy(i)-ey(i))*C-a/c*(gx(i)-ex(i))*S;
end

%for point h
m=l7+l8;
n=l8;
hx=(m*gx-n*fx)/(m-n);
hy=(m*gy-n*fy)/(m-n);

%transforming coordinates according to flap for z direction deviations or
%displacements to be included in the mechanism

dc = [-dy-l2, dx, 0];

for i=1:length(th2)
    R = [cos(th2(i)) 0 sin(th2(i)); 0 1 0; -sin(th2(i)) 0 cos(th2(i))];
    bc(i,:) = R*([-by(i)-l2; bx(i); 0]);
    cc(i,:) = R*([-cy(i)-l2; cx(i); 0]);
    ec(i,:) = R*([-ey(i)-l2; ex(i); 0]);
    fc(i,:) = R*([-fy(i)-l2; fx(i); 0]);
    gc(i,:) = R*([-gy(i)-l2; gx(i); 0]);
    hc(i,:) = R*([-hy(i)-l2; hx(i); 0]);
end

for i=1:length(th2)
    %plot for flap
    plot3([-0,-BY(i)]+l4,[l1,l1],[0,BX(i)]-L1);
    hold on;
    plot3([-BY(i),-CY(i)]+l4,[l1,l1],[BX(i),CX(i)]-L1);
    hold on;
    plot3([-CY(i),-DY]+l4,[l1,l1],[CX(i),DX]-L1);
    hold on;
    plot3([-DY,-GY(i)]+l4,[l1,l1],[DX,GX(i)]-L1);
    hold on;
    %plot((CX(1:i)+DX)/2,(CY(1:i)+DY)/2,'c-');
    plot3([CY(i)-2*L4,DY-2*L4]+l4,[l1,l1],[CX(i),DX]-L1);
    hold on;
    plot3([DY-2*L4,GY(i)-2*L4]+l4,[l1,l1],[DX,GX(i)]-L1);
    hold on;

    %plot for morph
    %for 1 side of the wing
    %{
    plot(-[0,by(i)],[0,bx(i)]);
    hold on;
    plot(-[by(i),cy(i)],[bx(i),cx(i)]);
    hold on;
    plot(-[cy(i),dy],[cx(i),dx]);
    hold on;
    plot(-[cy(i),gy(i)],[cx(i),gx(i)]);
    hold on;
    plot(-[fy(i),gy(i)],[fx(i),gx(i)]);
    hold on;
    plot(-[fy(i),ey(i)],[fx(i),ex(i)]);
    hold on;
    plot(-[gy(i),hy(i)],[gx(i),hx(i)]);
    hold on;
    %plot((cx(1:i)+dx)/2,(cy(1:i)+dy)/2,'c--');
    %for 2nd side of the wing
    plot([0,by(i)]+2*l2,[0,bx(i)]);
    hold on;
    plot([by(i),cy(i)]+2*l2,[bx(i),cx(i)]);
    hold on;
    plot([cy(i),dy]+2*l2,[cx(i),dx]);
    hold on;
    plot([cy(i),gy(i)]+2*l2,[cx(i),gx(i)]);
    hold on;
    plot([fy(i),gy(i)]+2*l2,[fx(i),gx(i)]);
    hold on;
    plot([fy(i),ey(i)]+2*l2,[fx(i),ex(i)]);
    hold on;
    plot([gy(i),hy(i)]+2*l2,[gx(i),hx(i)]);
    hold on;
    %}
    

    
    plot3([0,bc(i,1)],[0,bc(i,2)],[0,bc(i,3)]);
    hold on;
    plot3([bc(i,1),cc(i,1)],[bc(i,2),cc(i,2)],[bc(i,3),cc(i,3)]);
    hold on;
    plot([cy(i),dy],[cx(i),dx]);
    hold on;
    plot([cy(i),gy(i)],[cx(i),gx(i)]);
    hold on;
    plot([fy(i),gy(i)],[fx(i),gx(i)]);
    hold on;
    plot([fy(i),ey(i)],[fx(i),ex(i)]);
    hold on;
    plot([gy(i),hy(i)],[gx(i),hx(i)]);
    hold on;
    %plot((cx(1:i)+dx)/2,(cy(1:i)+dy)/2,'c--');
    %for 2nd side of the wing
    plot([0,by(i)]+l2,[0,bx(i)]);
    hold on;
    plot([by(i),cy(i)]+l2,[bx(i),cx(i)]);
    hold on;
    plot([cy(i),dy]+l2,[cx(i),dx]);
    hold on;
    plot([cy(i),gy(i)]+l2,[cx(i),gx(i)]);
    hold on;
    plot([fy(i),gy(i)]+l2,[fx(i),gx(i)]);
    hold on;
    plot([fy(i),ey(i)]+l2,[fx(i),ex(i)]);
    hold on;
    plot([gy(i),hy(i)]+l2,[gx(i),hx(i)]);
    hold on;
    
    set(groot, 'DefaultLineLineWidth', 2);
    axis([-16,20,-5,31,-10,26]);
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
