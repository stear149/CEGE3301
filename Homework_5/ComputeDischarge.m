%--------------------------------------------------------------------------
% ComputeDischarge()
%
% Computes discharge between adjacent nodes using finite differences.
%
% Arguments:
%   h_matrix     - Hydraulic head values at nodes
%   channelWidth - Channel width values at nodes
%   k            - Hydraulic conductivity
%   delta_x      - Distance between nodes
%
% Returns:
%   Q_FD         - Discharge values between adjacent nodes
%   Q_FD_avg     - Average discharge
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function [Q_FD, Q_FD_avg] = ComputeDischarge(h_matrix, channelWidth, k, delta_x)
    w_mid = 0.5 * (channelWidth(1:end-1) + channelWidth(2:end));
    Q_FD = -k * w_mid .* (diff(h_matrix) / delta_x);
    Q_FD_avg = mean(Q_FD);
end