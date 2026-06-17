tic

clc;
clearvars;
close all;
l22 = 0 : 0.1: 100; % Range of l2
l11 = 17:0.1:18.5;                                                          % Range of l1
global_max_score = 0; % Initialize global max score
best_params = struct('l1', 0, 'l2', 0, 'wingspan', 0, 'fold', inf); % Track best parameters
global_fold_min = inf; % Initialize the global minimum fold
global_ws_max = 0; % Initialize the global maximum wingspan
global_fold_max = 0;
global_ws_min=inf;
for i = 1:length(l11)
    for j = 1:length(l22)
        l1=l11(i);                                                                                                                                                                                                                                                                                                                                                             
        l2=l22(j);
        l3=7;
        l4=32;
        l41=12;
        
        l42=l4-l41;
        l5=31;
        l6=27;
        l7=8;
        l8=27;
        
        lengths = 7.5/17*[l1,l2,l3,l4,l5,l6,l7,l8];
        l1 = lengths(1);
        l2 = lengths(2);
        l3 = lengths(3);
        l4 = lengths(4);
        l5 = lengths(5);
        l6 = lengths(6);
        l7 = lengths(7);
        l8 = lengths(8);

        if (max([l1, l2, l3, l4]) + min([l1, l2, l3, l4]) < ...
            (l1 + l2 + l3 + l4 - max([l1, l2, l3, l4]) - min([l1, l2, l3, l4])))
            th2 = 0.5*pi:0.05:pi; % Theta range
            th3 = zeros(1, length(th2));
            th4 = zeros(1, length(th2));
            bd = sqrt(l1^2 + l2^2 - 2 * l1 * l2 .* cos(th2));
            gama = acos((l3^2 + l4^2 - bd.^2) / (2 * l3 * l4));
            if ~isreal(bd) || ~isreal(gama)
                continue;
            end
            for k = 1:length(th2)
                th3_temp(k) = 2 * atan((-l2 * sin(th2(k)) + l4 * sin(gama(k))) / ...
                    (l1 + l3 - l2 * cos(th2(k)) - l4 * cos(gama(k))));
                th4_temp(k) = 2 * atan((l2 * sin(th2(k)) - l3 * sin(gama(k))) / ...
                    (l4 - l1 - l2 * cos(th2(k)) - l3 * cos(gama(k))));
            end
            if ~isreal(th3_temp) || ~isreal(th4_temp)
                    continue;
            end
            th3 = th3_temp;
            th4 = th4_temp;
            % Coordinates
            bx = l2 * cos(th2);
            by = l2 * sin(th2);
            cx = l2 * cos(th2) + l3 * cos(th3);
            cy = l2 * sin(th2) + l3 * sin(th3);
            dx = l1;
            dy = 0;
            m = l41;
            n = l42;
            ex = (m * dx + n * cx) / (m + n);
            ey = (m * dy + n * cy) / (m + n);
            m = l3 + l5;
            n = l5;
            gx = (m * cx - n * bx) / (m - n);
            gy = (m * cy - n * by) / (m - n);
            fx = zeros(1, length(th2));
            fy = zeros(1, length(th2));
            wingspan = 0;
            for k = 1:length(th2)
                c = sqrt((ex(k) - gx(k))^2 + (ey(k) - gy(k))^2);
                a = l6;
                b = l7;
                C = (a^2 + c^2 - b^2) / (2 * a * c);
                S = sqrt(1 - C^2);
                if ~isreal(C) || ~isreal(S)
                    continue;
                end
                fx(k) = ex(k) + a / c * (gx(k) - ex(k)) * C + a / c * (gy(k) - ey(k)) * S;
                fy(k) = ey(k) + a / c * (gy(k) - ey(k)) * C - a / c * (gx(k) - ex(k)) * S;
            end
            m = l7 + l8;
            n = l8;
            hx = (m * gx - n * fx) / (m - n);
            hy = (m * gy - n * fy) / (m - n);
            if ~isreal(hx) || ~isreal(hy)
                continue;
            end
            for k = 1:length(th2)
                %determine wingspan
                wingspan = max(wingspan,abs(hy(k)));
                fold = hy(k);
                global_fold_min = min(global_fold_min, fold);
                global_ws_max = max(global_ws_max, wingspan);
                global_fold_max = max(global_fold_max, fold);
                global_ws_min=min(global_ws_min,wingspan);
            end
        end
    end
end

for i = 1:length(l11)
    for j = 1:length(l22)
        l1=l11(i);
        l2=l22(j);
        l3=7;
        l4=32;
        l41=12;
        
        l42=l4-l41;
        l5=31;
        l6=27;
        l7=8;
        l8=27;
        
        lengths = 7.5/17*[l1,l2,l3,l4,l5,l6,l7,l8];
        l1 = lengths(1);
        l2 = lengths(2);
        l3 = lengths(3);
        l4 = lengths(4);
        l5 = lengths(5);
        l6 = lengths(6);
        l7 = lengths(7);
        l8 = lengths(8);
        if (max([l1, l2, l3, l4]) + min([l1, l2, l3, l4]) < ...
            (l1 + l2 + l3 + l4 - max([l1, l2, l3, l4]) - min([l1, l2, l3, l4])))
            th2 = 0.5*pi:0.05:pi; % Theta range
            th3 = zeros(1, length(th2));
            th4 = zeros(1, length(th2));
            bd = sqrt(l1^2 + l2^2 - 2 * l1 * l2 .* cos(th2));
            gama = acos((l3^2 + l4^2 - bd.^2) / (2 * l3 * l4));
            if ~isreal(bd) || ~isreal(gama)
                continue;
            end
            for k = 1:length(th2)
                th3_temp = 2 * atan((-l2 * sin(th2(k)) + l4 * sin(gama(k))) / ...
                    (l1 + l3 - l2 * cos(th2(k)) - l4 * cos(gama(k))));
                th4_temp = 2 * atan((l2 * sin(th2(k)) - l3 * sin(gama(k))) / ...
                    (l4 - l1 - l2 * cos(th2(k)) - l3 * cos(gama(k))));
                if ~isreal(th3_temp) || ~isreal(th4_temp)
                    continue;
                end
                th3(k) = th3_temp;
                th4(k) = th4_temp;
            end
            bx = l2 * cos(th2);
            by = l2 * sin(th2);
            cx = l2 * cos(th2) + l3 * cos(th3);
            cy = l2 * sin(th2) + l3 * sin(th3);
            dx = l1;
            dy = 0;
            m = l41;
            n = l42;
            ex = (m * dx + n * cx) / (m + n);
            ey = (m * dy + n * cy) / (m + n);
            m = l3 + l5;
            n = l5;
            gx = (m * cx - n * bx) / (m - n);
            gy = (m * cy - n * by) / (m - n);
            fx = zeros(1, length(th2));
            fy = zeros(1, length(th2));
            for k = 1:length(th2)
                c = sqrt((ex(k) - gx(k))^2 + (ey(k) - gy(k))^2);
                a = l6;
                b = l7;
                C = (a^2 + c^2 - b^2) / (2 * a * c);
                S = sqrt(1 - C^2);
                if ~isreal(C) || ~isreal(S)
                    continue;
                end
                fx(k) = ex(k) + a / c * (gx(k) - ex(k)) * C + a / c * (gy(k) - ey(k)) * S;
                fy(k) = ey(k) + a / c * (gy(k) - ey(k)) * C - a / c * (gx(k) - ex(k)) * S;
            end
            m = l7 + l8;
            n = l8;
            hx = (m * gx - n * fx) / (m - n);
            hy = (m * gy - n * fy) / (m - n);
            if ~isreal(hx) || ~isreal(hy)
                continue;
            end
            max_score = 0;
            sfw = zeros(length(th2), 3); % Store score, wingspan, and fold
            for k = 1:length(th2)
                %determine wingspan
                wingspan = max(wingspan,abs(hy(k)));
                fold = hy(k);
                score = 0.3 * ((wingspan-global_ws_min) / (global_ws_max-global_ws_min)) + 0.7 * (1-((fold-global_fold_min) /(global_fold_max - global_fold_min)));
                sfw(k, :) = [score, wingspan, fold];
                if score > max_score
                    max_score = score;
                end
            end
            for k = 1:length(th2)
                score = sfw(k, 1);
                wingspan = sfw(k, 2);
                fold = sfw(k, 3);
                if (score > global_max_score && fold>=3) || (score == global_max_score && fold < best_params.fold && fold > 4)
                    global_max_score = score;
                    best_params.l1 = l1;
                    best_params.l2 = l2;
                    best_params.wingspan = wingspan;
                    best_params.fold = fold;
                end
            end
        end
    end
    disp(i);
end

disp('Global Best Parameters:');
disp(best_params);
disp(['Max Score: ', num2str(global_max_score)]);

toc

%{
l22 = 16 : 0.1: 25 ; % Range of l2
l11 = 15 :0.1:25; % Range of l1
th2 = 0.65*pi:0.05:pi; % Theta range
Global Best Parameters:
          l1: 8.8235
          l2: 8.3824
    wingspan: 30.4248
        fold: 3.0181

Max Score: 0.96334
Elapsed time is 0.156961 seconds.


l22 = 0 : 0.1: 100; % Range of l2
l11 = 17:0.1:18.5; 
Global Best Parameters:
          l1: 8.0735
          l2: 9.1324
    wingspan: 30.4424
        fold: 3.0676

Max Score: 39.7525
Elapsed time is 0.206946 seconds.

%}

