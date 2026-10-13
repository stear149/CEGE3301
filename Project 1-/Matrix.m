function [] = Matrix(head)
    N = numel(head);
    nX = width(head);
    nY = height(head);
    % K indexing (Left to Right, Top to Bottom)
    h_k = reshape(head.', [], 1);

    Diag = zeros(nX);
    off_Diag = zeros(nX);
    flow = zeros(nX);
    zero = zeros(nX);
    
    Diag(1,1) = 1;
    Diag (nX,nX) = 1;
    for i = 2:nX-1
        Diag(i,i) = 4;
        Diag(i,i+1) = -1;
        Diag(i,i-1) = -1;
        off_Diag(i,i) = -1;
        flow(i,i) = -2;
    end
    
    A = [Diag,   flow,    zero,    zero;
        off_Diag,Diag,    off_Diag,zero;
        zero,    off_Diag,Diag,    off_Diag;
        zero,    zero,    flow,    Diag];

    h_k = A \ h_k;
    
    h = reshape(h_k,[],nX);




end