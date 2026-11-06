%--------------------------------------------------------------------------
% Display(q_out, q_ClosedForm, xCoordinates, Q_calc, Q_ClosedForm, alpha)
%
% Displays numerical and closed-form specific discharge distributions and
% reports total flow rates, percent error, and shape factor.
%
% Arguments:
%   q_out        - Numerical discharge distribution [m/s]
%   q_ClosedForm - Closed-form discharge distribution [m/s]
%   xCoordinates - Spatial coordinates [m]
%   Q_calc       - Numerically calculated total flow rate [m^3/s]
%   Q_ClosedForm - Closed-form total flow rate [m^3/s]
%   alpha        - Shape factor
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   5 November 2026
% 
%--------------------------------------------------------------------------
function [] = Display(q_out, q_ClosedForm, xCoordinates, Q_calc,...
    Q_ClosedForm, alpha)

    figure;
    hold on;
    plot(xCoordinates,q_out,'o-', 'DisplayName', 'q out in m/s');
    plot(xCoordinates,q_ClosedForm,'o--', 'DisplayName',...
        'ClosedForm q out in m/s');
    xlabel('X Coordinate');
    ylabel('Velocity (m/s)');
    legend('show');
    grid on;
    title('Variation of Specific Discharge');
    hold off;
    
    fprintf('The Total Flow Rate Q is %.6g in m^3/s\n',Q_calc);
    fprintf('The Total Flow Rate Q by Closed Form is %.6g in m^3/s\n',...
        Q_ClosedForm);
    fprintf('The perecent error between the Closed Form and Finite solution is %.6g\n',...
        (abs(Q_calc - Q_ClosedForm))/Q_ClosedForm);
    fprintf('\nThe Shape Factor alpha is %.6g\n', alpha);
end