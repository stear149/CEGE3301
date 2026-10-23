function [Q_calc] = FlowRate(head,k,delta)
    L = (width(head) - 1) * delta(1);
    H = (height(head) - 1) * delta(2); 

    xCoordinates = 0:delta(1):L;
    yCoordinates = 0:delta(2):H;

    [dh_dx, dh_dy] = gradient(head,delta(1),delta(2));
    dh_dx(1,:) = 0;
    q_x = -k .* dh_dx;
    q_y = -k .* dh_dy;

    Q_calc = trapz(xCoordinates, q_y(1, :));3
end