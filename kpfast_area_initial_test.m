close all;
clear;
%%read images
img1 = imread('frames/frame_0260.png');
img2 = imread('frames/frame_0280.png');

%format files correctly
img1 = im2double(img1);
img1 = im2gray(img1);
img2 = im2double(img2);
img2 = im2gray(img2);

%Perform slight Gaussian
gauss = gkern(0.2);
img1_blurred = conv2(gauss,gauss,img1,'same');

%Get respective size of image
rows = size(img1,1);
cols = size(img1,2);

%Compute Area Mask
radius = 15;
patchsize = 2 * radius
%Initialize to all zeros then detract values to 0 in the following loop
circle_matrix = ones(patchsize);
for s = 1:(2*radius + 1)
    for t = 1:(2*radius + 1)
        if ((radius + 1 - s)^2 + (radius + 1 - t)^2) > radius^2
            %If its outside circle then set the value to zero
            circle_matrix(s,t) = 0;
        end
    end
end


circle_size = sum(circle_matrix,'all');
%Two tweakable values, whether the brightness strenght is strong enough:
%thresh
thresh = 0.15;
%Ratio required to deem the point a detection
desired_ratio = 0.75;
%Set valid bounds to deal with to not be outside the region
detection_matrix = zeros(rows - 2 * radius,cols - 2* radius);

%Iterate and be mindful of radius to not be out of bounds
%Iterate through rows
for i = 1:(rows - 2 * radius)
    end_i = i + (radius * 2);
    %Iterate through cols
    for j = 1:(cols - 2* radius)
        end_j = j + (radius * 2);
        %Get rectangular region
        patch = img1_blurred(i:end_i,j:end_j);
        %Apply circle mask
        circle = patch .* circle_matrix;
        %Get center point of the patch
        center_point_i = i + radius;
        center_point_j = j + radius;
        center_val = img1_blurred(center_point_i,center_point_j);
        
        %Find points greater than center value with tresh included
        greater_center_matrix = (circle - thresh) > center_val;
        greater_center_count = sum(greater_center_matrix,'all');
        
        %Find points less than center valuewith tresh included
        less_center_matrix = (circle < (center_val + thresh)) & (circle > 0);
        less_center_count = sum(greater_center_matrix,'all');
        
        %Determine ratio of points greater/less than center
        greater_ratio = greater_center_count/circle_size;
        less_ratio = less_center_count/circle_size;
        %If the value in regions have a lot of big or small values compared
        %to the center then its a detection
        if (less_ratio >= desired_ratio) | (greater_ratio >= desired_ratio)
           detection_matrix(center_point_i,center_point_j) = 1;
        end  
    end
end

%Get logical values of our algorithm
detection_matrix;
detection_count = sum(detection_matrix,'all')

%Display Detections from kpfast_area_intial
[rows_detection,cols_detection] = find(detection_matrix)
figure;
imshow(img1);hold on;
title('KpArea algorithm Test');
pause(0.6)
plot(cols_detection,rows_detection,'r+');

