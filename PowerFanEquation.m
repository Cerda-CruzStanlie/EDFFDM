clc;
clear;

% Constants
Kv = 900; % Rotations Per Minute Per Voltage (RPM/V)
V = 11.1; % Voltage (V)
I = 15; % Current (A)
rho = 1.204; % Air density (kg/m^3)
R = 124 / 1000; % Fan radius (m)
R2 = 2.5 / 1000; % Hub radius (m)
g = 9.81; % Gravity (m/s^2)

% Check if hub radius is valid
if R2 >= R
    error('Hub radius (R2) must be smaller than fan radius (R).');
end

% Effective Fan Area (excluding hub area)
A = pi * (R^2 - R2^2); % Effective area (m^2)

% Free Stream Velocity
v = (V * I / (rho * A))^(1/3); % Free stream velocity (m/s)

% Thrust
F = rho * A * v^2; % Thrust (N)
ThrustInGrams = 1000 * F / g; % Thrust in grams (g)

% Rotational Parameters
RPM = Kv * V; % Rotations per minute
RPS = RPM / 60; % Rotations per second
RadPS = RPS * 2 * pi; % Radians per second

% Blade Pitch and Tip Angle
Period = 1 / RPS; % Period (s)
Pitch = v * Period; % Pitch (m)
TipAngle = atand(Pitch / (2 * pi * R)); % Tip angle (degrees)

% Angle at Specific Distances
Distance = 12.75 / 1000; % Distance from center (m)
AngleAtDistance = atand(Pitch / (2 * pi * Distance)); % Angle at Distance (degrees)
AngleAtHub = atand(Pitch / (2 * pi * R2)); % Angle at hub (degrees)

% Display Results
fprintf('Tip Angle @ %.2f mm: %.2f degrees\n', R*1000, TipAngle);
fprintf('Angle @ %.2f mm: %.2f degrees\n', Distance*1000, AngleAtDistance);
fprintf('Hub Angle @%.2f mm: %.2f degrees\n', R2*1000, AngleAtHub);
fprintf('Thrust: %.2f N (%.2f grams)\n', F, ThrustInGrams);

% Additional Calculations
Ae = ThrustInGrams / (rho * v * 1000); % Some derived parameter (clarify its purpose)

% Display Additional Results
fprintf('Effective Fan Area: %.4f m^2\n', A);
fprintf('Ae: %.4f (unitless or clarify purpose)\n', Ae);
