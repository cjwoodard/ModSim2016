% pendulum()
% Simulate the motion of the extensible pendulum.

function pendulum()
    
    % Simulation settings    
    initialTime = 0;         % start time of the simulation (seconds)
    finalTime = 5;           % end time of the simulation (seconds)

    % Initial state
    S0 = [-1; -1; 0; 0];
    
    % Here we go ...
    [~, S] = ode45(@pendulum_derivs, [initialTime finalTime], S0);
        
    % Unpack and plot!
    X = S(:,1);
    Y = S(:,2);
    comet(X, Y);
end