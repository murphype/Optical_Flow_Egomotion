% Get images

I_1 = im2gray(im2double(imread("/home/sulimovn/csc262/project_final/images/blender_001.png")));
I_2 = im2gray(im2double(imread("/home/sulimovn/csc262/project_final/images/blender_002.png")));
I_3 = im2gray(im2double(imread("/home/sulimovn/csc262/project_final/images/kitti_001.png")));
I_4 = im2gray(im2double(imread("/home/sulimovn/csc262/project_final/images/kitti_002.png")));
% Visualize images

figure(1);
imshow(I_1);
title("Blender, I_1");
pause(0.1);

figure(2);
imshow(I_2);
title("Blender, I_2");
pause(0.1);

figure(3);
imshow(I_3);
title("Kitti, I_3");
pause(0.1);

figure(4);
imshow(I_4);
title("Kitti, I_4");
pause(0.1);

% Compute optical flow

of_hs_1 = of_hs(I_1, I_2);
of_hs_kp_1 = of_hs_kp(I_1, I_2);

of_hs_2 = of_hs(I_3, I_4);
of_hs_kp_2 = of_hs_kp(I_3, I_4);

% Visualize optical flow

of_quiver(I_1, of_hs_kp_1, 10, 3, "OFF Blender, I_{1-2}");
pause(0.1);

of_quiver(I_3, of_hs_kp_2, 10, 3, "OFF Kitti, I_{3-4}");
pause(0.1);
