function [] = Display(q_out, q_ClosedForm, xCoordinates, Q_calc, Q_ClosedForm, alpha)

    figure;
    hold on;
    plot(xCoordinates,q_out,'o--', 'DisplayName', 'q out in m/s');
    plot(xCoordinates,q_ClosedForm,'o-', 'DisplayName', 'ClosedForm q out in m/s');
    xlabel('x coordinate');
    ylabel('Velocity (m/s)');
    legend('show');
    grid on;
    title('Variation of Specific Discharge');
    hold off;
    
    fprintf('The Total Flow Rate Q is %.6g in m^3/s\n',Q_calc);
    fprintf('The Total Flow Rate Q by Closed Form is %.6g in m^3/s\n',Q_ClosedForm);
    fprintf('The perecent error between the Closed Form and Finite solution is %.6g\n', (abs(Q_calc - Q_ClosedForm))/Q_ClosedForm);
    fprintf('\nThe Shape Factor alpha is %.6g\n', alpha);
end