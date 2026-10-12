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
function Draw(x_pos, h_closed, h_itter, h_matrix, channelWidth, ...
        Q_closed, Q_FD_avg)
    figure('Name', 'Convergent Channel Seepage Analysis', 'Color', 'w', ...
           'Units', 'normalized', 'Position', [0.2, 0.15, 0.6, 0.7]);


    % Subplot 1: Head Profile Comparison h(x)==============================
    subplot(2, 1, 1);
    x_smooth = linspace(x_pos(1), x_pos(end), 200);
    hold on;

    % Closed Form
    plot(x_pos, h_closed, 'r-', 'LineWidth', 2, 'DisplayName', ...
        'Analytical (Closed Form)'); 
    
    % Matrix
    plot(x_pos, h_matrix, 'bo--', 'LineWidth', 1.2, 'MarkerSize', 6, 'MarkerFaceColor', 'b', 'DisplayName', 'FD (Matrix)');
    
    % Iterative
    plot(x_pos, h_itter, 'ks:', 'LineWidth', 1.2, 'MarkerSize', 7, ...
         'DisplayName', 'FD (Iterative)');
    grid on;
    xlabel('Position along Channel x [m]', 'FontWeight', 'bold');
    ylabel('Hydraulic Head h [m]', 'FontWeight', 'bold');
    title('Hydraulic Head Profile h(x) Comparison', 'FontSize', 12);
    legend('Location', 'northeast');
    xlim([0, x_pos(end)]);
    ylim([min(h_closed) - 0.05, max(h_closed) + 0.05]);


    % Subplot 2: Channel Geometry Profile w(x) ============================
    subplot(2, 1, 2);

    % Symmetric channel boundaries about y = 0
    w_upper = channelWidth / 2;
    w_lower = -channelWidth / 2;
    
    hold on;
    fill([x_pos, fliplr(x_pos)], [w_upper, fliplr(w_lower)], [0.85, 0.92, 0.85], ...
         'EdgeColor', 'none', 'FaceAlpha', 0.6, 'DisplayName', 'Soil Medium'); 

    % Channel Boundaries
    plot(x_pos, w_upper, 'k-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
    plot(x_pos, w_lower, 'k-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
    
    % Nodes
    plot(x_pos, zeros(size(x_pos)), 'r.', 'MarkerSize', 12, 'DisplayName', 'FD Nodes');

    grid on;
    xlabel('Position along Channel x [m]', 'FontWeight', 'bold');
    ylabel('Channel Width w [m]', 'FontWeight', 'bold');
    title('Channel Geometry Profile w(x)', 'FontSize', 12);
    xlim([0, x_pos(end)]);
    ylim([-max(channelWidth)*0.7, max(channelWidth)*0.7]);
    legend('Location', 'northeast');


    % Discharge Q Comparison
    rel_err = abs(Q_FD_avg - Q_closed) / Q_closed * 100;
    
    q_summary = sprintf(['Discharge (Q) Summary:\n' ...
                         '• Q Theoretical = %.6e m^2/s\n' ...
                         '• Q Computed FD = %.6e m^2/s\n' ...
                         '• Relative Error = %.4f%%'], ...
                         Q_closed, Q_FD_avg, rel_err);
                     
    annotation('textbox', [0.15, 0.12, 0.38, 0.10], 'String', q_summary, ...
               'FitBoxToText', 'on', 'BackgroundColor', 'w', ...
               'EdgeColor', [0.3 0.3 0.3], 'FontSize', 9, 'FontName', 'monospace');

    hold off;
    
end