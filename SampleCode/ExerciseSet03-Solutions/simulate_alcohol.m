% Simulates the change in alcohol stocks using Euler's method.

S = 0.878;        % initial concentration in the stomach (g / l)
                  % (obtained from paper: Table 1, Subj. 9, Repl. 2)

B = 0;            % initial concentration in the lean body mass (g / l)                    
                    
initialTime = 0;    % time at start of simulation (hours)
finalTime = 7;      % time at end of simulation (hours)
dt = 0.1;           % simulation time step (hours)

% Note that we only have to do this once at the beginning of the
% simulation to make all of the plot commands add points to the
% same graph.
hold on

% Here, once again, is the forward Euler loop -- note that we are now
% dealing with two stocks (and the associated packing and unpacking of
% vectors), but otherwise it should look pretty familiar.
for t = initialTime:dt:finalTime
    flows = alcohol_flows([S, B]);
    S = S + (flows(1) * dt);   % flows(1) refers to the flow of S
    B = B + (flows(2) * dt);   % flows(2) refers to the flow of B
    plot(t, S, 'bo');
    plot(t, B, 'rx');
end