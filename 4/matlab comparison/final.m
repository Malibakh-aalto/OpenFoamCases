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

%% Input varialbes
U = 0.561;                  % m/s
h = 5.2;                    % mm
h = h * 1E-3;               % to meters
H = 10.1;                   % mm
H = H * 1E-3;               % to meters
nu = 1.51E-5;               % m2/s kinetamtic viscosity of air at 20°C
fprintf('Kinematic viscosity is: %.2e\n',nu);
Re = 2 * U * h / nu;        % Reynolds Number -- found out that this is LAMINAR (Re<2300)
fprintf('The flow Reynolds Number is: %.2f\n',Re);
Re_h = U * h / nu;
L_e =  0.06 * Re_h * h;   % for laminar flows Le/d = 0.06 * Re_d
fprintf('The entrance length for laminar flow is L_e = 0.06 * Re_h * h, and here is: %.2f mm\n ',L_e*1E3);

%% Read Table at 0 and the corresponding calculations
armaly0 = readtable("Armaly0mm.dat");
armaly0.Properties.VariableNames = {'y','u'};

u0_40 = readtable('40m\u0.dat');
u0_40.Properties.VariableNames = {'y','u','v','w'};
u0_40.y = u0_40.y*1e3 + 4.76;

u0_80 = readtable('80m\u0.dat');
u0_80.Properties.VariableNames = {'y','u','v','w'};
u0_80.y = u0_80.y*1e3 + 4.76;

u0_110 = readtable('110m\u0.dat');
u0_110.Properties.VariableNames = {'y','u','v','w'};
u0_110.y = u0_110.y*1e3 + 4.76;

figure(1); clf; hold on; 
plot(armaly0.u,armaly0.y,'o','DisplayName','Armaly x = 0 mm','MarkerSize',12);
plot(u0_40.u,u0_40.y,'DisplayName','40 mm distance');
plot(u0_80.u,u0_80.y,'DisplayName','80 mm distance');
plot(u0_110.u,u0_110.y,'DisplayName','110 mm distance');

legend('Location','best'); hold off;
xlabel('u (m/s)'); ylabel('y (mm)');ylim([0 10.5]);
legend('Location','southeast');
exportgraphics(gcf,'Fig1.jpg');
exportgraphics(gcf,'Fig1.pdf','ContentType','vector');

%% Read Table at other times

armalyFiles = { ...
    'Armaly15.3mm.dat'
    'Armaly24mm.dat'
    'Armaly30.6mm.dat'
    'Armaly35.7mm.dat'
    'Armaly38.8mm.dat'};

uid  = [15 24 30 35 38];
dist = [40 80 110];

for k = 1:length(armalyFiles)

    armaly = readtable(armalyFiles{k});
    armaly.Properties.VariableNames = {'y','u'};

    figure(k+1); clf; hold on

    plot(armaly.u,armaly.y,'o',...
        'DisplayName',sprintf('Armaly x = %s mm',armalyFiles{k}(7:end-6)),...
        'MarkerSize',12)

    for j = 1:length(dist)

        filename = sprintf('%dm\\u%d.dat',dist(j),uid(k));
        T = readtable(filename);

        T.Properties.VariableNames = {'y','u','v','w'};
        T.y = T.y*1e3 + 4.9;

        plot(T.u,T.y,'DisplayName',sprintf('%d mm distance',dist(j)))

    end

    xlabel('u (m/s)')
    ylabel('y (mm)')
    ylim([0 10.5])
    legend('Location','southeast')

    exportgraphics(gcf,sprintf('Fig%d.jpg',k+1))
    exportgraphics(gcf,sprintf('Fig%d.pdf',k+1),'ContentType','vector')

end