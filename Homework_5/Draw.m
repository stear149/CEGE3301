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