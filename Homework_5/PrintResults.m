%--------------------------------------------------------------------------
% PrintResults()
%
% Prints finite-difference and closed-form head and discharge results.
%
% Arguments:
%   x_pos     - x positions
%   h_matrix  - Finite-difference head values
%   h_closed  - Closed-form head values
%   Q_FD_avg  - Average finite-difference discharge
%   Q_closed  - Closed-form discharge
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function PrintResults(x_pos, h_matrix, h_closed, Q_FD_avg, Q_closed)
    fprintf('---------------------Using Finite Difference---------------------')
    fprintf('\nThe head at each x position was: \n')
    fprintf('x = %.3f, h = %.6f [m]\n', [x_pos; h_matrix]);
    fprintf('\n\n')
    fprintf('------------------------Using Closed-Form------------------------')
    fprintf('\nThe head at each x position was: \n')
    fprintf('x = %.3f, h = %.6f [m]\n', [x_pos; h_closed]);
    fprintf('\n\n')
    fprintf('-----------------The Diffrence Between FD and CF-----------------')
    fprintf('\nThe differnce in head at each x position was: \n')
    fprintf('x = %.3f, difference = %.6e [m]\n', [x_pos; abs(h_matrix - h_closed)]);
    fprintf('\n\n')
    fprintf('---------------------------Discharge Q---------------------------')
    fprintf('\nThe average discharge from finite differences was Q = %.6e m^3/s\n', Q_FD_avg);
    fprintf('The closed-form discharge was Q = %.6e m^3/s\n', Q_closed);
    fprintf('The discharge difference was %.6e m^3/s\n', abs(Q_FD_avg - Q_closed));
end