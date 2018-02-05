function[depth_image] = SAD_singlesweep(I_ref, PlaneImages_left,PlaneImages_right,depth_range,K_ref,n)

window_size = 5;
[rows_ref, cols_ref, color] = size(I_ref);
% I_ref = uint8(I_ref);
% [rows_plane, cols_plane, color] = size(PlaneImages_left{1});
depth_image = zeros(1,1);

for x = 1:rows_ref
    for y = 1:cols_ref
        SAD_Avg_array = zeros(1,length(PlaneImages_left));  
        for i = 1:length(PlaneImages_left)
%             SAD_Red_left = 0; SAD_Green_left = 0; SAD_Blue_left = 0; SAD_Red_right = 0; SAD_Green_right = 0; SAD_Blue_right = 0;
            SAD_Gray_left = 0; SAD_Gray_right = 0;  
            for k = x-floor(window_size/2):x+floor(window_size/2)
                for l = y-floor(window_size/2):y+floor(window_size/2)
                    if k > 0 && k <= rows_ref && l > 0 && l <= cols_ref
                          SAD_Gray_left =  SAD_Gray_left +  abs(I_ref(k,l) - PlaneImages_left{i}(k,l));
                          SAD_Gray_right =  SAD_Gray_right +  abs(I_ref(k,l) - PlaneImages_right{i}(k,l));
                          
                     end
                end
            end
%                         SAD_Color_left = (SAD_Red_left + SAD_Green_left + SAD_Blue_left)/3;
%                         SAD_Color_right = (SAD_Red_right + SAD_Green_right + SAD_Blue_right)/3;
                        SAD_Avg = (SAD_Gray_left + SAD_Gray_right)/2;
                        SAD_Avg_array(i) =  SAD_Avg;
                        
        end
        [val, index] = min(SAD_Avg_array);
%              disp(index)
             depth_image(x,y) = -depth_range(index)/([y x 1]*(transpose(K_ref))^(-1)*n');
    end
end                     