%--------------------------------------------------------------------------
% FlowRate(head,k,delta)
%
% Arguments:
%   head  - Head distribution at nodes
%   k     - Hydraulic conductivity [cm/s]
%   delta - Grid spacing and flow width [m]
%
% Returns:
%   Q_exact - Exact total flow rate
%   Q_calc  - Calculated total flow rate
%
% Notes:
%   Calculates the exact and numerical flow rates from a head distribution.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   13 October 2026
% 
%--------------------------------------------------------------------------

function [Q_exact, Q_calc] = FlowRate(head,k,delta)
    L = (width(head) - 1) * delta(1);
    H = (height(head) - 1) * delta(2);   

    xCoordinates = 0:delta(1):L;
    yCoordinates = 0:delta(2):H;

    k = k/100;       %[m/s]

    q_exact = k * (delta(3)/L);
    Q_exact = k * H * (delta(3)/L);

    [dh_dx, dh_dy] = gradient(head,delta(1),delta(2));
    q_x = -k .* dh_dx;
    q_y = -k .* dh_dy;
    q_magnitude = sqrt(q_x.^2 + q_y.^2);

    Q_calc = trapz(yCoordinates, q_x(:, 1));

end