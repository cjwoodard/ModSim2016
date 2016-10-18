% FIND_PEAK_CONCENTRATION  Simulate the alcohol model and find the peak of
%   the lean body mass concentration. Returns the time and level of the
%   peak (in hours and g / l). See simulate_alcohol_ode45.m for parameters.

function [peakTime, peakLevel] = find_peak_concentration(S0, d, k_a, k_e)

    initialS = S0;      % initial concentration in the stomach (g / l)
    initialB = 0;       % initial concentration in the lean body mass (g / l)                    

    initialTime = 0;    % time at start of simulation (hours)
    finalTime = 12;     % time at end of simulation (hours)

    % Construct the vectors we need to call ode45.
    timeSpan = [initialTime, finalTime];
    Y0 = [initialS, initialB];
    
    % Construct an anonymous function handle and event structure.
    dYdt = @(ti, Yi) alcohol_flows_ode45(ti, Yi, d, k_a, k_e);
    options = odeset('Events', @events);
    
    % Note that we can set lower tolerances for greater accuracy:
    %options = odeset('Events', @events, 'RelTol',1e-8, 'AbsTol',1e-10);
    %options = odeset('Events', @events, 'RelTol',1e-13, 'AbsTol',1e-15);
    
    % Simulating the model is still a one-liner.
    [~, ~, te, Ye] = ode45(dYdt, timeSpan, Y0, options);

    % Return the peak time and peak level of the LBM.
    peakTime = te;
    peakLevel = Ye(2);

    
    % NEW: Event function.
    % (See Cat Book 11.1 and the MATLAB documentation for odeset.)
    function [value, isterminal, direction] = events(T, Y)

        % Invoke the flow function to obtain the instantaneous net
        % flows (i.e., derivatives) for both stocks.
        flows = alcohol_flows_ode45(T, Y, d, k_a, k_e);
        
        % The "value" of the event is the current net flow for the lean
        % body mass. If it's zero, we're at a maximum or a minimum.
        value = flows(2);

        % At a maximum, the value is decreasing after it crosses zero.
        direction = -1;
        
        % Stop the integration after the event (i.e., we're only looking
        % for one peak).
        isterminal = 1;
    end
end