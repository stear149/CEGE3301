%--------------------------------------------------------------------------
% Groundwater Head Distribution and Flow Rate
%
% Calculates and displays the head distribution over a specified area,
% along with exact and calculated flow rates.
%
% Notes:
%   This function calculates and visualizes the head distribution over 
%   a specified area.
%   Total Flow Assuming k = 0.01 cm/s
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   16 October 2026
% 
%--------------------------------------------------------------------------

L = 5; % [m]
H = 3; % [m]

delta_x = 1;    % [m]
delta_y = 1;    % [m]
delta_h = 1;  % [m]                       % This could be a user input.

delta = [delta_x, delta_y,delta_h];

k = 0.01; % [cm/s]

xCoordinates = 0:delta_x:L;
yCoordinates = 0:delta_y:H;
[nX, nY] = deal(numel(xCoordinates), numel(yCoordinates));
head = zeros(nY, nX);

% Dirichlet Bounds (East/West) (Int Conditions)
H_int = 1;                                  % This could be a user input.
H_fin = H_int - delta_h;

head(:, 1) = H_int;
head(:, end) = H_fin;

head = Matrix(head);
[Q_exact, Q_calc] = FlowRate(head,k,delta);
head_exact = ComputedHead(L, H, delta, H_int, k, Q_exact);

Display(head, head_exact, Q_calc, Q_exact,delta, L)


%=========================================================================%
%================================Functions================================%
%=========================================================================%


%-------------------------------------------------------------------------%
% Matrix(head)
%
% Arguments:
%   head - Matrix of prescribed head values
%
% Returns:
%   h - Calculated head distribution at the nodes
%
% Notes:
%   This function constructs and solves the finite-difference matrix system
%   for the head distribution.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   13 October 2026
% 
%--------------------------------------------------------------------------
function [h] = Matrix(head)
    N = numel(head);
    nX = width(head);
    nY = height(head);
    % K indexing (Left to Right, Top to Bottom)
    h_k = reshape(head.', [], 1);

    % Building Components of the A Matrix
    A = zeros(nX*nY);
    Diag = zeros(nX);
    off_Diag = zeros(nX);
    flow = zeros(nX);
    
    Diag(1,1) = 1;
    Diag (nX,nX) = 1;
    for i = 2:nX-1
        Diag(i,i) = 4;
        Diag(i,i+1) = -1;
        Diag(i,i-1) = -1;
        off_Diag(i,i) = -1;
        flow(i,i) = -2;
    end

    % Building the A Matrix
    for i = 1:nY
        r = (i-1)*nX + (1:nX);
        A(r,r) = Diag;
    end

    for i = 1:nY-1
        r1 = (i-1)*nX + (1:nX);
        r2 = i*nX + (1:nX);

        A(r1,r2) = (i == 1) * flow + (i ~= 1) * off_Diag;
        A(r2,r1) = (i == nY-1) * flow + (i ~= nY-1) * off_Diag;
    end

    h_k = A \ h_k;
    
    h = reshape(h_k, nX, nY)';
end

%--------------------------------------------------------------------------
% FlowRate(head,k,delta)
%
% Arguments:
%   head  - Head distribution at nodes
%   k     - Hydraulic conductivity [cm/s]
%   delta - Grid spacing and flow width [m]
%
% Returns:
%   Q_exact - Exact total flow rate
%   Q_calc  - Calculated total flow rate
%
% Notes:
%   Calculates the exact and numerical flow rates from a head distribution.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   13 October 2026
% 
%--------------------------------------------------------------------------

function [Q_exact, Q_calc] = FlowRate(head,k,delta)
    L = (width(head) - 1) * delta(1);
    H = (height(head) - 1) * delta(2);    

    xCoordinates = 0:delta(1):L;
    yCoordinates = 0:delta(2):H;

    k = k/100;       %[m/s]

    q_exact = k * (delta(3)/L);
    Q_exact = k * H * (delta(3)/L);

    [dh_dx, dh_dy] = gradient(head,delta(1),delta(2));
    q_x = -k .* dh_dx;
    q_y = -k .* dh_dy;
    q_magnitude = sqrt(q_x.^2 + q_y.^2);

    Q_calc = trapz(yCoordinates, q_x(:, 1));

end

%--------------------------------------------------------------------------
% ComputedHead(L, H, delta, H_int, k, Q_exact)
%
% Arguments:
%   L       - Total length of the domain [m]
%   H       - Aquifer thickness [m]
%   delta   - Spatial step-size vector [m]
%   H_int   - Initial hydraulic head [m]
%   k       - Hydraulic conductivity [cm/s]
%   Q_exact - Exact volumetric flow rate
%
% Returns:
%   h_exact - Hydraulic head at each x-coordinate [m]
%
% Notes:
%   This function solves for the head using a closed-form solution along
%   the top stream line of the given area.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   16 October 2026
% 
%--------------------------------------------------------------------------
function [h_exact] = ComputedHead(L, H, delta, H_int, k, Q_exact)
    A = H * 1;      %[m]
    k = k/100;      %[m/s]
    
    xCoordinates = 0:delta(1):L;
    
    h_exact = H_int - (Q_exact/(k * A)) .* xCoordinates;
end

%--------------------------------------------------------------------------
% Display(head, h_exact, Q_calc, Q_exact, delta, L)
%
% Arguments:
%   head    - Computed hydraulic head values [m]
%   h_exact - Exact hydraulic head values [m]
%   Q_calc  - Computed discharge [m/s]
%   Q_exact - Exact discharge [m/s]
%   delta   - Grid spacing vector [m]
%   L       - Domain length [m]
%
% Returns:
%   None
%
% Notes:
% Displays computed and exact hydraulic head profiles and discharge values.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   16 October 2026
% 
%--------------------------------------------------------------------------
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