% pendulum_derivs()
% Derivative function for the in-class exercise on the extensible pendulum.

function res = pendulum_derivs(~, S)

    % Model parameters    
    g = 10;   % m/s^2
    m = 1;    % kg
    k = 100;  % N/m
    l0 = 1.0; % m

    % Unpack the state vector
    x = S(1);
    y = S(2);
    vx = S(3);
    vy = S(4);
    
    % Compute the derivatives
    l = sqrt(x^2 + y^2);
    ax = -x*(k/m)*(1-l0/l);
    ay = -g - y*(k/m)*(1-l0/l);
    
    % Return derivatives as a column vector
    res = [vx; vy; ax; ay];
end
