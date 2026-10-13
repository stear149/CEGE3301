%--------------------------------------------------------------------------
% Main()
%
% Arguments:
%
% Returns:
%   Head at Nodes
%   Total Flow Assuming k = 0.01 cm/s
%
% Notes:
%   This function calculates and visualizes the head distribution over 
%   a specified area.
% 
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   12 October 2026
% 
%--------------------------------------------------------------------------

L = 5; % [m]
H = 3; % [m]

delta_h = 1; % [m]
delta = 1; % [m]

k = 0.01; % [cm/s]

xCoordinates = 0:delta:L;
yCoordinates = 0:delta:H;
[nX, nY] = deal(numel(xCoordinates), numel(yCoordinates));
head = zeros(nY, nX);

% Dirichlet Bounds (East/West) (Int Conditions)
H_int = 1;                                  % This could be a user input.
H_fin = H_int - delta_h;

head(:, 1) = H_int;
head(:, end) = H_fin;

