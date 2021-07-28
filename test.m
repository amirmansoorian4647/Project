clear
clc

%% initialization
sources_num = 2;
dim = 2;
r0 = [27;11.137];  % initial loc of array [m] (location that for first time receive a signal)
r_prim1 = [1;0.56]; % source 1 loc [m]
r_prim2 = [-5.067;-17.23]; % source 2 loc [m]
r_prim = [r_prim1,r_prim2];
v = [0.7;1.5];     % array velocity [m/sec]

d = [0;0.12;0.25;0.37;0.45;0.67];      % array dist elements [m] (array is linier)
fc = 5e6;          % carrier freq [Hz]
Diversity = @(theta_s) 1;% source diversity

window_size = 0.05;   % [sec]

fs = 1e3;         % sampling freq [Hz]
time = 0:1/fs:20;
S1 = sin(2*pi*10*time);% source 1 signal
S2 = sin(2*pi*14*time);% source 1 signal
S = [S1;S2];
%% in t = 0.2:3:15 [sec]
receiving_times = 0.2:3:15;

for t = receiving_times
   %---------------------------------------------received signal simulation
   r = r0 + t*v;
   received_signal = 0;
   for i = 1:sources_num
       [Y,T] = received_sig(S(i,:),r_prim(:,i),r,d,fc,Diversity);
       shift_time = t-T;  

       received_signal = received_signal + Y(:,(shift_time<time)&(time<=(shift_time+window_size)));
   end
   %-------------------------------------------------------------Estimation
   theta = MUSIC(received_signal,d,fc);
   
   time_txt = num2str(t);
   disp("-------------------------At t = "+time_txt+" [sec]-------------------------")
   disp('Relative Angles [deg] = ')
   disp(theta*180/pi)
   L = length(theta);
   INDEX = [];
   for i = 1:L
       u = [cos(theta(i));sin(theta(i))];
       if t==receiving_times(1)
           A(:,:,i) = eye(dim)-u*u';
           B(:,i) = (eye(dim)-u*u')*r;
           INDEX = [INDEX,i];
       else
           [~,idx] = min(abs(theta_old-theta(i)));
           A(:,:,idx) = A(:,:,idx)+(eye(dim)-u*u');
           B(:,idx) = B(:,idx) + (eye(dim)-u*u')*r;
           estimate_source_loc(:,idx) = pinv(A(:,:,idx))*B(:,idx);
           INDEX = [INDEX,idx];
       end
   end
   [~,INDEX] = sort(INDEX);
   theta_old = theta(INDEX);
   
   if t~=receiving_times(1)
       disp('Absolute Locations = ')
       disp(estimate_source_loc)
   end
end




