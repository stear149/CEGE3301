%--------------------------------------------------------------------------
% Loop()
%
% Iteratively solves for hydraulic head values along a one-dimensional loop.
%
% Arguments:
%   alpha    - Node coefficients
%   heads    - Boundary head values
%   accuracy - Convergence tolerance
%
% Returns:
%   h        - Head values at all nodes [m]
%
% Notes:
%   Iteration continues until the maximum head change is below accuracy.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function [h] = Loop(alpha, heads, accuracy)
    running = true;
    N = numel(alpha);
    h = zeros(1,N);
    
    h(1,1) = heads(1,1);
    h(1,N) = heads(1,2);

    h_new = h;

    counter = 0;

    while running
        for i = 2:N-1
            h_new(1,i) = ((1 + alpha(1,i))*h(1,i-1) + ...
                (1 - alpha(1,i))*h(1,i+1)) / 2;
        end
        h_dif = max(abs(h_new - h));
        h = h_new;

        running = h_dif > accuracy;

        counter = counter +1;
    end
    disp(counter)
end