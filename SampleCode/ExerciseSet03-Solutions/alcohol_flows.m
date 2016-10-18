% ALCOHOL_FLOWS  Net flow of alcohol concentration.
%   res = alcohol_flows(stocks) returns a column vector containing the net
%   flow of alcohol concentration (in grams per liter per hour, assuming
%   constant volume) for each of the two stocks in the model (stomach
%   and lean body mass). The flow parameters (drinking rate and constants
%   for absorption and elimination) are defined inside the function.

function res = alcohol_flows(stocks)

    % Unpack the stocks from the vector.
    S = stocks(1);     % conc. of alcohol in the stomach (g / l)
    B = stocks(2);     % conc. of alcohol in the lean body mass (g / l)

    % Define the model parameters.
    d = 0;       % drinking rate (g / l / hr)
    k_a = 1.5;   % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
    k_e = 0.8;   % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)                 
    
    % Compute each net flow as a function of the current stocks.
    S_flow = d - (k_a * S);
    B_flow = (k_a * S) - (k_e * B);
    
    % Now pack the flows into a column vector and return it.
    % (See myflows.m for an explanation of why we use a column vector.)
    res = [S_flow ; B_flow];
end
