% The goal of this script is to figure out how the mad
% 2815 + 11x5.5 in pitch with a 4s battery opperates and
% What the constants are that i can use for my drone
clc; clear;

%% OUTPUTS AT 50% throttle -----------------------------------------------------------

% givens
Kv         = 900;   % RPM per volt
R          = 11/2/39.3700787; % Blade radius (m)
Pitch_in   = 5.5;    % Geometric pitch (in)
rho        = 1.225;  % Air density (kg/m^3)

% from table
V          = 15.48;   % Battery voltage  (V)
I          = 9.84;     % Current (A)
P_out = 109.7; %Power out
RPM_out = 6968; %self evident
Thrust = 912; %gf
eta_p = .7459; %Probably eta_prop

% derived coeffcieints
loaded_factor = RPM_out/(Kv*V)
P_in = V*I;
eta_e = P_out/P_in
slip       = 0.80;   % Static slip ratio

%% DERIVED GEOMETRY ------------------------------------------------------
A     = pi*(R^2);     % Disc (m^2)
RPM   = Kv*V * loaded_factor;     % load speed   (rev/min)
RPS   = RPM/60;              % rev/s
n     = RPS;                 % standard symbol
D     = 2*R;                 % Diameter        (m)
Pitch = Pitch_in/39.3700787;     % Pitch (m)
CT_static  = Thrust/(rho*n^2*(D)^4)  % Rule-of-thumb thrust coeff
CP_static = P_in/(rho*n^3*(D)^5); % Coeff_power
P_shaft    = P_in*eta_e*eta_p;   % W  (what reaches the blades)

%% METHOD 1 – Pitch-speed momentum estimate (½ removed) ------------------
V_exit = slip * Pitch * RPS;    % Exit velocity (m/s)
F_p    =   rho * A * V_exit^2;  % Thrust (N)

%% METHOD 2 – Empirical C_T formula -------------------------------------
F_CT   = CT_static/CP_static*P_in/(n*D);  % Thrust (N)

%% METHOD 3 – Actuator-disk cube-root   ---------------------------------
F_AD = (rho*pi*(D^2)/2 * P_shaft^2)^(1/3);     % Thrust (N)

%% PRINT RESULTS ---------------------------------------------------------
fprintf('\n--- STATIC-THRUST ESTIMATES ---\n');
fprintf('Pitch-speed (momentum)  : %5.2f N  (%4.0f g)\n', F_p, 1e3*F_p/9.81);
fprintf('Empirical C_T           : %5.2f N  (%4.0f g)\n', F_CT*9.81/1000, F_CT);
fprintf('Cube-root actuator disk : %5.2f N  (%4.0f g)\n', F_AD, 1e3*F_AD/9.81);
fprintf('loaded RPM             : %5.0f rev/min\n', RPM);
