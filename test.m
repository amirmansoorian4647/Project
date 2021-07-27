clear
clc

%% initialization
r0 = [27;11.137];  % initial loc of array [m] (location that for first time receive a signal)
r_prim = [1;0.56]; % source loc [m]
v = [0.7;1.5];     % array velocity [m/sec]

d = [0;0.25];      % array dist elements [m] (array is linier)
fc = 5e6;          % carrier freq [Hz]
Diversity = @(theta_s) 1;% source diversity

window_size = 0.05;   % [sec]

fs = 1e3;         % sampling freq [Hz]
time = 0:1/fs:20;
S = sin(2*pi*10*time);% source signal
%% in t = T0 , T0+5 [sec]
receiving_times = [0 5];
for t = receiving_times
   r = r0 + t*v;
   [Y,T] = received_sig(S,r_prim,r,d,fc,Diversity);
   if t==0
       T0 = T;
   end
   shift_time = t-(T-T0);   
   received_signal = Y(:,(shift_time<time)&(time<=(shift_time+window_size)));
   
   theta = MUSIC(received_signal,d,fc);
   disp(theta)
end




