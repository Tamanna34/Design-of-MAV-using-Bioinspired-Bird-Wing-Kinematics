%this is the mechanism shown in presentation 2

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
th2=0:0.1:1.5*pi;
th2 = [th2, 1.5*pi:-0.1:0];

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
for i=1:length(th2) 
    angle_DC(i) = atan(-(DX-CX(i))/(DY-CY(i)));
end
for i=1:length(th2)
    R = [cos(angle_DC(i)) 0 sin(angle_DC(i)); 0 1 0; -sin(angle_DC(i)) 0 cos(angle_DC(i))];
    ac(i,:) = R*([0-l2;0 ;0]);
    bc(i,:) = R*([-by(i)-l2; bx(i); 0]);
    cc(i,:) = R*([-cy(i)-l2; cx(i); 0]);
    dc(i,:) = R*[-dy-l2; dx; 0];
    ec(i,:) = R*([-ey(i)-l2; ex(i); 0]);
    fc(i,:) = R*([-fy(i)-l2; fx(i); 0]);
    gc(i,:) = R*([-gy(i)-l2; gx(i); 0]);
    hc(i,:) = R*([-hy(i)-l2; hx(i); 0]);
    R = [cos(angle_DC(i)) 0 -sin(angle_DC(i)); 0 1 0; sin(angle_DC(i)) 0 cos(angle_DC(i))];
    acs(i,:) = R*([0+l2;0 ;0]);
    bcs(i,:) = R*([by(i)+l2; bx(i); 0]);
    ccs(i,:) = R*([cy(i)+l2; cx(i); 0]);
    dcs(i,:) = R*([dy+l2; dx; 0]);
    ecs(i,:) = R*([ey(i)+l2; ex(i); 0]);
    fcs(i,:) = R*([fy(i)+l2; fx(i); 0]);
    gcs(i,:) = R*([gy(i)+l2; gx(i); 0]);
    hcs(i,:) = R*([hy(i)+l2; hx(i); 0]);
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

    % xshift = x_s, zshift = ac(i,3)
    x_s = DY - l4 - ac(i,1);

    %{
    %plot for wingspan area
    %shading and highlighting verices
    x = [ac(i,1),bc(i,1),hc(i,1),fc(i,1),dc(i,1)]+x_s;
    y = [ac(i,2),bc(i,2),hc(i,2),fc(i,2),dc(i,2)];
    z = [ac(i,3),bc(i,3),hc(i,3),fc(i,3),dc(i,3)]-ac(i,3);
    scatter3(x, y, z, 20, 'red', 'filled'); % Highlight vertices
    fill3(x, y, z, 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'blue', 'LineWidth', 1.5);
    hold on;
    
    %shading and highlighting verices
    x = [acs(i,1),bcs(i,1),hcs(i,1),fcs(i,1),dcs(i,1)]-x_s;
    y = [acs(i,2),bcs(i,2),hcs(i,2),fcs(i,2),dcs(i,2)];
    z = [acs(i,3),bcs(i,3),hcs(i,3),fcs(i,3),dcs(i,3)]-ac(i,3);
    scatter3(x, y, z, 20, 'red', 'filled'); % Highlight vertices
    fill3(x, y, z, 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'blue', 'LineWidth', 1.5);
    hold on;
    
    %}

    %plot for wingspan area

    % %shading and highlighting verices
    % x = [ac(i,1); bc(i,1); hc(i,1); fc(i,1); ec(i,1); dc(i,1)] + x_s;
    % y = [ac(i,2); bc(i,2); hc(i,2); fc(i,2); ec(i,2); dc(i,2)];
    % z = [ac(i,3); bc(i,3); hc(i,3); fc(i,3); ec(i,3); dc(i,3)] - ac(i,3);
    % scatter3(x, y, z, 20, 'red', 'filled'); % Highlight vertices
    % fill3(x, y, z, 'cyan', 'FaceAlpha', 0.5, 'EdgeColor', 'blue', 'LineWidth', 3);
    % hold on;

    plot3([ac(i,1),bc(i,1)]+x_s,[ac(i,2),bc(i,2)],[ac(i,3),bc(i,3)]-ac(i,3));
    hold on;
    plot3([bc(i,1),cc(i,1)]+x_s,[bc(i,2),cc(i,2)],[bc(i,3),cc(i,3)]-ac(i,3));
    hold on;
    plot3([cc(i,1),dc(i,1)]+x_s,[cc(i,2),dc(i,2)],[cc(i,3),dc(i,3)]-ac(i,3));
    hold on;
    plot3([cc(i,1),gc(i,1)]+x_s,[cc(i,2),gc(i,2)],[cc(i,3),gc(i,3)]-ac(i,3));
    hold on;
    plot3([fc(i,1),gc(i,1)]+x_s,[fc(i,2),gc(i,2)],[fc(i,3),gc(i,3)]-ac(i,3));
    hold on;
    plot3([fc(i,1),ec(i,1)]+x_s,[fc(i,2),ec(i,2)],[fc(i,3),ec(i,3)]-ac(i,3));
    hold on;
    plot3([gc(i,1),hc(i,1)]+x_s,[gc(i,2),hc(i,2)],[gc(i,3),hc(i,3)]-ac(i,3));
    hold on;
    %plot((cx(1:i)+dx)/2,(cy(1:i)+dy)/2,'c--');

    % %shading and highlighting verices
    % x = [acs(i,1); bcs(i,1); hcs(i,1); fcs(i,1); ecs(i,1); dcs(i,1)] - x_s;
    % y = [acs(i,2); bcs(i,2); hcs(i,2); fcs(i,2); ecs(i,2); dcs(i,2)];
    % z = [acs(i,3); bcs(i,3); hcs(i,3); fcs(i,3); ecs(i,3); dcs(i,3)] - ac(i,3);
    % scatter3(x, y, z, 20, 'red', 'filled'); % Highlight vertices
    % fill3(x, y, z, 'cyan', 'FaceAlpha', 0.5, 'EdgeColor', 'blue', 'LineWidth', 3);
    % hold on;

    %for 2nd side of the wing
    plot3([acs(i,1),bcs(i,1)]-x_s,[acs(i,2),bcs(i,2)],[acs(i,3),bcs(i,3)]-ac(i,3));
    hold on;
    plot3([bcs(i,1),ccs(i,1)]-x_s,[bcs(i,2),ccs(i,2)],[bcs(i,3),ccs(i,3)]-ac(i,3));
    hold on;
    plot3([ccs(i,1),dcs(i,1)]-x_s,[ccs(i,2),dcs(i,2)],[ccs(i,3),dcs(i,3)]-ac(i,3));
    hold on;
    plot3([ccs(i,1),gcs(i,1)]-x_s,[ccs(i,2),gcs(i,2)],[ccs(i,3),gcs(i,3)]-ac(i,3));
    hold on;
    plot3([fcs(i,1),gcs(i,1)]-x_s,[fcs(i,2),gcs(i,2)],[fcs(i,3),gcs(i,3)]-ac(i,3));
    hold on;
    plot3([fcs(i,1),ecs(i,1)]-x_s,[fcs(i,2),ecs(i,2)],[fcs(i,3),ecs(i,3)]-ac(i,3));
    hold on;
    plot3([gcs(i,1),hcs(i,1)]-x_s,[gcs(i,2),hcs(i,2)],[gcs(i,3),hcs(i,3)]-ac(i,3));
    hold on;
    
    set(groot, 'DefaultLineLineWidth', 2);
    %axis([-16,20,-5,31,-10,26]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z'); 
    %view(180, 0); %to view the anlge of plane of wings in both morph and
    %flap
    %view(225,45);
    %view(3);
    %view(-55.939988452864107,44.813367609254513);
    view(-1.456686747069112e+02,31.587146529563);
    %view(-90,90);
    %view(-180,0);
    %view(-90,0);
    
    axis([-20,20,-20,20,-10,30]);
    grid on;
    drawnow;
    hold off;
end
%view(3);  % Set view to 3D
axis equal;  % Equal scaling for all axes
whos