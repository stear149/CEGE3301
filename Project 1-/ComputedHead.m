%--------------------------------------------------------------------------
% ComputedHead()
%
% Arguments:
%
% Returns:
%
% Notes:
%   This function solves for the head using a closed-form solution along
%   the top stream line of the given area.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   16 October 2026
% 
%--------------------------------------------------------------------------
function [h_exact] = ComputedHead(L, H, delta, H_int, k, Q_exact)
    A = H * 1;      %[m]
    k = k/100;      %[m/s]
    
    xCoordinates = 0:delta(1):L;
    
    h_exact = H_int - (Q_exact/(k * A)) .* xCoordinates;
end