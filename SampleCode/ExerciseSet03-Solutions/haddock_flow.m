% HADDOCK_FLOW  Net flow of haddock biomass.
%   res = haddock_flow(haddock) returns the net flow of haddock biomass
%   biomass (in metric tons / year) as a function of the current biomass
%   (haddock, in metric tons). The flow parameters (carrying capacity and
%   growth rate) are defined inside the function.

function res = haddock_flow(haddock)

    % Define the model parameters.
    K = 8.0e6;     % carrying capacity (metric tons)
    g = 0.09;      % growth rate (per year)

    % Compute the net flow as a function of the current stock.
    res = g * haddock * (1 - haddock / K);
end
