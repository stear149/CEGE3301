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