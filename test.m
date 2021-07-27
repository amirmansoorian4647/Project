clear
clc

%% initialization
dim = 2;
r0 = [27;11.137];  % initial loc of array [m] (location that for first time receive a signal)
r_prim = [1;0.56]; % source loc [m]
v = [0.7;1.5];     % array velocity [m/sec]

d = [0;0.12;0.25;0.37];      % array dist elements [m] (array is linier)
fc = 5e6;          % carrier freq [Hz]
Diversity = @(theta_s) 1;% source diversity

window_size = 0.05;   % [sec]

fs = 1e3;         % sampling freq [Hz]
time = 0:1/fs:20;
S = sin(2*pi*10*time);% source signal
%% in t = 0.2:0.5:15 [sec]
receiving_times = 0.2:0.5:15;
A = zeros(dim);
B = zeros(dim,1);
for t = receiving_times
   r = r0 + t*v;
   [Y,T] = received_sig(S,r_prim,r,d,fc,Diversity);
   shift_time = t-T;  
   
   received_signal = Y(:,(shift_time<time)&(time<=(shift_time+window_size)));
   
   theta = MUSIC(received_signal,d,fc);
   
   disp(theta*180/pi)
   u = [cos(theta);sin(theta)];
   A = A+(eye(dim)-u*u');
   B = B + (eye(dim)-u*u')*r;
   estimate_source_loc = pinv(A)*B;
   disp(estimate_source_loc)
end




