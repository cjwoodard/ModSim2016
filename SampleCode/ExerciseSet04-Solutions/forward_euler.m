function [T, Y] = forward_euler(flowFunction, timeSpan, Y0)
% FORWARD_EULER  Solve a system of ordinary differential equations
%   (interpreted as stocks and flows) by the forward Euler method.
%   [T, Y] = forward_euler(flowFunction, timeSpan, Y0) accepts a flow
%   function as a function handle, along with a time span (specified as a
%   range of times at which to compute the stock values, e.g., 0:0.1:10)
%   and a vector of initial stocks. It returns a column vector of time
%   values and a matrix (or a column vector, for a single stock) of stocks
%   evaluated at the corresponding times. [Inspired by John Geddes!]

    % Use the input vectors to determine the number of times and stocks.
    numTimes = length(timeSpan);             % number of time points
    numStocks = length(Y0);                  % number of stock variables
    
    % Initialize the return values.
    T = transpose(timeSpan);                 % make a column vector
    Y = [Y0; zeros(numTimes-1, numStocks)];  % works for multiple stocks!

    % And now our old friend, the Euler loop ...
    for i = 2:numTimes
        dt = T(i) - T(i-1);                  % time difference
        prevStocks = Y(i-1, :);              % previous stock values
        
        % Evaluate the flow function at the previous stock values.
        % (We haven't seen this in the Cat Book, but it's not scary --
        % try "help feval".)
        flows = feval(flowFunction, prevStocks);
        
        % Now update the stock matrix -- just as we've done before, but
        % allowing for multiple stocks. (Note that we expect the flows
        % to be returned as column vectors; again, this is to make it
        % easier to "swap in" MATLAB's solver functions later.)
        Y(i, :) = prevStocks + (transpose(flows) .* dt);
    end
end