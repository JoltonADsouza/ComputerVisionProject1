function [R_ref, R_1, R_2, C_ref, C_1, C_2] = fileread(fid_ref, fid_1, fid_2)

lin_count = 0; R_ref = []; R_1 = []; R_2 = []; C_ref = []; C_1= []; C_2 = [];

while lin_count <= 7
    if lin_count == 7
        C_ref = [C_ref; str2num(fgetl(fid_ref))];
        C_1 = [C_1; str2num(fgetl(fid_1))];
        C_2 = [C_2; str2num(fgetl(fid_2))];
        lin_count = lin_count + 1;
    elseif lin_count >= 4 && lin_count <= 6
        R_ref = [R_ref; str2num(fgetl(fid_ref))];
        R_1 = [R_1; str2num(fgetl(fid_1))];
        R_2 = [R_2; str2num(fgetl(fid_2))];
        lin_count = lin_count + 1;
    else
        lin_count = lin_count + 1;
        fgetl(fid_ref);fgetl(fid_1);fgetl(fid_2);
    end
end