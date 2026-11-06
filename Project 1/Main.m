%--------------------------------------------------------------------------
% GroundwaterFlow
%
% Description:
%   Computes the hydraulic head distribution and groundwater flow rates for
%   a rectangular aquifer using a finite-difference solution.
%
% Outputs:
%   Displays calculated and closed-form flow rates and the shape factor.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   5 November 2026
% 
%--------------------------------------------------------------------------
L = 10;         % [m]
H = 10;         % [m]

delta_x = 1;    % [m]
delta_y = 1;    % [m]

h_north = 2;    % [m]
h_west = 1;     % [m]

k = 0.01;       % [cm/s]
k = k/100;      % [m/s]

xCoordinates = 0:delta_x:L;
yCoordinates = 0:delta_y:H;
[nX, nY] = deal(numel(xCoordinates), numel(yCoordinates));
head = zeros(nY, nX);

head(1, :) = h_north;
head(:, 1) = h_west;

head = Matrix(head);

[Q_calc, Q_ClosedForm, q_out, q_ClosedForm] = FlowRate(head, k, [delta_x, delta_y]);

[alpha] = ShapeFactor(Q_calc, k, h_north, h_west);

Display(q_out, q_ClosedForm, xCoordinates, Q_calc, Q_ClosedForm, alpha)