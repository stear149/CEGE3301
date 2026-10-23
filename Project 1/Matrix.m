%--------------------------------------------------------------------------
% Matrix()
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
%   This is built only for a propblem where the west and north are know
%   heads and the east and south are flow lines.
%   
%   This is built as a modified version of a similarly named function from
%   project 1-.
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   15 October 2026
% 
%--------------------------------------------------------------------------
function [h, totalTime] = Matrix(head, q, name)
    tStart = tic; % Start overall function timer
    send(q, struct('Name', name, 'Stage', 'Setting up sub-matrices'));
    N = numel(head);
    nX = width(head);
    nY = height(head);

    h_k = reshape(head.', [], 1);

    A = spalloc(N, N, 5 * N);

    % Set up the main sub matricies 
    Diag = zeros(nX);
    OffDiag = zeros(nX);

    Diag(1,1) = 1;
    Diag(nX,nX) = 4;
    Diag(nX,nX-1) = -2;
    OffDiag(nX,nX) = -1;
    for i = 2:nX-1
        Diag(i,i) = 4;
        Diag(i,i+1) = -1;
        Diag(i,i-1) = -1;
        OffDiag(i,i) = -1;
    end

    % Set up the 3 sub matricies that differ
    Diag_1_1 = eye(nX);
    Flow = zeros(nX);
    for i = 2:nX
        Flow(i,i) = -2;
    end
    
    send(q, struct('Name', name, 'Stage', 'Building A Matrix...'));

    tic
    % Build A Matrix
    for i = 1:nY
        r = (i-1)*nX + (1:nX);
        A(r,r) = sparse((i == 1) * Diag_1_1 + (i ~= 1) * Diag);

        if mod(i, max(1, floor(nY/5))) == 0
            send(q, struct('Name', name, 'Stage', sprintf('Building A Matrix (%d%%)...', round(i/nY*100))));
        end
    end

    for i = 1:nY-1
        r1 = (i-1)*nX + (1:nX);
        r2 = i*nX + (1:nX);

        A(r1,r2) = sparse((i ~= 1) * OffDiag);
        A(r2,r1) = sparse((i == nY-1) * Flow + (i ~= nY-1) * OffDiag);
    end
    buildTime = toc;
    send(q, struct('Name', name, 'Stage', sprintf('Built A Matrix (%.2fs)', buildTime)));

    send(q, struct('Name', name, 'Stage', 'Solving system (A \\ h_k)...'));
    tic
    h_k = A \ h_k;
    h = reshape(h_k, nX, nY)'; 
    SolveTime = toc;
    send(q, struct('Name', name, 'Stage', sprintf('Complete (Solve: %.2fs)', SolveTime)));

    totalTime = toc(tStart); % Calculate total elapsed time
    send(q, struct('Name', name, 'Stage', sprintf('Complete (Total: %.2fs)', totalTime)));
end