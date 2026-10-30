function [alpha] = ShapeFactor(Q, k, h_in, h_out)
    alpha = Q /( k * (h_in - h_out));
    
end