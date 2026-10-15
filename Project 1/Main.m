L = 10;         % [m]
H = 10;         % [m]

delta_x = .001;    % [m]
delta_y = .001;    % [m]

h_north = 2;    % [m]h
h_west = 1;     % [m]

xCoordinates = 0:delta_x:L;
yCoordinates = 0:delta_y:H;
[nX, nY] = deal(numel(xCoordinates), numel(yCoordinates));
head = zeros(nY, nX);

head(1, :) = h_north;
head(:, 1) = h_west;

head = Matrix(head);
