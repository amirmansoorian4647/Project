function phi_theta = MUSIC(received_signal,d,fc)
    % redeived_sig is a matrix that i_th row of it is received signal in i_th element of array
    % d = distance between first element to other elements of array (it's a vertical vector)
    % fc = carrier frequency  
    acuracy_digit = 5; % 10^-5 [deg]

    c = physconst('LightSpeed');
    k = 2*pi*fc/c;
    M = size(received_signal,1);
    R_x = received_signal*received_signal';
    [U,D] = eig(R_x);
    [lambda,I] = sort(diag(D),'descend');
    U = U(:,I);
    %----------------------------------------------number of sources estimation
    threshold = 0.02; 
    i = M-1;
    % If difference of two smallest eigenvalues is less than "criterion" of bigger one,then we assume that two of them are same (noise).
    while 1
        flag = 1;
        if lambda(i+1)>=(1-threshold)*lambda(i)
            i = i-1;
            flag = 0;
        end
        if (flag==1)||(i==0)
            break
        end
    end
    source_numbers = i;
    U_nall = U(:,(source_numbers+1):end);
    %-----------------------------------------------------------MUSIC Algorithm
    step = 0.1;
    theta_deg = (0:step:90);
    phi_deg = (0:step:180);
    phi_theta_table = phi_deg.'*theta_deg;
    [Theta, Phi] = meshgrid(theta_deg, phi_deg); % for testing

    theta_rad = theta_deg*pi/180;
    phi_rad = phi_deg*pi/180;
    matrix = cos(phi_rad).'*sin(theta_rad);
    a = exp(-1i*k*d*matrix(:).');
    g = 1./vecnorm(a'*U_nall,2,2);
    g = reshape(g, size(matrix));
    TF = islocalmax(g);
    phi_theta = phi_theta_table(TF);
    phi_theta = phi_theta*pi/180; % convert to radian
end

