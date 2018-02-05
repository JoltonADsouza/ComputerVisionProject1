
tic
clc
clear all;
close all;

og_w = 3072;
og_h = 2048;
sf = 0.25;

% i_ref = imread('data/0005.png');
% i1 = imread('data/0004.png');
% i2 = imread('data/0006.png');

i_ref = imread('C:\Users\Jolton\Desktop\Files\Homeworks\Semester3\3D Computer Vision\Projects\fountain_dense\urd\0005.png');
i1 = imread('C:\Users\Jolton\Desktop\Files\Homeworks\Semester3\3D Computer Vision\Projects\fountain_dense\urd\0004.png');
i2 = imread('C:\Users\Jolton\Desktop\Files\Homeworks\Semester3\3D Computer Vision\Projects\fountain_dense\urd\0006.png');






i_ref = imresize(i_ref,sf);
i1 = imresize(i1,sf);
i2 = imresize(i2,sf);
i_ref = im2double(i_ref);
i1 = im2double(i1);
i2 = im2double(i2);

k_ref = [2759.48 0 1520.69;0 2764.16 1006.81;0 0 1];
r_ref = [0.962742 -0.0160548 -0.269944 ;-0.270399 -0.0444283 -0.961723 ;0.00344709 0.998884 -0.0471142];
t_ref = [-14.1604 -3.32084 0.0862032 ]';

a_x = 2*atan(1520.69/2759.48);
a_y = 2*atan(1006.81/2764.16);
f_x = ((og_w*sf)/2)/(tan(a_x/2));
f_y = ((og_h*sf)/2)/(tan(a_y/2));
k_ref = [f_x 0 ((og_w*sf)/2);0 f_y ((og_h*sf)/2);0 0 1];

r1 = [0.890856 -0.0211638 -0.453793; -0.454283 -0.0449857 -0.889721; -0.00158434 0.998763 -0.0496901 ];
t1 = [-12.404 -3.81315 0.110559]';
r2 = [0.994915 -0.00462005 -0.100616; -0.100715 -0.0339759 -0.994335; 0.00117536 0.999412 -0.0342684];
t2 = [-15.8818 -3.15083 0.0592619]';
k1 = k_ref;
k2 = k_ref;

ext_ref = inv([r_ref t_ref; [0 0 0 1]]);
ext_r1 = inv([r1 t1 ; [0 0 0 1]]);
ext_r2 = inv([r2 t2 ; [0 0 0 1]]);

ext_refi = inv(ext_ref);
r1_ref = ext_r1*ext_refi;
r2_ref = ext_r2*ext_refi;

r01 = r1_ref(1:3,1:3);
t01 = r1_ref(1:3,4);
r02 = r2_ref(1:3,1:3);
t02 = r2_ref(1:3,4);

n = [0 0 -1]'; %fronto parallel normal
n1 = r01*n; %oriented plane normal orthogonal to camera1 optical axis
n2 = r02*n; %oriented plane normal orthogonal to camera2 optical axis

z_near = 4.75;
z_far = 9.75;
no_of_planes = 50;
z_step = (z_far - z_near)/no_of_planes; 

%n = r02*n; 
depth_range = z_near:z_step:z_far;

[i1_warped] = ImageWarping(i1, i_ref, depth_range,k1,r01,t01,n1,k_ref, no_of_planes, z_step);
[i2_warped] = ImageWarping(i2, i_ref, depth_range,k2,r02,t02,n1,k_ref,no_of_planes, z_step);

% [depth_map] = SAD(255*rgb2gray(i_ref), i1_warped, i2_warped, depth_range, n, k_ref, 3);
[depth_map] = SSD_singlesweep(255*rgb2gray(i_ref), i2_warped, i1_warped, depth_range, k_ref, n1');

figure;
imshow(uint8(depth_map));
figure;
imagesc(depth_map);
colormap jet;
colorbar
% save(colormap)


ErrorReport(depth_map, sf);

toc

