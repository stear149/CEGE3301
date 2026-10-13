%--------------------------------------------------------------------------
% Closed_Form()
%
% Arguments:
%   heads   - Inlet and outlet head values
%   k       - Hydraulic conductivity
%   beta    - Width convergence parameter
%   width   - Inlet and outlet widths
%   l       - Domain length
%   x_pos   - Positions at which to calculate head
%
% Returns:
%   Q       - Flow rate [m^3/a]
%   h       - Head distribution at x_pos [m]
%
% Notes:
%   Calculates the closed-form flow rate and head distribution for a
%   converging-width domain.
% 
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function [Q, h] = Closed_Form(heads, k, beta, width, l, x_pos)
    w_in = width(1,1);
    w_out = width(1,2);
    h_in = heads(1,1);
    h_out = heads(1,2);

    Q = ((h_out - h_in) * beta * k) / (log(1-((beta * l) / w_in)));
    h = h_in + (Q / (beta * k)) * log(1 - ((beta .* x_pos) ./ w_in));


end