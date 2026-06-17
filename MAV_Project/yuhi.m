%this isimportant regarding 1st week presentation

%this is the bat wing folding mechanism
%paper: Design and analysis of a bat-like active morphing wing mechanism

clc,clearvars,close all;

%4 bar
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

th2=0:0.05:0.5*pi;
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

%variable for wingspan
wingspan = 0;


for i=1:length(th2)

    %plot for winng stretch
    %horizontal
    plot(-[0,dy],[0-15,dx+15],'r.--');
    hold on;
    plot(-[hy(i),hy(i)],[hx(i)-10,hx(i)+10],'b--')
    hold on;

    %plot for wingspan area

    %shading and highlighting verices
    x = -[0; by(i); hy(i); fy(i); dy];
    y = [0; bx(i); hx(i); fx(i); dx];
    scatter(x, y, 20, 'red', 'filled'); % Highlight vertices
    fill(x, y, 'cyan', 'FaceAlpha', 0.5, 'EdgeColor', 'blue', 'LineWidth', 1.5);
    hold on;

    %determine wingspan
    area = polyarea(x, y);
    wingspan = max(wingspan,area);
    wing_area(i) = area;

    %for 1 side of the wing
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
    axis([-18,20,-15,23]);
    drawnow;
    hold off;
end

whos