clc
clear
% Derivation of improved fan thrust and speed.
syms rho P n_p n_e d_P v_inf v_delta T0

v_avg = (v_inf + v_inf + v_delta)/2 % (v_1 + v_2)/2
m_dot = pi*d_P^2/4*rho*v_avg
T1 = m_dot*v_delta
T2 = P*n_p*n_e/v_avg

eqn = T0 == subs(T1,v_inf,0)
T02 = subs(T2,v_inf,0)

subs(T02,v_delta,solve(eqn,v_delta))