function theta = MUSIC(received_signal,d,fc)
% redeived_sig is a matrix that i_th row of it is received signal in i_th element of array
% d = distance between first element to other elements of array (it's a vertical vector)
% fc = carrier frequency  
acuracy_digit = 5; % 10^-5 [deg]

    c = 3e8;
    k = 2*pi*fc/c;
    M = size(received_signal,1);
    R_x = received_signal*received_signal';
    [U,D] = eig(R_x);
    [lambda,I] = sort(diag(D),'descend');
    U = U(:,I);
    %----------------------------------------------number of sources estimation
    criterion = 0.02; 
    i = M-1;
    % If difference of two smallest eigenvalues is less than "criterion" of bigger one,then we assume that two of them are same (noise).
    while 1
        flag = 1;
        if lambda(i+1)>=(1-criterion)*lambda(i)
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
    for i = 1:acuracy_digit
        step_old = step;
        if i==1
            theta_deg = (0:step:90);
        else
            step = step_old*0.1;
            theta_deg = theta.'+[(-5*step_old):step:(5*step_old)];
            theta_deg = reshape(theta_deg.',1,[]);
        end
        theta_rad = theta_deg*pi/180;
        a = exp(-1i*k*d*sin(theta_rad));
        g = 1./vecnorm(a'*U_nall,2,2);
        TF = islocalmax(g);
        theta = theta_deg(TF);
    end
    theta = theta*pi/180; % convert to radian
end

