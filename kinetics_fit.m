%% Kinetic analysis of batch reactor data: 2A -> R + S at 100 C
clc; clear; close all;

%% Data (constant volume batch reactor)
t  = [0 20 40 60 80 100 140 200 260 330 420];                    % time (s)
pA = [1.00 0.80 0.68 0.56 0.45 0.37 0.25 0.14 0.08 0.04 0.02];   % partial pressure of A (atm)

%% Order test: plot both linear forms
figure;
subplot(1,2,1);
plot(t, log(pA), 'bo-', 'LineWidth', 1.5);
xlabel('t (s)'); ylabel('ln(p_A)');
title('First-order test');
grid on;

subplot(1,2,2);
plot(t, 1./pA, 'ro-', 'LineWidth', 1.5);
xlabel('t (s)'); ylabel('1/p_A (1/atm)');
title('Second-order test');
grid on;
%% Fit the first-order line to get k
p = polyfit(t, log(pA), 1);   % p(1) = slope, p(2) = intercept
k = -p(1);                     % rate constant (1/s)

fprintf('Rate constant k = %.4f 1/s\n', k);
fprintf('Rate constant k = %.4f 1/min\n', k*60);

% Add the fitted line to the first-order plot
subplot(1,2,1); hold on;
plot(t, polyval(p, t), 'k--', 'LineWidth', 1);
legend('Data', 'Fit', 'Location', 'northeast');
%% Mixed flow reactor sizing (95% conversion)
R_gas = 0.0821;        % L.atm/(mol.K)
T     = 373.15;        % K (100 C)
Ptot  = 1;              % atm
Fin   = 100/3600;       % mol A/s (feed rate of A, from 100 mol/hr)
yA0   = 0.8;            % mole fraction A in feed (20% inerts)
XA    = 0.95;           % target conversion

CA0 = yA0*Ptot/(R_gas*T);      % initial concentration of A (mol/L)
epsA = yA0 * ((1+1)/2 - 1);     % 2A -> R+S: 2 mol A give 2 mol product, so delta n = 0
% delta n per mole A reacted = (1/2 + 1/2) - 1 = 0, so epsA = 0 for this stoichiometry

CA_exit = CA0*(1-XA)/(1+epsA*XA);
rA_exit = k*CA_exit;

V = Fin*XA / rA_exit;    % litres

fprintf('CA0 = %.4f mol/L\n', CA0);
fprintf('Reactor volume V = %.2f L\n', V);
saveas(gcf, 'kinetics_fit.png');