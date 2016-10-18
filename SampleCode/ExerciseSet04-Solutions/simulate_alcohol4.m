% SIMULATE_ALCOHOL4  Simulate the alcohol model.
%   [T, Y] = simulate_alcohol4(S0, k_a, k_e) returns a column vector of
%   times and a matrix of corresponding stock values (columns of alcohol
%   concentration in the stomach and lean body mass, respectively; both
%   in grams per liter). The function takes three parameters: the
%   initial concentration in the stomach (S), and the two rate
%   parameters of the flow function (k_a and k_e).

function [T, Y] = simulate_alcohol4(S0, k_a, k_e)

    initialS = S0;      % initial concentration in the stomach (g / l)
    initialB = 0;       % initial concentration in the lean body mass (g / l)                    

    initialTime = 0;    % time at start of simulation (hours)
    finalTime = 7;      % time at end of simulation (hours)
    dt = 0.1;           % simulation time step (hours)

    % NEW: Construct the vectors we need to call forward_euler.
    timeSpan = initialTime:dt:finalTime;
    Y0 = [initialS, initialB];
    
    % NEW: Simulating the model is now a one-liner!
    [T, Y] = forward_euler(@alcohol_net_flows, timeSpan, Y0);

    % NEW: To make it easier to pass parameters to our flow function,
    % we include it here as a nested function (see Cat Book 10.1).
    function res = alcohol_net_flows(stocks)
        
        % Preconditions: This function assumes that two of the three
        % rate parameters (k_a and k_e) have been defined in the
        % enclosing function. Both are in units of 1 / hour.

        % Unpack the stocks from the vector.
        S = stocks(1);   % conc. of alcohol in the stomach (g / l)
        B = stocks(2);   % conc. of alcohol in the lean body mass (g / l)
   
        % Define the remaining model parameter.
        d = 0;           % drinking rate (g / l / hr)
        
        % Compute each net flow as a function of the current stocks.
        S_flow = d - (k_a * S);
        B_flow = (k_a * S) - (k_e * B);
    
        % Now pack the flows into a column vector and return it.
        res = [S_flow ; B_flow];
    end
end