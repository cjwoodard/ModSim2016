% Simulates the change in alcohol stocks using Euler's method.
% (Alternative version that makes more extensive use of vectors.)

initialS = 0.878;   % initial concentration in the stomach (g / l)
                    % (obtained from paper: Table 1, Subj. 9, Repl. 2)

initialB = 0;       % initial concentration in the lean body mass (g / l)                    

initialTime = 0;    % time at start of simulation (hours)
finalTime = 7;      % time at end of simulation (hours)
dt = 0.1;           % simulation time step (hours)

% Compute the number of time steps required. (To see why we need the
% floor function, try omitting it and choosing a time step that doesn't
% divide evenly into finalTime.)
N = floor((finalTime - initialTime) / dt);

% Pre-allocate a column vector for each of the stocks, and set its
% first element to the initial value defined above.
S = [initialS; zeros(N, 1)];
B = [initialB; zeros(N, 1)];

% Create another column vector to hold the time of each stock observation;
% note that it has the same dimensions as our stock time series vector.
t = [initialTime; zeros(N, 1)];

% Once again, the forward Euler loop. (Note that we iterate using a
% counter, starting at 2, because we need it as an index into the
% stock and time vectors.)
for i = 2:N+1
    
    % We still only have one flow function to invoke, but now we pass it
    % a vector containing the previous values of both stocks.
    flows = alcohol_flows([S(i-1), B(i-1)]);
        
    % Then we update each stock vector based on the previous value of
    % the stock plus the current flow times dt (yay, Euler!)
    S(i) = S(i-1) + (flows(1) * dt);
    B(i) = B(i-1) + (flows(2) * dt);
    
    % And we also have to update the time vector ...
    t(i) = t(i-1) + dt;
end

% Now let's plot both of the vectors. (Note that we're using hold on
% to overlay the vectors on the same graph -- this allows us to specify
% different markers for each time series.)
hold on
plot(t, S, 'bo');  % remove 'bo' to draw a smooth curve
plot(t, B, 'rx');  % remove 'rx' to draw a smooth curve