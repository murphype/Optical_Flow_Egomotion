function har_scores = kp_harris(I, kps, k)
% kp_harris computes Harris corner measures for the given keypoints with the
% given Harris detector free parameter
%
% har_scores = kp_harris(I, kps, k)
%
% Inputs:
%   - I: double grayscale image
%   - kps: [N x 2] double, keypoint coordinates
%   - k: positive double, Harris detector free parameter
%
% Outputs:
%   - har_scores: [N x 1] double, Harris corner measures
%
% Uses:
%   - None
%
% Is used in:
%   - kp_orb

% Get number of keypoints
num_kps = size(kps, 1);

% Initialize Harris scores vector
har_scores = zeros(num_kps, 1);

% Get image derivatives using Sobel operators
I_x = imfilter(I, [-1 0 1; -2 0 2; -1 0 1], 'replicate');
I_y = imfilter(I, [-1 -2 -1; 0 0 0; 1 2 1], 'replicate');

% Get derivatives products using Gaussian blur
I_xx = conv2(gkern(3)', gkern(3), I_x .^ 2, "same");
I_yy = conv2(gkern(3)', gkern(3), I_y .^ 2, "same");
I_xy = conv2(gkern(3)', gkern(3), I_x .* I_y, "same");

% Loop over keypoints

for i = 1:num_kps
    
    % Get keypoint coordinates
    kp_x = kps(i, 1);
    kp_y = kps(i, 2);
    
    % Get Harris matrix M
    M = [I_xx(kp_y, kp_x), I_xy(kp_y, kp_x); I_xy(kp_y, kp_x), I_yy(kp_y, kp_x)];
    
    % Get Harris response R
    R = det(M) - k * (trace(M))^2;
    
    % Update Harris scores
    har_scores(i) = R;

end

end


