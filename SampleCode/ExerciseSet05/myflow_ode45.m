% MYFLOW_ODE45  An example of a flow function that plays nicely with
% ode45 (and shows how to pass parameters other than the current stock).

function res = myflow_ode45(~, currentEnergy, environmentalTemperature, ...
    heatCapacityOfCoffee, emissivityOfCoffee, areaOfSurface)

    % Two bits of "magic" above that are worth noting:
    %
    % 1) The tilde ("~") stands for a function argument that we don't use.
    % For Euler's method, this is unnecessary -- we could just pass the
    % current energy and the rest of the model parameters. For ode45, the
    % flow function needs to take exactly two arguments: the current time
    % and the current stock value. Since our flow function doesn't actually
    % depend on time, we use ~ instead of a variable name like currentTime.
    %
    % 2) The ellipses ("...") tell MATLAB to continue the current
    % statement on the next line.

    % Here's another constant we'll need for this particular flow
    % function. (It's fine to define it here since it's not used
    % elsewhere in the model.)
    sigma = 5.67e-8;         % W/(m^2*K^4) (Stefan-Boltzmann constant)
    
    % Compute the current temperature.
    currentTemperature = energyToTemperature(currentEnergy, ...
        heatCapacityOfCoffee);
    
    % Now let's compute the magnitude of the radiation flow (in Watts)
    % through the top of the mug.
    radiationFlowOut = emissivityOfCoffee * sigma * areaOfSurface ...
        * currentTemperature^4;
    
    % And let's not forget the power absorbed from the environment (see
    % p. 17 of the Introduction to Thermal Systems reading).
    absorptivityOfCoffee = emissivityOfCoffee;
    radiationFlowIn = absorptivityOfCoffee * sigma * areaOfSurface ...
        * environmentalTemperature^4;
    
    % So our net flow is the difference betwen them, which should be
    % negative if the coffee is hotter than the environment.
    res = radiationFlowIn - radiationFlowOut;
end
