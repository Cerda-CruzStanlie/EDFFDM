% ---- known constants --------------------------------------------------
rho   = 1.225;          % air density
R     = 0.15;           % rotor radius, m
A     = pi*R^2;
RPM   = 18000;          % commanded speed
Omega = 2*pi*RPM/60;    % rad/s

% ---- motor curve ------------------------------------------------------
motorTorque = @(rpm,thr)   kT(thr)*rpm;    % example linear law
throttle    = 0.75;                        % test throttle setting
Q_target    = motorTorque(RPM, throttle);  % N·m

% ---- iterate collective ------------------------------------------------
beta0 = deg2rad(10);      % initial collective [rad]

for iter = 1:20
    % 1) run BEMT with current beta0 ----------------
    [CT, CQ] = bemtSolve(beta0, geom, aeroPolars, aw, sigma);
    
    % 2) dimensional torque -------------------------
    Q_rotor = CQ * rho * (Omega*R)^2 * A * R;
    
    % 3) compare & adjust ---------------------------
    err = Q_rotor - Q_target;
    if abs(err/Q_target) < 1e-3, break, end
    
    beta0 = beta0 - 0.5*err/Q_target;   % crude PI step
end

% 4) once converged, final thrust -------------------
T = CT * rho * (Omega*R)^2 * A;
fprintf('Thrust at %.0f rpm and %.0f %% throttle = %.1f N\n',...
        RPM, throttle*100, T);