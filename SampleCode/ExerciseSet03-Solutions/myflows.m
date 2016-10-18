% MYFLOWS  Example net flow function for a two-stock model.
%   res = myflows(stocks) returns a column vector containing the net
%   flows for each of two stocks, which are passed to the function
%   as a vector.

% This function actually implements the flows for the leaky bucket
% model described on p. 7 of the September 12 tutorial on Numerical
% Solutions of Differential Equations. You should, of course, replace
% the stocks, parameters, and flow functions appropriately!

function res = myflows(stocks)

    % Unpack the stocks from the vector.
    B1 = stocks(1);     % water level in bucket 1 (liters)
    B2 = stocks(2);     % water level in bucket 2 (liters)

    % Define the model parameters.
    c = 0.2;      % rate constant for flow from B1 to B2 (units)
    d = 0.1;      % rate constant for flow from B2 to sink (units)
    
    % Compute each net flow as a function of the current stocks.
    % (Obviously you should use sensible flow expressions!)
    B1_flow = -(c * B1);
    B2_flow = (c * B1) - (d * B2);
    
    % Now pack the flows into a column vector and return it.
    res = [B1_flow ; B2_flow];

    % Why a column vector instead of a row vector? (In other words,
    % why put a semicolon between B1 and B2 instead of a comma?)    
    % For our present purposes, it doesn't matter. Later on, however,
    % our flow functions will be called "automagically" by MATLAB's ODE
    % solvers (e.g., ode45), and you'll need to return a column vector
    % in order for them to work -- so we're promoting that habit now.
end
