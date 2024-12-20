% Get images

I_1 = im2gray(im2double(imread("/home/sulimovn/csc262/project_final/images/blender_001.png")));
I_2 = im2gray(im2double(imread("/home/sulimovn/csc262/project_final/images/blender_002.png")));

% Tweakables
% pyr_height = 4;
% pyr_scale = 0.8;
% fast_thresh = 0.12;
% harris_k = 0.05;
% max_kps = 500;
% nms_max_dist = 10;
% hamm_max_dist = 64;
% lowe_ratio = 0.8;

[kps_1, kps_2, matches, confidences] = kp_orb(I_1, I_2);

% Display matches

[rows_1, cols_1] = size(I_1);
[rows_2, cols_2] = size(I_2);

canvas_rows = max(rows_1, rows_2);
canvas_cols = cols_1 + cols_2;

canvas = zeros(canvas_rows, canvas_cols, 'double');
canvas(1:rows_1, 1:cols_1) = I_1;
canvas(1:rows_2, cols_1 + 1:end) = I_2;

figure(1);
imshow(canvas);
hold on;

kps_2_adj = kps_2;
kps_2_adj(:, 1) = kps_2_adj(:, 1) + cols_1;

plot(kps_1(:, 1), kps_1(:, 2), 'r+');
plot(kps_2_adj(:, 1), kps_2_adj(:, 2), 'r+');

for i = 1:size(matches, 1)
    p_1 = kps_1(matches(i, 1),:);
    p_2 = kps_2_adj(matches(i, 2),:);
    line([p_1(1) p_2(1)], [p_1(2) p_2(2)], 'Color', 'y');
end

title(sprintf('ORB Matches: %d', size(matches,1)));
hold off;


