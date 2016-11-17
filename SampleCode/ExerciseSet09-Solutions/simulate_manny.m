% SIMULATE_MANNY  Simulate the flight of Manny's baseball, returning
%   the final height (in m) when it either hits the ground or clears the
%   Green Monster. Takes two parameters: initial speed (in m / s) and
%   angle (in degrees).

function res = simulate_manny(speed, angle)

    % Model parameters (used by ODE event below).
    wallDistance = 97;    % distance to the wall (m)
    groundHeight = 0;     % height of the ground (m)

    % Convert the angle to radians.
    theta = angle * pi / 180;           % radians

    % Convert the speed and angle to x- and y-velocities.
    [Vx, Vy] = pol2cart(theta, speed);  % m / s

    % Define the initial conditions of the state vector, corresponding to
    % x = 0, y = 1, Vx, and Vy.
    W = [0, 1, Vx, Vy];

    % Make the end time long enough for the event to happen if it is
    % going to happen.
    endTime = 100;  % seconds

    % Set the solver options, including the relative tolerance and the
    % event function. (See below for the event function.)
    options = odeset('Events', @events, 'RelTol', 1e-4);

    % Compute a solution by calling ode45.
    [T, M] = ode45(@baseball_eqom, [0, endTime], W, options);

    % Unpack the solution into positions and velocities.
    x = M(:,1);
    y = M(:,2);
    Vx = M(:,3);
    Vy = M(:,4);

    % Plot the trajectory.
    % (You can comment this code out or move it to a separate function
    % when you're ready to sweep the parameters.)
%     clf
%     plot(x, y, 'k*-')
%     xlabel('Horizontal Location')
%     ylabel('Vertical Location')
%     title(['Speed = ', num2str(speed), ', Angle = ', num2str(angle)])
%     axes = gca;
%     axes.XLim = [0 wallDistance];  % scale x axis from 0 to the wall
%     axes.YLim = [0 wallDistance];  % make the axes equal
%     drawnow
    
    % The result is the final Y position.
    res = y(end);   % meters

    
    % Event function to stop integrating when the ball gets to the wall.
    function [value,isterminal,direction] = events(~, W)

        % Unpack the x and y position of the ball from the vector.
        xNow = W(1);  % meters
        yNow = W(2);  % meters
        
        % The value of the first event is the difference between the
        % current x coordinate and the distance to the wall; the value
        % of the second event is the difference between the current height
        % and the height of the Green Monster.
        value = [xNow - wallDistance; yNow - groundHeight];
        
        % Terminate when either condition is met.
        isterminal = [1; 1];
        
        % As long as x is increasing (for the first event) or y is
        % decreasing (for the second).
        direction = [1; -1];
    end
end

