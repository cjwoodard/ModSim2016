% FIND_TIME_UNTIL_SOBER  Simulate the alcohol model and find the time
%   (in hours) until the blood alcohol concentration drops below a given
%   threshold.

function res = find_time_until_sober(S0, d, k_a, k_e, threshold)

    initialS = S0;      % initial concentration in the stomach (g / l)
    initialB = 0;       % initial concentration in the lean body mass (g / l)                    

    initialTime = 0;    % time at start of simulation (hours)
    finalTime = 12;     % time at end of simulation (hours)

    % Construct the vectors we need to call ode45.
    timeSpan = [initialTime, finalTime];
    Y0 = [initialS, initialB];
    
    % Construct an anonymous function handle and event structure.
    dYdt = @(ti, Yi) alcohol_flows_ode45(ti, Yi, d, k_a, k_e);
    options = odeset('Events', @events, 'RelTol',1e-10, 'AbsTol',1e-12);
    
    % Simulating the model is still a one-liner.
    [~, ~, te] = ode45(dYdt, timeSpan, Y0, options);

    % If an event occurred, return the time of the event. Otherwise return
    % NaN to indicate either that the subject didn't get sober within the
    % time window, or didn't get drunk enough in the first place.
    if (length(te) == 1)
        res = te;
    else
        res = NaN;
    end
    
    
    % NEW: Event function.
    % (See Cat Book 11.1 and the MATLAB documentation for odeset.)
    function [value, isterminal, direction] = events(~, Y)
        
        % The value we are interested in is the difference between the
        % current BAC (stock 2) and the given threshold.
        value = Y(2) - threshold;

        % We are only interested in events in which we cross the threshold
        % on a downward slope (the negative direction).
        direction = -1;
        
        % Stop the integration after the event.
        isterminal = 1;
    end
end