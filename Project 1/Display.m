function [] = Display(q_out,xCoordinates, Q_calc, alpha)

    figure;
    hold on;
    plot(xCoordinates,q_out,'o--', 'DisplayName', 'q out in m/s');
    xlabel('x coordinate');
    ylabel('Velocity (m/s)');
    legend('show');
    grid on;
    title('Variation of Specific Discharge');
    hold off;
    
    fprintf('The Total Flow Rate Q is %.6g in m^3/s\n',Q_calc);
    fprintf('The Shape Factor alpha is %.6g\n', alpha);
end