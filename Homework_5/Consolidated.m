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


%=========================================================================%
%=================================All Def=================================%
%=========================================================================%

%--------------------------------------------------------------------------
% Loop()
%
% Iteratively solves for hydraulic head values along a one-dimensional loop.
%
% Arguments:
%   alpha    - Node coefficients
%   heads    - Boundary head values
%   accuracy - Convergence tolerance
%
% Returns:
%   h        - Head values at all nodes [m]
%
% Notes:
%   Iteration continues until the maximum head change is below accuracy.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function [h] = Loop(alpha, heads, accuracy)
    N = numel(alpha);
    h = zeros(1,N);
    
    h(1,1) = heads(1,1);
    h(1,N) = heads(1,2);

    h_new = h;

    h_dif = Inf;

    while h_dif > accuracy
        for i = 2:N-1
            h_new(1,i) = ((1 + alpha(1,i))*h(1,i-1) + ...
                (1 - alpha(1,i))*h(1,i+1)) / 2;
        end
        h_dif = max(abs(h_new - h));
        h = h_new;
    end
end


%--------------------------------------------------------------------------
% Matrix()
%
% Solves the finite-difference system for hydraulic head.
%
% Arguments:
%   alpha   - Node coefficient values
%   heads   - Boundary head values
%
% Returns:
%   h       - Head at each node [m]
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function [h] = Matrix(alpha, heads)
    N = numel(alpha);

    rhs = zeros(N,1);
    rhs(1,1) = heads(1,1);
    rhs(N,1) = heads(1,2);

    contm = zeros(N,N);
    contm(1,1) = 1;
    contm(N,N) = 1;

    for i = 2:N-1
        contm(i, i-1) = -(1 + alpha(i));
        contm(i, i)   = 2;
        contm(i, i+1) = -(1 - alpha(i));
    end
    

    h = (contm \ rhs)';
end


%--------------------------------------------------------------------------
% Closed_Form()
%
% Arguments:
%   heads   - Inlet and outlet head values
%   k       - Hydraulic conductivity
%   beta    - Width convergence parameter
%   width   - Inlet and outlet widths
%   l       - Domain length
%   x_pos   - Positions at which to calculate head
%
% Returns:
%   Q       - Flow rate [m^3/a]
%   h       - Head distribution at x_pos [m]
%
% Notes:
%   Calculates the closed-form flow rate and head distribution for a
%   converging-width domain.
% 
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function [Q, h] = Closed_Form(heads, k, beta, width, l, x_pos)
    w_in = width(1,1);
    w_out = width(1,2);
    h_in = heads(1,1);
    h_out = heads(1,2);

    Q = ((h_out - h_in) * beta * k) / (log(1-((beta * l) / w_in)));
    h = h_in + (Q / (beta * k)) * log(1 - ((beta .* x_pos) ./ w_in));
end


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


%--------------------------------------------------------------------------
% Draw()
%
% Description:
%   Plots hydraulic head profiles, channel geometry, and discharge
%   comparison results.
%
% Arguments:
%   x_pos        - Node positions along the channel
%   h_closed     - Analytical hydraulic head values
%   h_itter      - Iterative finite-difference head values
%   h_matrix     - Matrix-based finite-difference head values
%   channelWidth - Channel width at each node
%   Q_closed     - Analytical discharge
%   Q_FD_avg     - Average finite-difference discharge
%
% Returns:
%   None. Creates a comparison figure.
% 
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function Draw(x_pos, h_closed, h_iter, h_matrix, channelWidth, Q_closed, Q_FD_avg)

    % High-Contrast Color Palette
    c_analytical = [0.80, 0.10, 0.10]; % Crimson Red
    c_matrix     = [0.00, 0.35, 0.75]; % Cobalt Blue
    c_iterative  = [0.85, 0.40, 0.00]; % Deep Orange
    c_soil       = [0.82, 0.86, 0.88]; % Cool Slate Gray
    c_boundary   = [0.10, 0.10, 0.10]; % Dark Charcoal

    figure('Name', 'Convergent Channel Seepage Analysis', 'Color', 'w', ...
           'Units', 'normalized', 'Position', [0.2, 0.15, 0.6, 0.7]);

    % Subplot 1: Head Profile Comparison h(x)
    ax1 = subplot(2, 1, 1);
    hold on;

    plot(x_pos, h_closed, '--', 'Color', c_analytical, 'LineWidth', 3.5, ...
         'DisplayName', 'Analytical (Closed Form)');
    plot(x_pos, h_matrix, 'o--', 'Color', c_matrix, 'LineWidth', 1.5, ...
         'MarkerSize', 5, 'MarkerFaceColor', c_matrix, ...
         'DisplayName', 'FD (Matrix)');
    plot(x_pos, h_iter, 's:', 'Color', c_iterative, 'LineWidth', 1.5, ...
         'MarkerSize', 9, 'MarkerFaceColor', 'none', ...
         'DisplayName', 'FD (Iterative)');
    
    grid on;
    set(ax1, 'XColor', 'k', 'YColor', 'k', 'GridColor', [0.3 0.3 0.3], ...
         'GridAlpha', 0.3, 'LineWidth', 1.1);
    xlabel('Position along Channel x [m]', 'FontWeight', 'bold', 'Color', 'k');
    ylabel('Hydraulic Head h [m]', 'FontWeight', 'bold', 'Color', 'k');
    title('Hydraulic Head Profile h(x) Comparison', 'FontSize', 12, ...
          'FontWeight', 'bold', 'Color', 'k');
    lgd1 = legend('Location', 'northeast');
    set(lgd1, 'TextColor', 'k', 'EdgeColor', [0.2 0.2 0.2], 'Color', 'w');
    xlim([0, x_pos(end)]);
    ylim([min(h_closed) - 0.05, max(h_closed) + 0.05]);

    % Subplot 2: Channel Geometry Profile w(x)
    ax2 = subplot(2, 1, 2);

    w_upper = channelWidth / 2;
    w_lower = -channelWidth / 2;
    
    hold on;
    fill([x_pos, fliplr(x_pos)], [w_upper, fliplr(w_lower)], c_soil, ...
         'EdgeColor', 'none', 'FaceAlpha', 0.85, 'DisplayName', 'Soil Medium'); 

    plot(x_pos, w_upper, '-', 'Color', c_boundary, 'LineWidth', 1.8, 'HandleVisibility', 'off');
    plot(x_pos, w_lower, '-', 'Color', c_boundary, 'LineWidth', 1.8, 'HandleVisibility', 'off');

    % FD Nodes
    plot(x_pos, zeros(size(x_pos)), 'o', 'Color', c_boundary, ...
         'MarkerSize', 7, 'MarkerFaceColor', c_iterative, ...
         'LineWidth', 1.0, 'DisplayName', 'FD Nodes');

    grid on;
    set(ax2, 'XColor', 'k', 'YColor', 'k', 'GridColor', [0.3 0.3 0.3], ...
             'GridAlpha', 0.3, 'LineWidth', 1.1);
    xlabel('Position along Channel x [m]', 'FontWeight', 'bold', 'Color', 'k');
    ylabel('Channel Width w [m]', 'FontWeight', 'bold', 'Color', 'k');
    title('Channel Geometry Profile w(x)', 'FontSize', 12, ...
          'FontWeight', 'bold', 'Color', 'k');
    lgd2 = legend('Location', 'northeast');
    set(lgd2, 'TextColor', 'k', 'EdgeColor', [0.2 0.2 0.2], 'Color', 'w');
    xlim([0, x_pos(end)]);
    ylim([-max(channelWidth)*0.7, max(channelWidth)*0.7]);

    % Discharge Q Comparison Summary
    rel_err = abs(Q_FD_avg - Q_closed) / Q_closed * 100;
    
    q_summary = sprintf(['Discharge (Q) Summary:\n' ...
                         '• Q Theoretical = %.6e m^3/s\n' ...
                         '• Q Computed FD = %.6e m^3/s\n' ...
                         '• Relative Error = %.4f%%'], ...
                         Q_closed, Q_FD_avg, rel_err);
                     
    annotation('textbox', [0.15, 0.12, 0.38, 0.10], 'String', q_summary, ...
               'FitBoxToText', 'on', 'BackgroundColor', [0.98 0.98 0.98], ...
               'Color', 'k', 'EdgeColor', [0.2 0.2 0.2], 'LineWidth', 1.1, ...
               'FontSize', 9, 'FontName', 'monospace');

    hold off;
    
        % Second Figure: Hydraulic Head Profiles Only
    figure('Name', 'Hydraulic Head Profile Comparison', 'Color', 'w', ...
           'Units', 'normalized', 'Position', [0.25, 0.2, 0.55, 0.55]);

    ax3 = axes;
    hold(ax3, 'on');

    plot(ax3, x_pos, h_closed, '--', 'Color', c_analytical, 'LineWidth', 3.5, ...
         'DisplayName', 'Analytical (Closed Form)');
    plot(ax3, x_pos, h_matrix, 'o--', 'Color', c_matrix, 'LineWidth', 1.5, ...
         'MarkerSize', 5, 'MarkerFaceColor', c_matrix, ...
         'DisplayName', 'FD (Matrix)');
    plot(ax3, x_pos, h_iter, 's:', 'Color', c_iterative, 'LineWidth', 1.5, ...
         'MarkerSize', 9, 'MarkerFaceColor', 'none', ...
         'DisplayName', 'FD (Iterative)');

    grid(ax3, 'on');
    set(ax3, 'XColor', 'k', 'YColor', 'k', ...
        'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.3, 'LineWidth', 1.1);
    xlabel(ax3, 'Position along Channel x [m]', 'FontWeight', 'bold', 'Color', 'k');
    ylabel(ax3, 'Hydraulic Head h [m]', 'FontWeight', 'bold', 'Color', 'k');
    title(ax3, 'Hydraulic Head Profile h(x) Comparison', ...
          'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
    legend(ax3, 'Location', 'northeast');
    xlim(ax3, [0, x_pos(end)]);
    ylim(ax3, [min(h_closed) - 0.05, max(h_closed) + 0.05]);
    hold(ax3, 'off');
end


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