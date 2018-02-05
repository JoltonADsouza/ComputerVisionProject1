function[depth_image] = SAD_Multisweep(I_ref, PlaneImages_left,PlaneImages_left_or1,PlaneImages_left_or2, PlaneImages_right,PlaneImages_right_or1,PlaneImages_right_or2, depth_range,K_ref,n, n1, n2)

window_size = 5;
[rows_ref, cols_ref, color] = size(I_ref);
% [rows_plane, cols_plane, color] = size(PlaneImages_left{1});
depth_image = zeros(1,1);

for x = 1:rows_ref
    for y = 1:cols_ref
        SAD_Avg_array = zeros(1,length(PlaneImages_left)); SAD_Avg_or1_array = SAD_Avg_array; SAD_Avg_or2_array = SAD_Avg_array; 
        for i = 1:length(PlaneImages_left)
%             SAD_Red_left = 0; SAD_Green_left = 0; SAD_Blue_left = 0; SAD_Red_right = 0; SAD_Green_right = 0; SAD_Blue_right = 0;
            SAD_Gray_left = 0; SAD_Gray_right = 0; SAD_Gray_left_or1 = 0; SAD_Gray_right_or1 = 0; SAD_Gray_left_or2 = 0; SAD_Gray_right_or2 = 0;    
            for k = x-floor(window_size/2):x+floor(window_size/2)
                for l = y-floor(window_size/2):y+floor(window_size/2)
                    if k > 0 && k <= rows_ref && l > 0 && l <= cols_ref
                          SAD_Gray_left =  SAD_Gray_left +  abs(I_ref(k,l) - PlaneImages_left{i}(k,l));
                          SAD_Gray_right =  SAD_Gray_right +  abs(I_ref(k,l) - PlaneImages_right{i}(k,l));
                          
                          SAD_Gray_left_or1 =  SAD_Gray_left_or1 +  abs(I_ref(k,l) - PlaneImages_left_or1{i}(k,l));
                          SAD_Gray_right_or1 =  SAD_Gray_right_or1 +  abs(I_ref(k,l) - PlaneImages_right_or1{i}(k,l));
                          
                          SAD_Gray_left_or2 =  SAD_Gray_left_or2 +  abs(I_ref(k,l) - PlaneImages_left_or2{i}(k,l));
                          SAD_Gray_right_or2 =  SAD_Gray_right_or2 +  abs(I_ref(k,l) - PlaneImages_right_or2{i}(k,l));
                        
%                         SAD_Red_left = SAD_Red_left + abs(I_ref(k,l,1) - PlaneImages_left{i}(k,l,1));
%                         SAD_Green_left = SAD_Green_left + abs(I_ref(k,l,2) - PlaneImages_left{i}(k,l,2));
%                         SAD_Blue_left = SAD_Blue_left + abs(I_ref(k,l,3) - PlaneImages_left{i}(k,l,3));
%                         
%                         SAD_Red_right = SAD_Red_right + abs(I_ref(k,l,1) - PlaneImages_right{i}(k,l,1));
%                         SAD_Green_right = SAD_Green_right + abs(I_ref(k,l,2) - PlaneImages_right{i}(k,l,2));
%                         SAD_Blue_right = SAD_Blue_right + abs(I_ref(k,l,3) - PlaneImages_right{i}(k,l,3)); 
                     end
                end
            end
%                         SAD_Color_left = (SAD_Red_left + SAD_Green_left + SAD_Blue_left)/3;
%                         SAD_Color_right = (SAD_Red_right + SAD_Green_right + SAD_Blue_right)/3;
                        SAD_Avg = (SAD_Gray_left + SAD_Gray_right)/2;
                        SAD_Avg_or1 = (SAD_Gray_left_or1 + SAD_Gray_right_or1)/2;
                        SAD_Avg_or2 = (SAD_Gray_left_or2 + SAD_Gray_right_or2)/2;
                        
                        SAD_Avg_array(i) =  SAD_Avg; SAD_Avg_or1_array(i) =  SAD_Avg_or1; SAD_Avg_or2_array(i) =  SAD_Avg_or2;

                        
        end
        [m idx] = min(SAD_Avg_array); [m_or1 idx_or1] = min(SAD_Avg_or1_array); [m_or2 idx_or2] = min(SAD_Avg_or2_array);
        value_array = [m m_or1 m_or2]; idx_array = [idx idx_or1 idx_or2]; normal_arr = [n; n1; n2];
        [val, index] = min(value_array);
%              disp(index)
             depth_image(x,y) = -idx_array(index)/([y x 1]*transpose(K_ref^(-1))*(normal_arr((index:index),(1:3)))');
    end
end                     