% ALCOHOL_FLOWS_ODE45  Net flow of alcohol concentration.
%   res = alcohol_flows(stocks) returns a column vector containing the net
%   flow of alcohol concentration (in grams per liter per hour, assuming
%   constant volume) for each of the two stocks in the model (stomach
%   and lean body mass). The flow parameters (drinking rate, in g / l/ hr,
%   and constants for absorption and elimination, in 1 / hr) are passed as
%   arguments to the function.

function res = alcohol_flows_ode45(~, stocks, d, k_a, k_e)

    % Unpack the stocks from the vector.
    S = stocks(1);     % conc. of alcohol in the stomach (g / l)
    B = stocks(2);     % conc. of alcohol in the lean body mass (g / l)
    
    % Compute each net flow as a function of the current stocks.
    S_flow = d - (k_a * S);
    B_flow = (k_a * S) - (k_e * B);
    
    % Now pack the flows into a column vector and return it.
    res = [S_flow ; B_flow];
end
