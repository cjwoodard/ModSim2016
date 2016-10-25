% HADDOCK_FLOW2  Net flow of haddock biomass (for in-class exercise).
%   res = haddock_flow2(haddock) returns the net flow of haddock biomass
%   (in metric tons / year) as a function of the current biomass (haddock,
%   in metric tons). The flow parameters (carrying capacity and growth
%   rate) are passed to the function as parameters.

function res = haddock_flow2(~, haddock, K, g)

    % Compute the net flow as a function of the current stock.
    res = g * haddock * (1 - haddock / K);
end
