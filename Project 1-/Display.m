function [] = Display(head, h_exact, Q_calc, Q_exact,delta, L)

    x = 0:delta(1):L;
    figure;
    hold on;
    plot(x, head(1,:), 'o-', 'DisplayName', 'Computed head');
    plot(x, h_exact, 'x--', 'DisplayName', 'Exact head');
    xlabel('Distance [m]');
    ylabel('Head [m]');
    title('Computed vs Exact Head');
    legend('Location', 'best');
    grid on;
    hold off;
    
    fprintf('Computed head in meters:\n')
    disp(head)
    fprintf('Exact head in meters of the top flow line:\n')
    disp(h_exact)

    fprintf('\n\nComputed Q: %.6g [m/s]\n', Q_calc);
    fprintf('   Exact Q: %.6g [m/s]\n', Q_exact);      
end