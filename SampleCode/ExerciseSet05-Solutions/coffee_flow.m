% COFFEE_FLOW  Net flow of heat energy from the coffee to the environment
%   (in Watts), as a function of the current internal energy (in Joules)
%   and five additional parameters: environmental temperature (in K),
%   heat capacity of the coffee in the mug (J/K), thickness of the cup
%   walls, thermal conductivity of the cup walls (W/(m*K)), and area of
%   conduction (m^2).

function res = coffee_flow(~, currentEnergy, environmentalTemperature, ...
    heatCapacityOfCoffee, thicknessOfCupWalls, ...
    thermalConductivityOfCupWalls, areaOfConduction)

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

    % Okay, let's compute the temperature gradient. Note that we're
    % assuming the environment remains at a constant temperature, but
    % the current temperature of the coffee is a function of its
    % internal energy. We define the gradient as the difference between
    % the current temperature of the coffee and the environment, which
    % will be a positive number in the cases we are interested in.
    deltaTemperature = energyToTemperature(currentEnergy, ...
        heatCapacityOfCoffee) - environmentalTemperature;        
    
    % Now let's compute the magnitude of the conduction flow through the
    % wall of the cup. (We are ignoring the resistance between the outside
    % of the wall and the surrounding air.)
    conductionFlow = thermalConductivityOfCupWalls * areaOfConduction / ...
        thicknessOfCupWalls * deltaTemperature;
    
    % Finally, since conduction yields a heat flow that is opposite to
    % the temperature gradient (i.e., the coffee loses heat energy as it
    % cools), we return the negative of the magnitude computed above.
    res = -conductionFlow;
end
