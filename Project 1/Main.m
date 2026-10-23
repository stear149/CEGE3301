L = 10;         % [m]
H = 10;         % [m]

delta_x = 1;    % [m]
delta_y = 1;    % [m]

h_north = 2;    % [m]
h_west = 1;     % [m]

k = 0.01;       % [cm/s]
k = k/100;      % [m/s]

xCoordinates = 0:delta_x:L;
yCoordinates = 0:delta_y:H;
[nX, nY] = deal(numel(xCoordinates), numel(yCoordinates));
head = zeros(nY, nX);

head(1, :) = h_north;
head(:, 1) = h_west;

head = Matrix(head);

Q_calc = FlowRate(head, k, [delta_x, delta_y]);

