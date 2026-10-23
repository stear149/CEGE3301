function [h, totalTime] = FastMatrix(head, q, name)
    tStart = tic;
    send(q, struct('Name', name, 'Stage', 'Building diagonals'));
    N = numel(head);
    nX = width(head);
    nY = height(head);

    h_k = reshape(head.', [], 1);

    tic
    fprintf('Building A MatrixFast\n');

    % 1. Create padded diagonal vectors of equal length (nX x 1)
    main_d  = [1; 4 * ones(nX - 1, 1)];
    lower_d = [0; -ones(nX - 2, 1); -2]; 
    upper_d = [0; -ones(nX - 2, 1); 0];  
    
    % Diagonal block (nX x nX)
    Diag = spdiags([lower_d, main_d, upper_d], [-1, 0, 1], nX, nX);
    
    % Off-diagonal submatrices
    OffDiag  = spdiags([0; -ones(nX - 1, 1)], 0, nX, nX);
    Diag_1_1 = speye(nX);
    Flow     = spdiags([0; -2 * ones(nX - 1, 1)], 0, nX, nX);
    
    % 2. Preallocate cell array with sparse zero matrices
    send(q, struct('Name', name, 'Stage', 'Assembling block structure'));
    A_cell = cell(nY, nY);
    [A_cell{:}] = deal(sparse(nX, nX));
    
    % 3. Populate block structure
    A_cell{1, 1} = Diag_1_1;
    for i = 2:nY
        A_cell{i, i} = Diag;
    end
    
    for i = 2:nY-1
        A_cell{i, i+1} = OffDiag; % Superdiagonal blocks
    end
    
    for i = 1:nY-2
        A_cell{i+1, i} = OffDiag; % Subdiagonal blocks
    end
    A_cell{nY, nY-1} = Flow;     % Last subdiagonal block

    send(q, struct('Name', name, 'Stage', 'Converting cell array to matrix'));
    
    % 4. Assemble full matrix in one shot
    A = cell2mat(A_cell);
    
    buildTime = toc;
    send(q, struct('Name', name, 'Stage', sprintf('Built A Matrix (%.2fs)', buildTime)));
    
    send(q, struct('Name', name, 'Stage', 'Solving system (A \\ h_k)...'));
    tic
    h_k = A \ h_k;

    h = reshape(h_k, nX, nY)';
    
    SolveTime = toc;
    send(q, struct('Name', name, 'Stage', sprintf('Complete (Solve: %.2fs)', SolveTime)));

    totalTime = toc(tStart);
    send(q, struct('Name', name, 'Stage', sprintf('Complete (Total: %.2fs)', totalTime)));
end
