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
th2=0:0.05:2*pi;
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
%_____________________________________________________________________
%4 bar
lf1=7;
lf2=2;
lf31=4.5;
lf32=1.5;
lf3=6;
lf4=4;
lf5=6;
lf6=3;
lf7=8;
TH2=0:0.05:2*pi;
TH3=zeros(1,length(TH2));
TH4=zeros(1,length(TH2));
bar_distance=(lf1^2+lf2^2-2*lf1*lf2*cos(TH2)).^0.5;
GAMMA=acos((lf3^2+lf4^2-bar_distance.^2)/(2*lf3*lf4));
for i=1:length(TH2)
    TH3(i)=2*atan((-lf2*sin(TH2(i))+lf4*sin(GAMMA(i)))/(lf1+lf3-lf2*cos(TH2(i))-lf4*cos(GAMMA(i))));
    TH4(i)=2*atan((lf2*sin(TH2(i))-lf3*sin(GAMMA(i)))/(lf4-lf1-lf2*cos(TH2(i))-lf3*cos(GAMMA(i))));
end
px=lf2*cos(TH2);
py=lf2*sin(TH2);
qx=lf2*cos(TH2)+lf3*cos(TH3);
qy=lf2*sin(TH2)+lf3*sin(TH3);
rx=lf1;
ry=0;
sx=(lf31*qx+lf32*px)/(lf31+lf32);
sy=(lf31*qy+lf32*py)/(lf31+lf32);
%ratios for tf1 mf1=lf4+lf5, nf1=lf5
mf1=lf4+lf5;
nf1=lf5;
tf1x=(mf1*rx-nf1*qx)/(mf1-nf1);
tf1y=(mf1*ry-nf1*qy)/(mf1-nf1);
for i=1:length(TH2)
    p_dist=abs(ry-qy(i));
    b_dist=abs(rx-qx(i));
    hypotenuse=(p_dist.^2+b_dist.^2).^0.5;
    slope_val=p_dist/b_dist;
    r_length=lf4+lf5+lf6;
    ux(i)=sx(i)+r_length*b_dist/hypotenuse;
    uy(i)=sy(i)-r_length*p_dist/hypotenuse;
end
for i=1:length(TH2)
    p_dist=abs(tf1y(i)-uy(i));
    b_dist=(tf1x(i)-ux(i));
    hypotenuse=(p_dist.^2+b_dist.^2).^0.5;
    slope_val=p_dist/b_dist;
    r_length=lf7;
    vx(i)=tf1x(i)-r_length*b_dist/hypotenuse;
    vy(i)=tf1y(i)-r_length*p_dist/hypotenuse;
end
figure;
grid on;
axis equal;
for i = 1:length(TH2)
    cla; % Clear previous frame while keeping the figure open
    hold on, grid on; % Allow multiple plots in the same frame
    
    % Flapping Mechanism in XZ Plane
    plot3([0, px(i)],[7.5, 7.5], [0, py(i)]);
    plot3([px(i), qx(i)],[7.5, 7.5], [py(i), qy(i)]);
    plot3([qx(i), rx], [7.5, 7.5],[qy(i), ry]);
    plot3([rx, tf1x(i)],[7.5, 7.5], [ry, tf1y(i)]);
    plot3([sx(i), ux(i)], [7.5, 7.5],[sy(i), uy(i)]);
    plot3([tf1x(i), vx(i)],[7.5, 7.5], [tf1y(i), vy(i)]);
    % Flapping - Other Side
    plot3([-2*lf2, -px(i)-2*lf2],[7.5, 7.5], [0, py(i)]);
    plot3([-px(i)-2*lf2, -qx(i)-2*lf2],[7.5, 7.5], [py(i), qy(i)]);
    plot3([-qx(i)-2*lf2, -rx-2*lf2], [7.5, 7.5],[qy(i), ry]);
    plot3([-rx-2*lf2, -tf1x(i)-2*lf2],[7.5, 7.5], [ry, tf1y(i)]);
    plot3([-sx(i)-2*lf2, -ux(i)-2*lf2],[7.5, 7.5], [sy(i), uy(i)]);
    plot3([-tf1x(i)-2*lf2, -vx(i)-2*lf2],[7.5, 7.5], [tf1y(i), vy(i)]);
    %plot3([0-2*2.00173, -dy-2*2.00173], [-15, dx+15],[0, 0], 'g.--');
    %plot3([-hy(i)-2*2.00173, -hy(i)-2*2.00173], [hx(i)-10, hx(i)+10],[0, 0], 'g--');
    % Morphing - 2nd Side
    if(i>=1)
        d_theta = -(atan2(0 - qy(i), lf1 - qx(i)));%(atan2(0 - qy(i-1), lf1 - qx(i-1))
    end
   
    morph=[([0-2*2.00173+qx(i), by(i)-2*2.00173+qx(i)] + 2*l2),([by(i)-2*2.00173+qx(i), cy(i)-2*2.00173+qx(i)] + 2*l2),([cy(i)-2*2.00173+qx(i), dy-2*2.00173+qx(i)] + 2*l2),([cy(i)-2*2.00173+qx(i), gy(i)-2*2.00173+qx(i)] + 2*l2),[fy(i)-2*2.00173+qx(i), gy(i)-2*2.00173+qx(i)] + 2*l2,[fy(i)-2*2.00173+qx(i), ey(i)-2*2.00173+qx(i)] + 2*l2,[gy(i)-2*2.00173+qx(i), hy(i)-2*2.00173+qx(i)] + 2*l2;[0, bx(i)],[bx(i), cx(i)],[cx(i), dx],[cx(i), gx(i)],[fx(i), gx(i)],[fx(i), ex(i)],[gx(i), hx(i)];[qy(i),qy(i)],[qy(i),qy(i)],[qy(i),qy(i)],[qy(i),qy(i)],[qy(i),qy(i)],[qy(i),qy(i)],[qy(i),qy(i)]];
    
    %morph=[([0-2*2.00173, by(i)-2*2.00173] + 2*l2),([by(i)-2*2.00173, cy(i)-2*2.00173] + 2*l2),([cy(i)-2*2.00173, dy-2*2.00173] + 2*l2),([cy(i)-2*2.00173, gy(i)-2*2.00173] + 2*l2),[fy(i)-2*2.00173, gy(i)-2*2.00173] + 2*l2,[fy(i)-2*2.00173, ey(i)-2*2.00173] + 2*l2,[gy(i)-2*2.00173, hy(i)-2*2.00173] + 2*l2;[0, bx(i)],[bx(i), cx(i)],[cx(i), dx],[cx(i), gx(i)],[fx(i), gx(i)],[fx(i), ex(i)],[gx(i), hx(i)];[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]];
    morph=morph-[qx(i);0;qy(i)];

    inter = morph(1,:);
    morph(1,:)=(inter*cos(d_theta))+(morph(3,:)*sin(d_theta));
    morph(3,:)=(-inter*sin(d_theta))+(morph(3,:)*cos(d_theta));
    morph=morph+[qx(i);0;qy(i)];
    for l=1:(size(morph,2)-1)
        plot3(morph(1,l:l+1), morph(2,l:l+1),morph(3,l:l+1));
        %fill3(morph(1,:), morph(2,:),morph(3,:),'r', 'FaceAlpha', 1, 'EdgeColor', 'none')
        plot3(-morph(1,l:l+1)-2*lf2, morph(2,l:l+1),morph(3,l:l+1));
        %fill3(-morph(1,:)-2*lf2, morph(2,:),morph(3,:),'r', 'FaceAlpha', 1, 'EdgeColor', 'none')
    end
    axis([-25, 25, -10, 30, -20, 20]);
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    title('Flapping and Morphing Mechanism in 3D');
    view(180,0); % Set XZ view
    drawnow; % Update the plot
    
    hold off; 
end