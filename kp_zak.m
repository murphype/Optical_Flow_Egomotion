function zak_scores = kp_zak(img, kps)
% kpzak copmutes Zakrevskiy corner measures for the given keypoints
%
% zak_scores = kpzak(img, kps)
%
% Inputs:
%   - I: double grayscale image
%   - kps: [N x 2] double, keypoint coordinates
%
% Outputs:
%   - zak_scores: [N x 1] double, Zakrevskiy corner measures
%
% Uses:
%   - bresenham_3
%
% Is Used:
%   - None

% Get number of keypoints
num_kps = size(kps, 1);

% Initialize Zakrevskiy scores vector
zak_scores = zeros(num_kps, 1);

% Loop over the keypoints

for i = 1:num_kps
    
    % Get keypoint coordinates
    kp_coords = kps(i, :);
    
    % Get center pixel intensity
    I_c = img(kp_coords(2), kp_coords(1));
    
    % Initialize sum of squared intensities
    ssd = 0;
    
    % Loop over circle positions
    
    for pos = 1:16
        
        % Get circle pixel coordinates
        p_coords = bresenham_3(pos, kp_coords);
        
        % Get circle pixel intensity
        I_p = img(kp_coords(2) + p_coords(2), kp_coords(1) + p_coords(1));
        
        % Update sum of squared intensities
        ssd = ssd + (I_c - I_p)^2;
        
    end

    % Get Zakrevskiy response Z
    Z = sqrt(ssd);
    
    % Update Zakrevskiy scores
    zak_scores(i) = Z;
    
end

end


