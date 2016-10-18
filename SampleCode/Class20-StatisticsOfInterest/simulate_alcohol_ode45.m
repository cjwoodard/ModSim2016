% SIMULATE_ALCOHOL_ODE45  Simulate the alcohol model.
%   [T, Y] = simulate_alcohol_ode45(S0, d, k_a, k_e) returns a column
%   vector of times and a matrix of corresponding stock values (columns of
%   alcohol concentration in the stomach and lean body mass, respectively;
%   both in grams per liter). The function takes four parameters: the
%   initial concentration in the stomach (S), the drinking rate (d), and
%   the two rate parameters of the flow function (k_a and k_e).

% Suppress warning messages:
%#ok<*NOPRT,*NASGU>

function [T, Y] = simulate_alcohol_ode45(S0, d, k_a, k_e)

    initialS = S0;      % initial concentration in the stomach (g / l)
    initialB = 0;       % initial concentration in the lean body mass (g / l)                    

    initialTime = 0;    % time at start of simulation (hours)
    finalTime = 8;     % time at end of simulation (hours)

    % Construct the vectors we need to call ode45.
    timeSpan = [initialTime, finalTime];
    Y0 = [initialS, initialB];
    
    % Construct an anonymous function handle.
    dYdt = @(ti, Yi) alcohol_flows_ode45(ti, Yi, d, k_a, k_e);
    
    % Simulating the model is still a one-liner.
    [T, Y] = ode45(dYdt, timeSpan, Y0);
    
    % Here is our BAC time series (for reference below).
    BAC = Y(:,2);
        
    % Let's pull out a few statistics of interest (quick and dirty!) ...
    averageBAC = trapz(T, BAC) / (finalTime - initialTime)
    finalBAC = BAC(end)
    intervalOfIntoxication = T((BAC>0.5)); % note the fixed threshold
    if (~isempty(intervalOfIntoxication))
        startDrunk = intervalOfIntoxication(1);
        endDrunk = intervalOfIntoxication(end);
        durationOfDrunkenness = endDrunk - startDrunk
        timeUntilSober = endDrunk - initialTime
    end
    
    % NOTE: Why do we call these "quick and dirty" statistics? Because
    % we are computing them outside the ODE solver, which means the only
    % points we have available are the ones the solver returns to us;
    % the actual points on the curve that we are interested in may not
    % be among these points. To ensure that our statistics have the
    % same accuracy as the time series computed by the solver, we need
    % to use ODE events, as illustrated in the "find" functions.
end