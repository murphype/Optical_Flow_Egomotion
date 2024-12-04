close all;clc; clear;
%%read images
imgA = imread('class_scene_Suli_Zak.png');
imgB = imread("/home/weinman/courses/CSC262/images/kpdet1.tif");
imgC = imread("/home/weinman/courses/CSC262/images/kpdet2.tif");

%correct them to proper format
imgA = im2double(imgA);
imgA = im2gray(imgA);

imgB = im2double(imgB);
imgB = im2gray(imgB);

imgC = im2double(imgC);
imgC = im2gray(imgC);

%Get logical values of detection for kpdet
logical_detA_det = kpdet(imgA);
logical_detB_det = kpdet(imgB);
logical_detC_det = kpdet(imgC);

%Get kpdet detection counts for threshold tweaking
count_det_a = sum(logical_detA_det,'all')
count_det_b = sum(logical_detB_det,'all')
count_det_c = sum(logical_detC_det,'all')

%Get logical value of detection for fast algorithm
logical_detA_fast = kpfast(imgA,0.384,12);
logical_detB_fast = kpfast(imgB,0.384,12);
logical_detC_fast = kpfast(imgC,0.384,12);

%Respective counts for threshold tweaking
count_fast_a = sum(logical_detA_fast,'all')
count_fast_b = sum(logical_detB_fast,'all')
count_fast_c = sum(logical_detC_fast,'all')

%Get logical detection for fast algorithm with nms
logical_detA_fast_nms = kpfast_nms(imgA,0.384,12);
logical_detB_fast_nms = kpfast_nms(imgB,0.384,12);
logical_detC_fast_nms = kpfast_nms(imgC,0.384,12);

%Get respective counst for fast with nms
count_fast_nms_a = sum(logical_detA_fast_nms,'all')
count_fast_nms_b = sum(logical_detB_fast_nms,'all')
count_fast_nms_c = sum(logical_detC_fast_nms,'all')

%Plot detections for 3 different Algorithms: Classroom Image
[rows_detection,cols_detection] = find(logical_detA_det);
figure;
subplot(1, 3, 1);
imshow(imgA);hold on;
title('Kpdet A');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

[rows_detection,cols_detection] = find(logical_detA_fast);
subplot(1, 3, 2);
imshow(imgA);hold on;
title('Fast A');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

[rows_detection,cols_detection] = find(logical_detA_fast_nms);
subplot(1, 3, 3);
imshow(imgA);hold on;
title('Fast NMS A');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

%Plot detections for 3 different Algorithms: 1st Bricks Image
[rows_detection,cols_detection] = find(logical_detB_det);
figure;
subplot(1, 3, 1);
imshow(imgB);hold on;
title('Kpdet B');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

[rows_detection,cols_detection] = find(logical_detB_fast);
subplot(1, 3, 2);
imshow(imgB);hold on;
title('Fast B');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

[rows_detection,cols_detection] = find(logical_detB_fast_nms);
subplot(1, 3, 3);
imshow(imgB);hold on;
title('Fast NMS B');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

%Plot detections for 3 different Algorithms: 2nd Bricks Image
[rows_detection,cols_detection] = find(logical_detC_det);
figure;
subplot(1, 3, 1);
imshow(imgC);hold on;
title('Kpdet C');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

[rows_detection,cols_detection] = find(logical_detC_fast);
subplot(1, 3, 2);
imshow(imgC);hold on;
title('Fast C');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

[rows_detection,cols_detection] = find(logical_detC_fast_nms);
subplot(1, 3, 3);
imshow(imgC);hold on;
title('Fast NMS C');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

