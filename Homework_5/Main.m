%--------------------------------------------------------------------------
% Main Script
%
% Description:
%   Calculates and compares the hydraulic head distribution and discharge
%   using iterative, matrix, closed-form, and finite-difference methods.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------

% Domain & Fluid Properties
k = 3e-5;                  % Hydraulic conductivity [m/s]
l = 0.75;                  % Length [m]
h_in = 0.50;               % Inlet head [m]
h_out = 0;                 % Outlet head [m]
w_in = 0.15;               % Inlet width [m]
w_out = 0.10;              % Outlet width [m]

% Numerical Setup
delta_x = 0.075;           % Grid spacing [m]
accuracy = 1e-5;           % Convergence tolerance


% Derived Parameters & Geometry
heads = [h_in, h_out];
width = [w_in, w_out];
beta = (w_in - w_out) / l;    %[rad]

x_pos = 0:delta_x:l;
channelWidth = w_in - beta*x_pos;
N = numel(x_pos);

alpha = (beta * delta_x) ./ (2*channelWidth);


% Solve for the Iterative, Matrix, and Closed Form heads
h_itter = Loop(alpha,heads,accuracy);
h_matrix = Matrix(alpha,heads);
[Q_closed, h_closed] =  Closed_Form(heads, k, beta, width, l, x_pos);


% Compute Discharge [m^3/s]
[Q_FD, Q_FD_avg] = ComputeDischarge(h_matrix, channelWidth, k, delta_x);

% Visualize Results
Draw(x_pos, h_closed, h_itter, h_matrix, channelWidth, Q_closed, Q_FD_avg)

% Display Summary in Command Window
PrintResults(x_pos, h_matrix, h_closed, Q_FD_avg, Q_closed);