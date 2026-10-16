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
function [h] = Matrix(head)
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
    
    % Build A Matrix
    for i = 1:nY
        r = (i-1)*nX + (1:nX);
        A(r,r) = sparse((i == 1) * Diag_1_1 + (i ~= 1) * Diag);
    end

    for i = 1:nY-1
        r1 = (i-1)*nX + (1:nX);
        r2 = i*nX + (1:nX);

        A(r1,r2) = sparse((i ~= 1) * OffDiag);
        A(r2,r1) = sparse((i == nY-1) * Flow + (i ~= nY-1) * OffDiag);
    end

    % % Set up an Incomplete LU preconditioner (ILU(0))
    % setup.type = 'nofill';
    % [L, U] = ilu(A, setup);
    % 
    % % Solve with GMRES: gmres(A, b, restart, tol, maxit, L, U)
    % restart = 30; % Restarts Arnoldi iteration every 30 steps to control memory
    % tol = 1e-6;
    % maxit = 200;
    % 
    % [h_k, flag, ~, iter] = gmres(A, h_k, restart, tol, maxit, L, U);
    % 
    % if flag ~= 0
    %     warning('GMRES did not converge (flag %d).', flag);
    % else
    %     fprintf('GMRES converged in %d outer iterations (%d inner iterations).\n', iter(1), iter(2));
    % end

    h_k = A \ h_k;

    h = reshape(h_k, nX, nY)';
end