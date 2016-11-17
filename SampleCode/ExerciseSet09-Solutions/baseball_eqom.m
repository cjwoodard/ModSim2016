% BASEBALL_EQOM  Equations of motion for the Manny Ramirez problem.
%   (These are the ODEs to be solved by ode45.)

function res = baseball_eqom(~, W)    % we still don't use the time input

    % Define the mass of the ball and a bunch of constants.
    mass = 0.145;        % mass of the ball (kg)
    C = 0.3;             % dimensionless coefficient of drag
    rho = 1.2;           % density of air (kg / m^3)
    A = 0.004;           % cross sectional area (m^2)
    g = 9.8;             % acceleration due to gravity (m/s^2)

    % Unpack the state vector W, which contains 4 elements:
    % x, y, Vx, and Vy
    x = W(1);            % x position of the ball (m) [unused below]
    y = W(2);            % y position of the ball (m) [unused below]
    Vx = W(3);           % x velocity of the ball (m/s)
    Vy = W(4);           % y velocity of the ball (m/s)

    % Define the forces due to gravity.
    Fxg = 0;             % kg m / s^2
    Fyg = -mass.*g;      % kg m / s^2

    % Define the forces due to drag.
    Fxd = - 1/2.*C.*rho.*A.*Vx.*sqrt(Vx.^2 + Vy.^2);   % kg m / s^2
    Fyd = - 1/2.*C.*rho.*A.*Vy.*sqrt(Vx.^2 + Vy.^2);   % kg m / s^2

    % Add the forces together.
    Fx = Fxg + Fxd;
    Fy = Fyg + Fyd;

    % Define the ODEs for velocity.
    dxdt = Vx;
    dydt = Vy;

    % Define the ODEs for acceleration.
    dVxdt = Fx./mass;
    dVydt = Fy./mass;

    % Pack everything back into a state vector.
    res = [dxdt; dydt; dVxdt; dVydt];
end
