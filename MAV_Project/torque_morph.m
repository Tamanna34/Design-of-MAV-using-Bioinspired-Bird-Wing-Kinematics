%this isimportant regarding 1st week presentation

%this is the bat wing folding mechanism
%paper: Design and analysis of a bat-like active morphing wing mechanism

clc,clearvars,close all;

%4 bar
l1=17;
l2=21;
l3=7;
l4=32;
l41=12;

l42=l4-l41;
l5=31;
l6=27;
l7=8;
l8=27;

lengths = 7.5/17*[l1,l2,l3,l4,l5,l6,l7,l8];
l1 = 8;
l2 = 9.2;
l3 = lengths(3);
l4 = lengths(4);
l5 = lengths(5);
l6 = lengths(6);
l7 = lengths(7);
l8 = lengths(8);

th2=0.65*pi:0.01:1*pi;
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
wing_area = zeros(1,length(th2));

% Abstract coordinate renaming
Bx = -by;
By = bx;

Cx = -cy;
Cy = cx;

Dx = -dy;
Dy = dx;

Gx = -gy;
Gy = gx;

Ex = -ey;
Ey = ex;

Fx = -fy;
Fy = fx;

Hx = -hy;
Hy = hx;

% Store centroids
centroid_x = zeros(1,length(th2));
centroid_y = zeros(1,length(th2));

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

    % Area centroid
    A = polyarea(x, y);
    Cxx = (1/(6*A)) * sum((x + circshift(x, -1)) .* ...
                         (x .* circshift(y, -1) - circshift(x, -1) .* y));
    Cyy = (1/(6*A)) * sum((y + circshift(y, -1)) .* ...
                         (x .* circshift(y, -1) - circshift(x, -1) .* y));
    
    centroid_x(i) = Cxx;
    centroid_y(i) = Cyy;

    % Optional: plot centroid
    scatter(Cx, Cy, 5, 'k', 'filled');hold on;

    %determine wingspan
    wingspan = max(wingspan,abs(hy(i)));
    wing_area(i) = A;

    %for 1 side of the wing
    % Re-mapped coordinates (side 1)
    plot([0, Bx(i)], [0, By(i)]); hold on;
    plot([Bx(i), Cx(i)], [By(i), Cy(i)]); hold on;
    plot([Cx(i), Dx], [Cy(i), Dy]); hold on;
    plot([Cx(i), Gx(i)], [Cy(i), Gy(i)]); hold on;
    plot([Fx(i), Gx(i)], [Fy(i), Gy(i)]); hold on;
    plot([Fx(i), Ex(i)], [Fy(i), Ey(i)]); hold on;
    plot([Gx(i), Hx(i)], [Gy(i), Hy(i)]); hold on;
    %plot((cx(1:i)+dx)/2,(cy(1:i)+dy)/2,'c--');
    %for 2nd side of the wing
    % Re-mapped coordinates (side 2 - mirrored)
    plot([0, -Bx(i)] + 2*l2, [0, By(i)]); hold on;
    plot([-Bx(i), -Cx(i)] + 2*l2, [By(i), Cy(i)]); hold on;
    plot([-Cx(i), -Dx] + 2*l2, [Cy(i), Dy]); hold on;
    plot([-Cx(i), -Gx(i)] + 2*l2, [Cy(i), Gy(i)]); hold on;
    plot([-Fx(i), -Gx(i)] + 2*l2, [Fy(i), Gy(i)]); hold on;
    plot([-Fx(i), -Ex(i)] + 2*l2, [Fy(i), Ey(i)]); hold on;
    plot([-Gx(i), -Hx(i)] + 2*l2, [Gy(i), Hy(i)]); hold on;
    axis([-40,60,-50,50]);
    drawnow;
    hold off;
end

%normal speed of the guillemot
u = 5/18*80; %80 kmph

%properties of air at ~298K
rho = 1.18; %kg/m^3
mu = 1.86e-5; %Pa.s

%drag force 
Df = zeros(1,length(th2));
T = zeros(1,length(th2));

for i=2:length(th2)

    %distance fron leading edge
    Yc = [0, By(i) , Cy(i), Dy, Fy(i), Ey(i), Gy(i), Hy(i)];
    X = abs(max(Yc)-min(Yc));
    
    % reynolds number
    Re = rho*u*X/mu;
    
    %skin coefficient of friction
    if Re < 5e5
        Cf = 1.328/sqrt(Re);
    else
        Cf = 0.074/(Re^0.2);
    end
    
    %drag force in each orientation
    Df(i) = Cf*wing_area(i)*1e-4*rho*u^2/2;
    
    %torque required
    T(i) = Df(i)*(Cy(i)-Cy(i-1))/(th2(i)-th2(i-1));

end

whos