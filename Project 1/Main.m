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


% 1. Setup DataQueue for parallel status messaging
q = parallel.pool.DataQueue;
stages = containers.Map({'Matrix', 'FastMatrix'}, {'Queued', 'Queued'});
afterEach(q, @(msg) updateStage(msg, stages));

% 2. Pass queue and task names to parfeval
f1 = parfeval(@Matrix, 2, head, q, 'Matrix');
f2 = parfeval(@FastMatrix, 2, head, q, 'FastMatrix');

progress = waitbar(0, 'Initializing tasks...');

while true
    states = {f1.State, f2.State};
    finished = strcmp(states, 'finished');
    
    % Update waitbar with real-time stage info for both functions
    statusText = sprintf('Matrix: %s\nFastMatrix: %s', stages('Matrix'), stages('FastMatrix'));
    waitbar(nnz(finished) / 2, progress, statusText);
    
    if all(finished) || any(strcmp(states, 'failed'))
        break
    end
    pause(0.1); % Allows MATLAB event loop to process incoming DataQueue messages
end

close(progress);

[head1, time1] = fetchOutputs(f1);
[head2, time2] = fetchOutputs(f2);

% Print final summary
fprintf('\n========================================\n');
fprintf('        TOTAL EXECUTION SUMMARY         \n');
fprintf('========================================\n');
fprintf('  Matrix total time:     %8.4f seconds\n', time1);
fprintf('  FastMatrix total time: %8.4f seconds\n', time2);
fprintf('  Speedup factor:        %8.2fx\n', time1 / time2);
fprintf('========================================\n');


%% Callback function to store and log updates
function updateStage(msg, stages)
    stages(msg.Name) = msg.Stage;
    fprintf('[%-10s] %s\n', msg.Name, msg.Stage);
end