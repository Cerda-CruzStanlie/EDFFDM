% Utilizing method 1 from Propeller Coeffs, find an optimal pitch for the angles for
% fan crossections at different distances. Mimics 50% throttle condition for
% MAD 2815 + 11 x 5.5 in prop 

clc; clear;

%% USER INPUTS (Mimics 50% throttle)-----------------------------------------------------------
Kv         = 900;   % RPM per volt
V          = 15.48;   % Battery voltage  (V)
I          = 9.84;     % Current (A)
rho        = 1.225;  % Air density (kg/m^3)
R          = 150 / 1000; % Blade radius (m)
eta_p = 0.7459;          % prop efficiency


%% — User-tuned constants (50 % throttle point) —
loaded_factor = 0.5001;     % from PropellerCoeffs.m
eta_e   = 0.7202;     % P_out / P_in  from PropellerCoeffs.m

%% DERIVED GEOMETRY ------------------------------------------------------
A     = pi*(R^2);     % Disc (m^2)
RPM   = Kv*V * loaded_factor;     % load speed   (rev/min)
RPS   = RPM/60;              % rev/s
n     = RPS;                 % standard symbol
D     = 2*R;                 % Diameter        (m)
P_shaft    = V*I*eta_e*eta_p;   % W  (what reaches the blades)

%% Theoretical Force Clac   ---------------------------------
a = 1;  % non-dimensional wake parameter (if area increases/decreases downstream)
%F_AD = (rho*pi*(D^2)/2 * P_shaft^2)^(1/3)   % forum 
F = (P_shaft*sqrt(4*a*rho*A))^(2/3) % Leishman DF model


%% Pitch and angle determination
%v_AD = (2*sqrt(2))*sqrt(F_AD)/(D*sqrt(rho)*sqrt(pi)) % forum
v = sqrt(a*F/(rho*A)) %leishman DF model

Pitch = v/n     % Pitch (m)
alpha = 7;

% Angle at Specific Distances

r = linspace(0, 1.0, 101); % radial stations
beta = zeros(size(r)); % initialize beta array
Omega = 2*pi*n; lam = v/(Omega*R);

%Betas (or pitch angles) based on different solidity equations

beta1 = atand(Pitch ./ (2 * pi * r*R)) + alpha; % Tip angle (degrees) 
beta2 = atand(lam./r) + alpha; % Tip angle (degrees)


%% PRINT RESULTS ---------------------------------------------------------

figure;
tiledlayout(2,1)
nexttile
plot(r, beta1);
xlabel('Radial Position (r)');
ylabel('Blade Pitch (β)');
title('Blade Pitch vs Radial Position (Solidity Equation 1)');
grid on;
nexttile
plot(r, beta2);
xlabel('Radial Position (r)');
ylabel('Blade Pitch (β)');
title('Blade Pitch vs Radial Position (Solidity Equation 2)');
grid on;

fprintf('\n--- STATIC-THRUST ESTIMATES ---\n');
fprintf('Cube-root actuator disk : %5.2f N  (%4.0f g)\n', F_AD, 1e3*F_AD/9.81);
fprintf('loaded RPM             : %5.0f rev/min\n', RPM);
