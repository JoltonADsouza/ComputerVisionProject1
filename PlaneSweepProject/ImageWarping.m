function [i_warped] = ImageWarping(img, i_ref, depth_range,kx,rx,tx,n,k_ref, no_of_planes,z_step)

[rows, cols, color] = size(i_ref);
i_warped = cell(1,no_of_planes+1);
for x = 1:length(i_warped)
    i_warped{x} = zeros(rows,cols);
end

x1 = repmat(1:cols,rows,1);
y1 = repmat((1:rows)',1,cols);

di = 0;
for d = depth_range(1):z_step:depth_range(end)
    di = di + 1;
   
    hx = kx*(rx-((tx*n')/d))*inv(k_ref);
    hx = hx/hx(3,3);
    
    x2 = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, hx(1,1), x1), bsxfun(@times, hx(1,2), y1)), hx(1,3));
    y2 = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, hx(2,2), y1), bsxfun(@times, hx(2,1), x1)), hx(2,3));
    w  = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, hx(3,1), x1), bsxfun(@times, hx(3,2), y1)), hx(3,3));
    x2 = bsxfun(@rdivide, x2, w);
    y2 = bsxfun(@rdivide, y2, w);
    i_warped{di} = interp2(x1, y1, 255*rgb2gray(img), x2, y2, 'linear', 0);
end