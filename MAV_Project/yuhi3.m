clc;
clearvars;
close all;
l11 = 7 : 0.5: 12 ; % Range of l2
l66 = 3 :0.5:8; % Range of l1
global_max_score = 0; % Initialize global max score
best_params = struct('l1', 0, 'l6', 0, 'wingspan', 0, 'fold', inf); % Track best parameters
global_fold_min = inf; % Initialize the global minimum fold
global_ws_max = 0; % Initialize the global maximum wingspan
global_fold_max = 0;
global_ws_min=inf;
for i = 1:length(l11)
    for j = 1:length(l66)
        l3=6;
        l1=l11(i);
        l2 = 2 ;
        l4 = 4;
        l41 = 0.5 * l4;
        l42 = l4-l41;
        l5 = 6;
        l6 = l66(j);
        l7 = 1.5;
        l8 = 8;
        if (max([l1, l2, l3, l4]) + min([l1, l2, l3, l4]) < ...
            (l1 + l2 + l3 + l4 - max([l1, l2, l3, l4]) - min([l1, l2, l3, l4])))
            th2 = 0:0.05:pi; % Theta range
            th3 = zeros(1, length(th2));
            th4 = zeros(1, length(th2));
            bd = sqrt(l1^2 + l2^2 - 2 * l1 * l2 .* cos(th2));
            gama = acos((l3^2 + l4^2 - bd.^2) / (2 * l3 * l4));
            if ~isreal(bd) || ~isreal(gama)
                continue;
            end
            for k = 1:length(th2)
                th3(k) = 2 * atan((-l2 * sin(th2(k)) + l4 * sin(gama(k))) / ...
                    (l1 + l3 - l2 * cos(th2(k)) - l4 * cos(gama(k))));
                th4(k) = 2 * atan((l2 * sin(th2(k)) - l3 * sin(gama(k))) / ...
                    (l4 - l1 - l2 * cos(th2(k)) - l3 * cos(gama(k))));
            end
            th3_real = all(imag(th3) == 0); 
            th4_real = all(imag(th4) == 0);
            
            if ~th3_real || ~th4_real
                continue;
            end
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
            for k = 1:length(th2)
                c = sqrt((ex(k) - gx(k))^2 + (ey(k) - gy(k))^2);
                a = l6;
                b = l7;
                C(k) = (a^2 + c^2 - b^2) / (2 * a * c);
                S(k) = sqrt(1 - C(k)^2);
            end
            S_real = all(imag(S) == 0); 
            C_real = all(imag(C) == 0);
            
            if ~S_real || ~C_real
                continue;
            end
            for k = 1:length(th2)
                fx(k) = ex(k) + a / c * (gx(k) - ex(k)) * C(k) + a / c * (gy(k) - ey(k)) * S(k);
                fy(k) = ey(k) + a / c * (gy(k) - ey(k)) * C(k) - a / c * (gx(k) - ex(k)) * S(k);
            end
            m = l7 + l8;
            n = l8;
            hx = (m * gx - n * fx) / (m - n);
            hy = (m * gy - n * fy) / (m - n);
            if ~isreal(hx) || ~isreal(hy)
                continue;
            end
            for k = 1:length(th2)
                x = -[0; by(k); hy(k); fy(k); dy];
                y = [0; bx(k); hx(k); fx(k); dx];
                wingspan = polyarea(x, y);
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
    for j = 1:length(l66)
        l1 = l11(i);
        l3 = 6;
        l2 = 2;
        l4 = 4;
        l41 = 0.5 * l4;
        l42 = l41;
        l5 = 6;
        l6 = l66(j);
        l7 = 1.5;
        l8 = 8;
        if (max([l1, l2, l3, l4]) + min([l1, l2, l3, l4]) < ...
            (l1 + l2 + l3 + l4 - max([l1, l2, l3, l4]) - min([l1, l2, l3, l4])))
            th2 = 0:0.05:pi; % Theta range
            th3 = zeros(1, length(th2));
            th4 = zeros(1, length(th2));
            bd = sqrt(l1^2 + l2^2 - 2 * l1 * l2 .* cos(th2));
            gama = acos((l3^2 + l4^2 - bd.^2) / (2 * l3 * l4));
            if ~isreal(bd) || ~isreal(gama)
                continue;
            end
            for k = 1:length(th2)
                th3(k) = 2 * atan((-l2 * sin(th2(k)) + l4 * sin(gama(k))) / ...
                    (l1 + l3 - l2 * cos(th2(k)) - l4 * cos(gama(k))));
                th4(k) = 2 * atan((l2 * sin(th2(k)) - l3 * sin(gama(k))) / ...
                    (l4 - l1 - l2 * cos(th2(k)) - l3 * cos(gama(k))));
            end
            th3_real = all(imag(th3) == 0); 
            th4_real = all(imag(th4) == 0);
            
            if ~th3_real || ~th4_real
                continue;
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
                C(k) = (a^2 + c^2 - b^2) / (2 * a * c);
                S(k) = sqrt(1 - C(k)^2);
            end
            S_real = all(imag(S) == 0); 
            C_real = all(imag(C) == 0);
            
            if ~S_real || ~C_real
                continue;
            end
            for k = 1:length(th2)
                fx(k) = ex(k) + a / c * (gx(k) - ex(k)) * C(k) + a / c * (gy(k) - ey(k)) * S(k);
                fy(k) = ey(k) + a / c * (gy(k) - ey(k)) * C(k) - a / c * (gx(k) - ex(k)) * S(k);
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
                x = -[0; by(k); hy(k); fy(k); dy];
                y = [0; bx(k); hx(k); fx(k); dx];
                wingspan = polyarea(x, y);
                fold = hy(k);
                score = 0.25 * ((wingspan-global_ws_min) / (global_ws_max-global_ws_min)) + 0.75* (1-((fold-global_fold_min) /(global_fold_max - global_fold_min)));
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
                    best_params.l6 = l6;
                    best_params.wingspan = wingspan;
                    best_params.fold = fold;
                end
            end
        end
    end
end
disp('Global Best Parameters:');
disp(best_params);
disp(['Max Score: ', num2str(global_max_score)]);

