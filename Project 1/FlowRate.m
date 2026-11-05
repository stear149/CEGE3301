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