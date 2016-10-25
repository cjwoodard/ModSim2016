% FIND_HADDOCK_SATURATION  Find the time (in years) at which the haddock
% population becomes saturated (which we define as reaching 95% of its
% carrying capacity).

function res = find_haddock_saturation(timeSpan, H0, K, g)

    % Set up our derivative function as usual, passing parameters to the
    % flow function.
    dHdt = @(ti, Hi) haddock_flow2(ti, Hi, K, g);

    % Set up our options and invoke ode45, also as usual.
    options = odeset('Events', @events);
    [~, ~, te] = ode45(dHdt, timeSpan, H0, options);
    
    if isempty(te)
        res = NaN;
    else
        res = te;
    end
    
    
    % Finally, here is our event function.
    function [value, isterminal, direction] = events(~, H)

        % The "value" of the event is the difference between the
        % current stock and 95% of the carrying capacity.
        value = H - (0.95 * K);

        % Stop the integration if the value crosses zero.
        isterminal = 1;

        % Can approach from either direction.        
        direction = 0;
    end
end
