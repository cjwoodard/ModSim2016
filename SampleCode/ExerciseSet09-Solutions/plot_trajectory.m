% PLOT_TRAJECTORY  Simulate the flight of Manny's baseball and plot its
%   trajectory. Takes two parameters: initial speed (in m / s) and
%   angle (in degrees).

function plot_trajectory(speed, angle)

    % Convert the angle to radians.
    theta = angle * pi / 180;           % radians

    % Convert the speed and angle to x- and y-velocities.
    [Vx, Vy] = pol2cart(theta, speed);  % m / s

    % Note that the line above is equivalent to:
    %   Vx = speed .* cos(theta);
    %   Vy = speed .* sin(theta);
    % (Type doc pol2cart for details.)
    
    % Define the initial conditions of the state vector, corresponding to
    % x = 0, y = 1, Vx, and Vy.
    W = [0, 1, Vx, Vy];
    
    % Define the end time of the simulation.
    endTime = 10;  % seconds

    % Compute a solution by calling ode45.
    [T, M] = ode45(@baseball_eqom, [0, endTime], W);

    % Unpack the solution into positions and velocities.
    x = M(:,1);
    y = M(:,2);
    Vx = M(:,3);
    Vy = M(:,4);

    % Plot the trajectory.
    clf
    plot(x, y, 'k*-')
    xlabel('Horizontal Location')
    ylabel('Vertical Location')
    title(['Speed = ', num2str(speed), ', Angle = ', num2str(angle)])
    drawnow
end

