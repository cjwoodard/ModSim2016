%% res = temperatureToEnergy(T, heatCapacity)
% Convert temperature (K) to internal energy (J) for a substance with
% a given heat capacity (J/K). We do this by multiplying the temperature
% by the heat capacity.
function res = temperatureToEnergy(T, heatCapacity)
    res = T .* heatCapacity;
end