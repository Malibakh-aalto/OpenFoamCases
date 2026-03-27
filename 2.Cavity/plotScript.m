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
    'defaultAxesGridAlpha',0.1);


mrkrs = {'o','s','^','d','v','>','<','p','h','x','+'};
lineStyles = {'-','--','-.',':','-'};

%% Read Data
% Ghia Data
dataU = readtable('Ghia_ux.dat');
dataU.Properties.VariableNames = {'y','u_Re100','u_Re400'};

dataV = readtable('Ghia_uy.dat');
dataV.Properties.VariableNames = {'x','v_Re100','v_Re400'};

% Simulation data
times = [1 2 3 4 10];
u_y_40 = cell(numel(times),1);
v_x_40 = cell(numel(times),1);

for k = 1:numel(times)
    % for u
    fname = fullfile('midy40', sprintf('%d.dat',times(k)));
    T = readtable(fname);
    T.Properties.VariableNames = {'y','u','v','w'};
    u_y_40{k} = T;
    % for v
    fname2 = fullfile('midx40', sprintf('%d.dat',times(k)));
    T = readtable(fname2);
    T.Properties.VariableNames = {'x','u','v','w'};
    v_x_40{k} = T;
end

grids = [10 40 80];
u_y_grid = cell(numel(grids),1);
v_x_grid = cell(numel(grids),1);

for k=1:numel(grids)
    % For u
    fname = fullfile('difGridSize', sprintf('%dmidy.dat',grids(k)));
    T = readtable(fname);
    T.Properties.VariableNames = {'y','u','v','w'};
    u_y_grid{k}=T;
    % For v
    fname = fullfile('difGridSize', sprintf('%dmidx.dat',grids(k)));
    T = readtable(fname);
    T.Properties.VariableNames = {'x','u','v','w'};
    v_x_grid{k}=T;
end



%% Figure 1: plotting u vs y for vertical midplane
figure(1); clf; hold on;
% axis equal; axis tight;
set(gcf, 'Position', [100 100 1000 730]);  % narrower & taller

plot(dataU.u_Re100, dataU.y, 'ks--', ...
    'DisplayName','Ghia et al. (1982)','MarkerSize',12);

for k = 1:numel(times)   % plot only t = 2,4,6
    plot(u_y_40{k}.u, u_y_40{k}.y, ...
        'Color', c(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'DisplayName', sprintf('t = %d s', times(k)));
end

% title('Mesh Resolution: 40 × 40');
xlabel('u (m/s)'); ylabel('y (m)');
legend('Location','southeast')
hold off;

exportgraphics(gcf,'Fig1.jpg');
exportgraphics(gcf,'Fig1.pdf','ContentType','vector');

%% Figure 2: plotting v vs x for vertical midplane
figure(2); clf; hold on;
set(gcf, 'Position', [100 100 1000 730]);  % narrower & taller

plot(dataV.x, dataV.v_Re100, 'ks--', ...
    'DisplayName','Ghia et al. (1982)','MarkerSize',12);

for k = 1:numel(times)   % plot only t = 2,4,6
    plot(v_x_40{k}.x, v_x_40{k}.v, ...
        'Color', c(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'DisplayName', sprintf('t = %d s', times(k)));
end

% title('Mesh Resolution: 40 × 40'); 
xlabel('x (m)'); ylabel('v (m/s)');
legend('Location','northeast')
hold off;

exportgraphics(gcf,'Fig2.jpg');
exportgraphics(gcf,'Fig2.pdf','ContentType','vector');

%% Figure 3: plotting u vs y for vertical midplane different meshes
figure(3); clf; hold on;
% axis equal; axis tight;
set(gcf, 'Position', [100 100 1000 730]);  % narrower & taller

plot(dataU.u_Re100, dataU.y, 'ks--', ...
    'DisplayName','Ghia et al. (1982)','MarkerSize',16,'LineWidth',2);

for k = 1:numel(grids)   
    plot(u_y_grid{k}.u, u_y_grid{k}.y, ...
        'Color', c(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'DisplayName', sprintf('%d ⨉ %d resolution', grids(k),grids(k) ));
end

% title('Horizontal Velocity of Vertical Midplane');
xlabel('u (m/s)'); ylabel('y (m)');
legend('Location','southeast')
hold off;

exportgraphics(gcf,'Fig3.jpg');
exportgraphics(gcf,'Fig3.pdf','ContentType','vector');

%% Figure 4: plotting x vs v for horizontal midplane different meshes
figure(4); clf; hold on;
% axis equal; axis tight;
set(gcf, 'Position', [100 100 1000 730]);  % narrower & taller

plot(dataV.x, dataV.v_Re100, 'ks--', ...
    'DisplayName','Ghia et al. (1982)','MarkerSize',16);

for k = 1:numel(grids)   
    plot(v_x_grid{k}.x, v_x_grid{k}.v, ...
        'Color', c(k,:), ...
        'LineStyle', lineStyles{k}, ...
        'DisplayName', sprintf('%d ⨉ %d resolution', grids(k),grids(k) ));
end

% title('Vertical Velocity of Horizontal Midplane');
xlabel('x (m)'); ylabel('v (m/s)');
legend('Location','northeast')
hold off;

exportgraphics(gcf,'Fig4.jpg');
exportgraphics(gcf,'Fig4.pdf','ContentType','vector');

