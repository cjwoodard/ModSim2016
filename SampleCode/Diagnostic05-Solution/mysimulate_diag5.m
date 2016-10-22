% MYSIMULATE_DIAG5  An example of a simulation function that uses ode45
%   (modified for Diagnostic 5 -- now with an ODE event!).

function res = mysimulate_diag5(initialTime, finalTime, targetTemp)

    %% Model parameters

    initialTemperature = 370;            % K
    environmentalTemperature = 290;      % K

    radiusOfCup = 4 / 100;               % m (converted from cm)
    heightOfCoffeeInCup = 15 / 100;      % m (converted from cm)

    heatTransferCoefficient = 100;       % W/(m^2*K) [NEW]

    specificHeatOfCoffee = 4186;         % J/(kg*K) (same as water)
    densityOfCoffee = 1000;              % kg/m^3 (same as water)

    %% Calculated variables

    areaOfSurface = pi * radiusOfCup^2;                         % m^2
    volumeOfCoffee = areaOfSurface * heightOfCoffeeInCup;       % m^3
    massOfCoffee = volumeOfCoffee * densityOfCoffee;            % kg
    heatCapacityOfCoffee = massOfCoffee * specificHeatOfCoffee; % J/K
    initialEnergy = temperatureToEnergy(initialTemperature, ... % J
        heatCapacityOfCoffee);
    
    %% Now invoke ode45 and convert the resulting energies to temperature.

    dUdt = @(ti, Ui) myflow_diag5(ti, Ui, environmentalTemperature, ...
            heatCapacityOfCoffee, heatTransferCoefficient, areaOfSurface);

    % NEW: Set options before calling ode45, then return the time
    % of the event (if it occurs).
    options = odeset('Events', @events);
    [~, ~, res] = ode45(dUdt, [initialTime finalTime], initialEnergy, options);


    % NEW: Event function.
    % (See Cat Book 11.1 and the MATLAB documentation for odeset.)
    function [value, isterminal, direction] = events(~, U)

        % Compute the current temperature.
        currentTemp = energyToTemperature(U, heatCapacityOfCoffee);

        % The "value" of the event is the difference between the
        % current and target temperatures.
        value = currentTemp - targetTemp;

        % Stop the integration if the value crosses zero.
        isterminal = 1;

        % Can approach from either direction.        
        direction = 0;
    end
end
