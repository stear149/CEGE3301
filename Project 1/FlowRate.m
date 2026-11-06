%--------------------------------------------------------------------------
% FlowRate(head, k, delta)
%
% Arguments:
%   head  - Hydraulic head matrix [m]
%   k     - Hydraulic conductivity
%   delta - Spatial step-size vector [m]
%
% Returns:
%   Q_calc       - Numerically calculated flow rate
%   Q_ClosedForm - Closed-form flow rate
%   q_out        - Numerical flow-rate distribution along the boundary
%   q_ClosedForm - Closed-form flow-rate distribution along the boundary
%
% Notes:
%   This function calculates flow rates using both numerical gradients and
%   a closed-form solution along the top boundary.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   5 November 2026
% 
%--------------------------------------------------------------------------
function [Q_calc, Q_ClosedForm, q_out, q_ClosedForm] = FlowRate(head,k,delta)
    L = (width(head) - 1) * delta(1);
    H = (height(head) - 1) * delta(2); 

    xCoordinates = 0:delta(1):L;
    yCoordinates = 0:delta(2):H;

    [dh_dx, dh_dy] = gradient(head,delta(1),delta(2));
    dh_dx(1,:) = 0;
    q_x = -k .* dh_dx;
    q_y = -k .* dh_dy;

    q_y(1,1) = q_y(1,2);    % This is becasue we 
                            % canont calc Q at the singulatiry     
    q_out = fliplr(q_y(1,:));

    q_ClosedForm = k * ( head(1,L) ./ (pi() * xCoordinates));
    q_ClosedForm(1,1) = q_ClosedForm(1,2);
    q_ClosedForm = fliplr(q_ClosedForm);

    Q_calc = trapz(xCoordinates, q_y(1, :));
    Q_ClosedForm = trapz(xCoordinates, q_ClosedForm);
end