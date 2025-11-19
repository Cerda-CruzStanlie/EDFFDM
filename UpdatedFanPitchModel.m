clc
clear
close all
% Parameters
r = linspace(0, 1.0, 101); % radial stations
beta = zeros(size(r)); % initialize beta array
alpha_des_deg = 8;                   % design α in degrees
alpha_des     = deg2rad(alpha_des_deg);   % → radians
aw = 1.25; % contraction ratio
sigma = .25; % local solidity
epsilon = 1e-5; % convergence criterion
max_iterations = 1000; % maximum iterations
relaxation = .5; % relaxation factor

% Airfoil polar functions (example)
CL_polar = @(alpha) 2 * sin((alpha)); % lift coefficient function
CD_polar = @(alpha) 0.01 + (CL_polar(alpha).^2) / (pi * 6); % drag coefficient function

% Iteration over each radial station
for i = 1:length(r)
    lam = 0.05; % initial guess for lambda
    for j = 1:max_iterations
        phi = atan(lam / r(i)); % calculate phi
        CL = CL_polar(alpha_des); % lift coefficient
        CD = CD_polar(alpha_des); % drag coefficient
        RHS = (aw * sigma / 4) * (CL * cos(phi) - CD * sin(phi)) * r(i); % right-hand side
        lam_new = sqrt(RHS); % update lambda

        if abs(lam_new - lam) < 1e-5, break, end % check for convergence
            
        lam = relaxation * lam_new + (1 - relaxation) * lam; % relaxation step
    end
    beta(i) = alpha_des + phi; % calculate beta
end

% solving for optimal cord length
R = 150/1000;
B = 10;
c = sigma*pi*R/B

% Plotting beta vs r
figure;
tiledlayout(2,1)
nexttile
plot(r, beta*180/pi);
xlabel('Radial Position (r)');
ylabel('Blade Pitch (β)');
title('Blade Pitch vs Radial Position');
grid on;
