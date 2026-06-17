%keeping step size = 0.1 and the th2 range to be 0 to 2* pi

% Mechanical adavantage 
ma = zeros(1, length(th2));

% indside the for loop for output link

%instantaneous mechanical advantage
ma(i) = atan((hy-fy(i))/(hx-fx(i)));

%average mechanical advantage
MA = sum(abs(ma))/sum(abs(th2));

%flap10.m
MA = 0.147674380108363;


%instantaneous mechanical advantage
ma(i) = atan((hy-fy(i))/(hx-fx(i)));

%flap12.m
MA = 0.437702335110063;

%instantaneous mechanical advantage
ma(i) = atan((hy-iy(i))/(hx-ix(i)));

%flap21.m
MA = 0.129137752168042;

%instantaneous mechanical advantage
ma(i) = atan((ey(i)-gy(i))/(ex(i)-gx(i)));

%flap1_3.m
MA = 0.317956162072397;


%instantaneous mechanical advantage
ma(i) = atan(-(ey(i)-gy(i))/(ex(i)-gx(i)));

%flap 2_4.m
MA = 0.317956162072397;


%instantaneous mechanical advantage
ma(i) = atan((dy-cy(i))/(dx-cx(i)));

%FLAP 3_2.M
MA = 0.317956162072397;

%instantaneous mechanical advantage
ma(i) = atan((dy-cy(i))/(dx-cx(i)));

%FLAP 4_2.M
MA = 0.317956162072397;

%instantaneous mechanical advantage
ma(i) = atan((dy-cy(i))/(dx-cx(i)));

%flap 5_2.m
MA = 0.317956162072397;

%instantaneous mechanical advantage
ma(i) = atan((dy(i)-fy)/(dx(i)-fx));

%FLAP 6.M
MA = 0.156385362424043