function [planes] = HomographyEstimationWithBilinearInterpolation(I,K,R_x,t_x,K_ref,n_plane)

[rows,cols,color] = size(I);

planes = cell(1,6);
for i = 1:length(planes)
    planes{i} = zeros(size(I,1),size(I,2));
end

%% Homography estimation

for i = 1:rows
    for j = 1:cols
        plane_number = 0;
        for d_plane = 4:9
            plane_number = plane_number + 1;
            
            
            H = K*(R_x - (t_x*(n_plane))/(d_plane))/(K_ref);
            
%             H = (K*(transpose(R_x) - (-transpose(R_x)*t_x*(n_plane))/(d_plane)))*K_ref^(-1);
            H_inverse = H^(-1);

            X = H*[j;i;1];
            
            X_new_cord = [X(1,1)/X(3,1), X(2,1)/X(3,1)];
            
             if floor(X_new_cord(1)) <= 0 || floor(X_new_cord(2)) <= 0 || floor(X_new_cord(1))+1 > cols || floor(X_new_cord(2))+1 > rows
                    continue;
             else
                R = (X_new_cord - floor(X_new_cord));
                if R(1) == 0 && R(2) == 0
                        
                     planes{plane_number}(i,j,1) = I(X_new_cord(2),X_new_cord(1),1);
                     planes{plane_number}(i,j,2) = I(X_new_cord(2),X_new_cord(1),2);
                     planes{plane_number}(i,j,3) = I(X_new_cord(2),X_new_cord(1),3);
                else
                    a = R(1); b = R(2); 
%                      
                     R11 = I( floor(X_new_cord(2)),floor(X_new_cord(1)),1); R12 = I( floor(X_new_cord(2))+1,floor(X_new_cord(1)),1);
                     R22 = I( floor(X_new_cord(2))+1,floor(X_new_cord(1))+1,1); R21 = I( floor(X_new_cord(2)),floor(X_new_cord(1))+1,1);
        
                     G11 = I( floor(X_new_cord(2)),floor(X_new_cord(1)),2); G12 = I( floor(X_new_cord(2))+1,floor(X_new_cord(1)),2);
                     G22 = I( floor(X_new_cord(2))+1,floor(X_new_cord(1))+1,2); G21 = I( floor(X_new_cord(2)),floor(X_new_cord(1))+1,2);
        
                     B11 = I( floor(X_new_cord(2)),floor(X_new_cord(1)),3); B12 = I( floor(X_new_cord(2))+1,floor(X_new_cord(1)),3);
                     B22 = I( floor(X_new_cord(2))+1,floor(X_new_cord(1))+1,3); B21 = I( floor(X_new_cord(2)),floor(X_new_cord(1))+1,3);
                    
                     planes{plane_number}( i,j,1) = round((1-a)*(1-b)*R11 + a*(1-b)*R21 + a*b*R22 + b*(1-a)*R12);
                     planes{plane_number}( i,j,2) = round((1-a)*(1-b)*G11 + a*(1-b)*G21 + a*b*G22 + b*(1-a)*G12);
                     planes{plane_number}( i,j,3) = round((1-a)*(1-b)*B11 + a*(1-b)*B21 + a*b*B22 + b*(1-a)*B12);
                end
            end
        end
    end
end
for i = 1:length(planes)
    planes{i} = uint8(planes{i});
end
