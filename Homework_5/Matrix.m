%--------------------------------------------------------------------------
% Matrix()
%
% Solves the finite-difference system for hydraulic head.
%
% Arguments:
%   alpha   - Node coefficient values
%   heads   - Boundary head values
%
% Returns:
%   h       - Head at each node [m]
%
% Author:
%   Evan M. Stearns 
%   University of Minnesota
%
% Version:
%   11 October 2026
% 
%--------------------------------------------------------------------------
function [h] = Matrix(alpha, heads)
    N = numel(alpha);

    rhs = zeros(N,1);
    rhs(1,1) = heads(1,1);
    rhs(N,1) = heads(1,2);

    contm = zeros(N,N);
    contm(1,1) = 1;
    contm(N,N) = 1;

    for i = 2:N-1
        contm(i, i-1) = -(1 + alpha(i));
        contm(i, i)   = 2;
        contm(i, i+1) = -(1 - alpha(i));
    end
    

    h = (contm \ rhs)';
end