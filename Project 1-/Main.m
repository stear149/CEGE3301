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

delta_x = 1;    % [m]
delta_y = 1;    % [m]
delta_h = 0.5;  % [m]                       % This could be a user input.

delta = [delta_x, delta_y,delta_h];

k = 0.01; % [cm/s]

xCoordinates = 0:delta_x:L;
yCoordinates = 0:delta_y:H;
[nX, nY] = deal(numel(xCoordinates), numel(yCoordinates));
head = zeros(nY, nX);

% Dirichlet Bounds (East/West) (Int Conditions)
H_int = 1;                                  % This could be a user input.
H_fin = H_int - delta_h;

head(:, 1) = H_int;
head(:, end) = H_fin;

head = Matrix(head);
