function orientations = kp_orient(I, kps)
% kporient computes orientations for the given keypoints from the given
% image using intensity centroids and Rosin moments
% 
% orientations = kporient(img, kps)
%
% Inputs:
%   - I: double greyscale image
%   - kps: [N x 2] double, keypoint coordinates
%
% Outputs:
%   - orientations: [N x 1] double, keypoint orientations

% Get number of keypoints
num_kps = size(kps, 1);

% Initialize orientations vector
orientations = zeros(size(kps, 1), 1);

% Get patch size (radius) for moments
patch_size = 15;

% Loop over keypoints

for i = 1:num_kps
    
    x = kps(i, 1);
    y = kps(i, 2);

    % Check if keypoint is out of bounds
    
    if x - patch_size < 1 || x + patch_size > size(I, 2) || y - patch_size < 1 || y + patch_size > size(I, 1)
   
            orientations(i) = NaN;
            
            continue;
        
    end
    
    [X, Y] = meshgrid(- patch_size:patch_size, - patch_size:patch_size);

    % Extract square patch
    square_patch = I(y - patch_size:y + patch_size, x - patch_size:x + patch_size);

    % Get circle mask
    circle_mask = (X.^2 + Y.^2) <= patch_size^2;
    
    % Extract circle patch
    circle_patch = square_patch .* circle_mask;
    
    % Get Rosin moments
    m_10 = sum(X .* circle_patch, 'all');
    m_01 = sum(Y .* circle_patch, 'all');

    % Get orientation
    orientation = atan2(m_01, m_10);
    
    % Update orientations
    orientations(i) = orientation;
    
end

end
