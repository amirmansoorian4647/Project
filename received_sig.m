function [y, T] = received_sig(S, r_prime, r, d, fc, Diversity)
% r_prim = location of source (it's a vector in Cartesian cordinate system)
% r = location of receiver (it's a vector in Cartesian cordinate system)
% d = distance between received signal & first element of array (it's a scalar)
% fc = carrier frequency
% Diversity = diversity of source (it's a function of angels)
    c = 3e8;
    R = r - r_prime;
    theta = atan(R(2) / R(1));
    tau = d * sin(theta) / c;
    theta_s = theta + (R(1) <0 ) * pi;
    norm_R = norm(R, "fro");
    T = norm_R / c;
    y = sqrt(Diversity(theta_s)) * exp(-1i*2*pi*fc*tau) * S / norm_R;
