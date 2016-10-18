function res = cubeseq(n)
% Returns the first n cubes as a vector.

% Preallocate a vector of zeros (see solutions to Adventure 2 exercises).
res = zeros(1, n);

for i = 1:n
    res(i) = i^3;
end
