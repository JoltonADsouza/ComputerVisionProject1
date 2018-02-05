function[depth_image] = SSD_Multisweep(I_ref, PlaneImages_left,PlaneImages_left_or1,PlaneImages_left_or2, PlaneImages_right,PlaneImages_right_or1,PlaneImages_right_or2, depth_range,K_ref,n, n1, n2)

window_size = 5;
[rows_ref, cols_ref, color] = size(I_ref);
% [rows_plane, cols_plane, color] = size(PlaneImages_left{1});
depth_image = zeros(1,1);

for x = 1:rows_ref
    for y = 1:cols_ref
        SSD_Avg_array = zeros(1,length(PlaneImages_left)); SSD_Avg_or1_array = SSD_Avg_array; SSD_Avg_or2_array = SSD_Avg_array; 
        for i = 1:length(PlaneImages_left)
%             SSD_Red_left = 0; SSD_Green_left = 0; SSD_Blue_left = 0; SSD_Red_right = 0; SSD_Green_right = 0; SSD_Blue_right = 0;
            SSD_Gray_left = 0; SSD_Gray_right = 0; SSD_Gray_left_or1 = 0; SSD_Gray_right_or1 = 0; SSD_Gray_left_or2 = 0; SSD_Gray_right_or2 = 0;    
            for k = x-floor(window_size/2):x+floor(window_size/2)
                for l = y-floor(window_size/2):y+floor(window_size/2)
                    if k > 0 && k <= rows_ref && l > 0 && l <= cols_ref
                          SSD_Gray_left =  SSD_Gray_left +  ((I_ref(k,l) - PlaneImages_left{i}(k,l)))^2;
                          SSD_Gray_right =  SSD_Gray_right +  ((I_ref(k,l) - PlaneImages_right{i}(k,l)))^2;
                          
                          SSD_Gray_left_or1 =  SSD_Gray_left_or1 +  ((I_ref(k,l) - PlaneImages_left_or1{i}(k,l)))^2;
                          SSD_Gray_right_or1 =  SSD_Gray_right_or1 +  ((I_ref(k,l) - PlaneImages_right_or1{i}(k,l)))^2;
                          
                          SSD_Gray_left_or2 =  SSD_Gray_left_or2 +  ((I_ref(k,l) - PlaneImages_left_or2{i}(k,l)))^2;
                          SSD_Gray_right_or2 =  SSD_Gray_right_or2 +  ((I_ref(k,l) - PlaneImages_right_or2{i}(k,l)))^2;
                        
%                         SSD_Red_left = SSD_Red_left + abs(I_ref(k,l,1) - PlaneImages_left{i}(k,l,1));
%                         SSD_Green_left = SSD_Green_left + abs(I_ref(k,l,2) - PlaneImages_left{i}(k,l,2));
%                         SSD_Blue_left = SSD_Blue_left + abs(I_ref(k,l,3) - PlaneImages_left{i}(k,l,3));
%                         
%                         SSD_Red_right = SSD_Red_right + abs(I_ref(k,l,1) - PlaneImages_right{i}(k,l,1));
%                         SSD_Green_right = SSD_Green_right + abs(I_ref(k,l,2) - PlaneImages_right{i}(k,l,2));
%                         SSD_Blue_right = SSD_Blue_right + abs(I_ref(k,l,3) - PlaneImages_right{i}(k,l,3)); 
                     end
                end
            end
%                         SSD_Color_left = (SSD_Red_left + SSD_Green_left + SSD_Blue_left)/3;
%                         SSD_Color_right = (SSD_Red_right + SSD_Green_right + SSD_Blue_right)/3;
                        SSD_Avg = (SSD_Gray_left + SSD_Gray_right)/2;
                        SSD_Avg_or1 = (SSD_Gray_left_or1 + SSD_Gray_right_or1)/2;
                        SSD_Avg_or2 = (SSD_Gray_left_or2 + SSD_Gray_right_or2)/2;
                        
                        SSD_Avg_array(i) =  SSD_Avg; SSD_Avg_or1_array(i) =  SSD_Avg_or1; SSD_Avg_or2_array(i) =  SSD_Avg_or2;

                        
        end
        [m idx] = min(SSD_Avg_array); [m_or1 idx_or1] = min(SSD_Avg_or1_array); [m_or2 idx_or2] = min(SSD_Avg_or2_array);
        value_array = [m m_or1 m_or2]; idx_array = [idx idx_or1 idx_or2]; normal_arr = [n; n1; n2];
        [val, index] = min(value_array);
%              disp(index)
             depth_image(x,y) = -idx_array(index)/([y x 1]*transpose(K_ref^(-1))*(normal_arr((index:index),(1:3)))');
    end
end                     