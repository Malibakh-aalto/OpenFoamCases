clc; clear;

%% The default setup
c = [
    0         0.4470    0.7410;  % Blue
    0.8500    0.3250    0.0980;  % Orange
    0.9290    0.6940    0.1250;  % Yellow
    0.4940    0.1840    0.5560;  % Purple
    0.4660    0.6740    0.1880;  % Green
    0.3010    0.7450    0.9330;  % Light Blue
    0.6350    0.0780    0.1840;  % Red
    0.75      0.75      0;       % Olive
    0.75      0         0.75;    % Magenta
    0.25      0.25      0.25;    % Dark Gray
    1         0.6       0.6;     % Light Pink
    0         0.5       0;       % Dark Green
    0.5       0.5       0.5;     % Gray
    1         0.41      0.16;    % Dark Orange
    0         0         0        % Black
    ];
set(groot, ...
    'DefaultAxesFontName',       'Times New Roman', ...
    'DefaultTextFontName',       'Times New Roman', ...
    'DefaultLegendFontName',     'Times New Roman', ...
    'DefaultAxesColorOrder',      c,              ...
    'DefaultAxesXGrid',          'on',            ...
    'DefaultAxesYGrid',          'on',            ...
    'DefaultAxesZGrid',          'on',            ...
    'DefaultAxesBox',            'on',            ...
    'DefaultLegendFontSize',      22,             ...
    'DefaultAxesFontSize',        22,             ...
    'DefaultLineLineWidth',       2, ...
    'DefaultAxesGridAlpha',0.1, ...
    'DefaultFigurePosition',[100 100 1000 730]);

mrkrs = {'o','s','^','d','v','>','<','p','h','x','+'};
lineStyles = {'-','--','-.',':','-'};

%% Read Table and the corresponding calculations
blasiusData = readtable("blasius.dat");
blasiusData.Properties.VariableNames = {'eta','f_eta','f_prime_eta','theta'};

near = readtable('near.dat');           % it is located at the x=0.1
near.Properties.VariableNames = {'y','u','v','w','T'};
x_near = 0.1;

mid = readtable('mid.dat');             % it is located at x = 0.4
mid.Properties.VariableNames = {'y','u','v','w','T'};
x_mid = 0.4;

far = readtable('far.dat');             % it is located at x = 0.8
far.Properties.VariableNames = {'y','u','v','w','T'};
x_far = 0.8;

wallShear = readtable('wallShear.dat');
wallShear.Properties.VariableNames = {'x','shear_x','shear_y','shear_z'};

% Calculation of variables 
nu = 1.5e-5;    % m^2/s
U = 6.5;        % m/s
T_e = 300;      % K, freestream temperature
T_w = 355;      % K, wall temperature
y = linspace(0,0.02,201);
Pr = 0.7;       % Prandtl Number
D = nu/Pr;      % This is the diffusivity number (m^2/s)

eta =@(x,y) y .* sqrt(U ./ (2 .* nu .* x));
u_blasius = @(u,x,y) u .* interp1(blasiusData.eta, blasiusData.f_prime_eta,eta(x,y),'linear','extrap');
theta_pohlhausen = @(x,y)  interp1(blasiusData.eta, blasiusData.theta,eta(x,y),'linear','extrap');
T_pohlhausen =@(x,y) T_e + (T_w -T_e) .* theta_pohlhausen(x,y);

x = linspace(0.001,1,1000);
dudy_blas = u_blasius(U,x,y(2)) ./ y(2);
C_f_blasius = 2 .* nu .* dudy_blas ./ (U^2);

%% Figure 1 blasius plot
figure(1); clf; hold on; 
% set(gcf, 'Position', [100 100 1000 730]);  
plot(blasiusData.eta, blasiusData.f_eta,'DisplayName','f(\eta)');
plot(blasiusData.eta, blasiusData.f_prime_eta,'DisplayName','f''(\eta)');
plot(blasiusData.eta, blasiusData.theta,'DisplayName','\theta(\eta)');

xlabel('\eta'); title('Blasius Solution of Laminar Boundary Layer');
legend('Location','best'); hold off;
exportgraphics(gcf,'Fig1.jpg');
exportgraphics(gcf,'Fig1.pdf','ContentType','vector');

%% Figure 2
figure(2); clf; hold on;

plot(near.u, near.y,'DisplayName','At x = 0.1 m');
plot(mid.u, mid.y,'DisplayName','At x = 0.4 m');
plot(far.u, far.y,'DisplayName','At x = 0.8 m');

% plot(u_blasius(U,x_near,y),y,'s--','DisplayName','Blasius at x = 0.1 m','MarkerIndices',1:3:100,'MarkerSize',10);
% plot(u_blasius(U,x_mid,y),y,'s--','DisplayName','Blasius at x = 0.4 m','MarkerIndices',1:3:100,'MarkerSize',10);
% plot(u_blasius(U,x_far,y),y,'s--','DisplayName','Blasius at x = 0.8 m','MarkerIndices',1:3:100,'MarkerSize',10);

axis([0 7 0 0.01]); xlabel('u (m/s)'); ylabel('Y (m)');hold off;
legend('Location','northwest');
exportgraphics(gcf,'Fig2.jpg');
exportgraphics(gcf,'Fig2.pdf','ContentType','vector');

%% Figure 3 Temperature Profile of Laminar Boundary Layer
figure(3); clf; hold on;

plot(near.T, near.y,'DisplayName','Simulated (x = 0.1 m)');
plot(mid.T, mid.y,'DisplayName','Simulated (x = 0.4 m)');
plot(far.T, far.y,'DisplayName','Simulated (x = 0.8 m)');

% set(gca,'ColorOrderIndex',1);
plot(T_pohlhausen(0.1,y),y,'s--','DisplayName','Pohlhausen (x = 0.1 m)','MarkerIndices',1:3:200,'MarkerSize',10);
plot(T_pohlhausen(0.4,y),y,'s--','DisplayName','Pohlhausen (x = 0.4 m)','MarkerIndices',1:3:200,'MarkerSize',10);
plot(T_pohlhausen(0.8,y),y,'s--','DisplayName','Pohlhausen (x = 0.8 m)','MarkerIndices',1:3:200,'MarkerSize',10);

axis([295 360 -0.001 0.012]); 
ax = gca;
ax.YAxis.Exponent = 0;
xlabel('T (K)'); ylabel('Y (m)');hold off;
legend('Location','northeast');
exportgraphics(gcf,'Fig3.jpg');
exportgraphics(gcf,'Fig3.pdf','ContentType','vector');

%% Figure 4 
figure(4); clf; hold on;

% Number of markers you want
nMarkers = 30;
% Create clustered indices near the beginning
idx = unique(round(linspace(1, sqrt(numel(x)), nMarkers).^2));
idx(idx > numel(x)) = [];

plot(wallShear.x, 2 .* wallShear.shear_x ./ U^2,'DisplayName','Simulated Shear Wall Stress','LineWidth',2);
plot(x,-C_f_blasius,'s','DisplayName','Blasius Solution','MarkerIndices',idx,'MarkerSize',10);
axis([-0.1 1 -0.018 0 ]);


xlabel('x (m)'); ylabel('C_f');
legend('Location','south'); hold off;
exportgraphics(gcf,'Fig4.jpg');
exportgraphics(gcf,'Fig4.pdf','ContentType','vector');

