% SIMULATE_COFFEE_CREAM  Simulate the coffee cooling model with cream.
%   [t, T] = simulate_coffee_cream(initialTime, finalTime, creamTime)
%   returns a column vector of times (in seconds) and a column vector of
%   corresponding temperatures (in Kelvin). The function takes the initial
%   and final time to be simulated (in seconds) as parameters, as well as
%   the time at which cream is added.

function [t, T] = simulate_coffee_cream(initialTime, finalTime, creamTime)

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
    combinedAreaOfConduction = areaOfCoffeeConduction + (2*pi * ...
        radiusOfCup * heightOfCreamInCup);                      % m^2
    
    massOfCream = volumeOfCream * densityOfCoffeeAndCream;      % kg
    heatCapacityOfCream = massOfCream * ...
        specificHeatOfCoffeeAndCream;                           % J/K
    initialEnergyOfCream = temperatureToEnergy(creamTemperature, ...
        heatCapacityOfCream);                                   % J
    
    % We'll also need the heat capacity of the mixture, which is just
    % the sum of the heat capacities of the two liquids (in J)
    heatCapacityOfMixture = heatCapacityOfCoffee + heatCapacityOfCream;
    
    %% NEW: COOLING PROCESS
    
    % First, some simple bounds checking.
    if (creamTime < initialTime)
        error('creamTime cannot be less than initialTime.');
    elseif (creamTime > finalTime)
        error('creamTime cannot be greater than finalTime.');
    end
    
    % Now let's handle the edge cases (see below for explanations).
    if (creamTime == finalTime)
        [t, U] = cool([initialTime finalTime], initialEnergyOfCoffee, ...
            heatCapacityOfCoffee, areaOfCoffeeConduction);
        T = energyToTemperature(U, heatCapacityOfCoffee);
        return;
    elseif (creamTime == initialTime)
        energyAfterAddingCream = initialEnergyOfCoffee + initialEnergyOfCream;
        [t, U] = cool([initialTime finalTime], energyAfterAddingCream, ...
            heatCapacityOfMixture, combinedAreaOfConduction);
        T = energyToTemperature(U, heatCapacityOfMixture);
        return;
    end
    
    % If we're still here, we're in the interior case
    % (initialTime < creamTime < finalTime) ...
    
    % Step 1 -- coffee alone. (As before, up to creamTime.)
    [t1, U1] = cool([initialTime creamTime], initialEnergyOfCoffee, ...
        heatCapacityOfCoffee, areaOfCoffeeConduction);
    T1 = energyToTemperature(U1, heatCapacityOfCoffee);

    % Step 2 -- continue cooling the coffee-and-cream mixture. (Note the
    % starting stock value -- U1(end) means "last element of U1" -- as
    % well as the updated heat capacity and area of conduction.)
    energyAfterAddingCream = U1(end) + initialEnergyOfCream;
    [t2, U2] = cool([creamTime finalTime], energyAfterAddingCream, ...
        heatCapacityOfMixture, combinedAreaOfConduction);
    T2 = energyToTemperature(U2, heatCapacityOfMixture);
        
    % Finally, glue the time and temperature vectors together. (We write
    % them vertically as a visual reminder that they are column vectors;
    % MATLAB doesn't care how we write them, as long as we use semicolons
    % between the two parts.)
    t = [t1 ;
         t2];
    T = [T1 ;
         T2];

    % And once again, we return the column vectors t and T. (No need to
    % do anything else here.)
    
    
    %% NEW: COOLING FUNCTION
    function [t, U] = cool(timeSpan, currentEnergy, ...
            currentHeatCapacity, currentAreaOfConduction)
        
        % Since we need to call ode45 more than once, it's a bit cleaner
        % to wrap the details in this nested function. Note that we pass
        % the parameters that change as arguments to the cool() function,
        % and take the ones that don't from the enclosing function
        % (environmentalTemperature, etc.).
        
        % MATLAB magic here (same as last week).
        dUdt = @(ti, Ui) coffee_flow(ti, Ui, environmentalTemperature, ...
            currentHeatCapacity, thicknessOfCupWalls, ...
            thermalConductivityOfCupWalls, currentAreaOfConduction);

        % And another drum roll ... ode45!
        [t, U] = ode45(dUdt, timeSpan, currentEnergy);
    end
end
