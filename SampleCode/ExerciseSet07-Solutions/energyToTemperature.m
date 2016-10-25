%% res = energyToTemperature(U, heatCapacity)
% Convert internal energy (J) to temperature (K) for a substance with
% a given heat capacity (J/K). We do this by dividing the energy by the
% heat capacity.
function res = energyToTemperature(U, heatCapacity)
    res = U ./ heatCapacity;
end
