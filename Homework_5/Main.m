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


% Define Given Constants
k = 3*10^-5;                %[m/s]
l = .75;                    %[m]

h_in = .50;                 %[m]
h_out = 0;                  %[m]

w_in = .15;                 %[m]
w_out = .10;                %[m]

delta_x = .075;             %[m]

% Self defed Consts
N = 11;
accuracy = 10^-6;


% Define Caculated Constants
heads = [h_in,h_out];
width = [w_in, w_out];

beta = (w_in - w_out)/l;    %[rad]

x_pos = 0:delta_x:l;
channelWidth = w_in - beta*x_pos;

alpha = zeros(1,N);
for i = 1:N
    alpha(1,i) = (beta * delta_x)/(2*channelWidth(1,i));
end


% Solve for the Iterative, Matrix, and Closed Form heads
h_itter = Loop(alpha,heads,accuracy);
h_matrix = Matrix(alpha,heads);
[Q_closed, h_closed] =  Closed_Form(heads, k, beta, width, l, x_pos);

% FD Discharge Q (calculated across face i + 1/2)
w_mid = 0.5 * (channelWidth(1:N-1) + channelWidth(2:N));
Q_FD = -k * w_mid .* (diff(h_matrix) / delta_x);
Q_FD_avg = mean(Q_FD);

Draw(x_pos, h_closed, h_itter, h_matrix, channelWidth, Q_closed, Q_FD_avg)