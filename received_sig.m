function [Y, T] = received_sig(S, r_prime, r, d, fc, Diversity)
% S = lowpass source signal (it's a horizental vector).
% r_prim = location of source (it's a vertical vector in Cartesian cordinate system)
% r = location of receiver (it's a vertical vector in Cartesian cordinate system)
% d = distance between first element to other elements of array (it's a vertical vector)
% fc = carrier frequency
% Diversity = diversity of source (it's a function of angels)

    c = 3e8;
    R = r - r_prime;
    theta = atan(R(2) / R(1));
    tau = d * sin(theta) / c;
    steering_vec = exp(-1i*2*pi*fc*tau);
    
    theta_s = theta + (R(1) <0 ) * pi;
    norm_R = norm(R, "fro");
    
    T = norm_R / c;
    Y = sqrt(Diversity(theta_s)) * steering_vec * S / norm_R;
    
end
