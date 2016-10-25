% SIMULATE_COOLING_TIME  Simulate the coffee cooling model, returning
%   the time (in seconds) required to cool the mixture to a specified
%   temperature (in K).

function res = simulate_cooling_time(initialTime, finalTime, creamTime, ...
    targetTemperature)

    %% Model parameters

    initialTemperature = 370;            % K
    environmentalTemperature = 290;      % K

    radiusOfCup = 4 / 100;               % m (converted from cm)
    heightOfCoffeeInCup = 15 / 100;      % m (converted from cm)

    thicknessOfCupWalls = 0.7 / 100;     % m (converted from cm)
    thermalConductivityOfCupWalls = 1.5; % W/(m*K)
    % Source: http://www.engineeringtoolbox.com/thermal-conductivity-d_429.html
    % (see "porcelain")

    creamTemperature = 275;              % K
    volumeOfCream = 100 / 1e6;           % m^3 (converted from ml)

    specificHeatOfCoffeeAndCream = 4186; % J/(kg*K) (same as water)
    densityOfCoffeeAndCream = 1000;      % kg/m^3 (same as water)

    %% Calculated variables

    % Before cream ...
    areaOfCupSurface = pi * radiusOfCup^2;                      % m^2
    areaOfCoffeeConduction = (2*pi * radiusOfCup * heightOfCoffeeInCup) + ...
        areaOfCupSurface;                                       % m^2
    volumeOfCoffee = areaOfCupSurface * heightOfCoffeeInCup;    % m^3
    
    massOfCoffee = volumeOfCoffee * densityOfCoffeeAndCream;    % kg
    heatCapacityOfCoffee = massOfCoffee * ...
        specificHeatOfCoffeeAndCream;                           % J/K
    initialEnergyOfCoffee = temperatureToEnergy(initialTemperature, ...
        heatCapacityOfCoffee);                                  % J
    
    % After cream ...
    heightOfCreamInCup = volumeOfCream / areaOfCupSurface;      % m
    newAreaOfConduction = areaOfCoffeeConduction + (2*pi * ...
        radiusOfCup * heightOfCreamInCup);                      % m^2
    
    massOfCream = volumeOfCream * densityOfCoffeeAndCream;      % kg
    heatCapacityOfCream = massOfCream * ...
        specificHeatOfCoffeeAndCream;                           % J/K
    initialEnergyOfCream = temperatureToEnergy(creamTemperature, ...
        heatCapacityOfCream);                                   % J

    % We'll also need the heat capacity of the mixture, which is just
    % the sum of the heat capacities of the two liquids (in J)
    heatCapacityOfMixture = heatCapacityOfCoffee + heatCapacityOfCream;
    
    %% COOLING PROCESS

    % First, some simple bounds checking.
    if (creamTime < initialTime)
        error('creamTime cannot be less than initialTime.');
    elseif (creamTime > finalTime)
        error('creamTime cannot be greater than finalTime.');
    end

    % Now let's handle the edge cases. (As with last week's solution,
    % it may be easier to understand these once you understand the
    % interior case below.)
    if (creamTime == finalTime)
        [~, U] = cool1([initialTime finalTime], initialEnergyOfCoffee, ...
            heatCapacityOfCoffee, areaOfCoffeeConduction);
        energyAfterAddingCream = U(end) + initialEnergyOfCream;
        tempAfterAddingCream = energyToTemperature(energyAfterAddingCream, ...
            heatCapacityOfMixture);
        if (tempAfterAddingCream <= targetTemperature)
            res = finalTime;     % hit the target at or before the end
        else
            res = Inf;           % didn't hit the target at all
        end
        return;
    elseif (creamTime == initialTime)
        energyAfterAddingCream = initialEnergyOfCoffee + initialEnergyOfCream;
        tempAfterAddingCream = energyToTemperature(energyAfterAddingCream, ...
            heatCapacityOfMixture);
        if (tempAfterAddingCream <= targetTemperature)
            res = initialTime;   % hit the target right at the start
        else
            [~, ~, eventTime] = cool2([creamTime finalTime], ...
                energyAfterAddingCream, heatCapacityOfMixture, ...
                newAreaOfConduction, targetTemperature);
            if (eventTime > 0)
                res = eventTime;  % hit the target while cooling
            else
                res = Inf;        % didn't hit the target at all
            end
        end
        return;
    end
    
    % If we're still here, we're in the interior case
    % (initialTime < creamTime < finalTime) ...
    
    % Step 1 -- coffee alone. (Now we can throw away the time vector.)
    [~, U1] = cool1([initialTime creamTime], initialEnergyOfCoffee, ...
        heatCapacityOfCoffee, areaOfCoffeeConduction);

    % NEW: Compute the temperature and see if we've hit the target.
    energyAfterAddingCream = U1(end) + initialEnergyOfCream;
    tempAfterAddingCream = energyToTemperature(energyAfterAddingCream, ...
        heatCapacityOfMixture);
    
    % NEW: If we've hit (or overshot) the target temperature, we return
    % creamTime because that's the earliest we have cream *and* a drinkable
    % beverage (i.e., we assume that the drinker wants the cream but
    % doesn't care if the mixture is cooler than the target temperature).
    if (tempAfterAddingCream <= targetTemperature)
        res = creamTime;
        return;           % no need to continue -- we're done!
    end

    % Step 2 -- continue cooling the coffee-and-cream mixture. (Now using a
    % modified cooling function that stops if we hit the target temperature.)
    [~, ~, eventTime] = cool2([creamTime finalTime], energyAfterAddingCream, ...
        heatCapacityOfMixture, newAreaOfConduction, targetTemperature);
    
    % NEW: If we get to the target temperature after the cream is added,
    % return that time. Otherwise return infinity to indicate that we
    % never got there.
    if (eventTime > 0)
        res = eventTime;
    else
        res = Inf;
    end

    
    %% COOLING FUNCTION (BEFORE CREAM -- same as before)
    function [t, U] = cool1(timeSpan, currentEnergy, ...
            currentHeatCapacity, currentAreaOfConduction)
        
        % Our now-familiar anonymous function.
        dUdt = @(ti, Ui) coffee_flow(ti, Ui, environmentalTemperature, ...
            currentHeatCapacity, thicknessOfCupWalls, ...
            thermalConductivityOfCupWalls, currentAreaOfConduction);

        % And our friendly call to ode45.
        [t, U] = ode45(dUdt, timeSpan, currentEnergy);
    end

    %% COOLING FUNCTION (AFTER CREAM -- with ODE event)
    function [t, U, evTime] = cool2(timeSpan, currentEnergy, ...
            currentHeatCapacity, currentAreaOfConduction, targetTemp)
        
        % Exactly the same as above.
        dUdt = @(ti, Ui) coffee_flow(ti, Ui, environmentalTemperature, ...
            currentHeatCapacity, thicknessOfCupWalls, ...
            thermalConductivityOfCupWalls, currentAreaOfConduction);

        % NEW: Set options before calling ode45, then return the time
        % of the event (if it occurs).
        options = odeset('Events', @events);
        [t, U, evTime] = ode45(dUdt, timeSpan, currentEnergy, options);
        
        % NEW: Event function.
        % (See Cat Book 11.1 and the MATLAB documentation for odeset.)
        function [value, isterminal, direction] = events(~, U)

            % Compute the current temperature.
            currentTemp = energyToTemperature(U, currentHeatCapacity);

            % The "value" of the event is the difference between the
            % current and target temperatures.
            value = currentTemp - targetTemp;

            % Stop the integration if the value crosses zero.
            isterminal = 1;

            % Can approach from either direction.        
            direction = 0;
        end
    end
end
