%--------------------------------------------------------------------------
% ShapeFactor(Q, k, h_in, h_out)
%
% Arguments:
%   Q      - Flow rate
%   k      - Hydraulic conductivity
%   h_in   - Inlet hydraulic head
%   h_out  - Outlet hydraulic head
%
% Returns:
%   alpha  - Shape factor
%
% Notes:
%   This function calculates the shape factor from the flow rate,
%   hydraulic conductivity, and head difference.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   5 November 2026
% 
%--------------------------------------------------------------------------
function [alpha] = ShapeFactor(Q, k, h_in, h_out)
    alpha_half = Q /( k * (h_in - h_out));
    alpha  = (1/2) * alpha_half;
end