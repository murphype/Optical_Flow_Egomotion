function displacements = kp_disp(kps_1, kps_2, matches)
% kp_disp computes displacements between given keypoints with given matches
%
% displacements = kp_disp(kps_1, kps_2, matches)
%
% Inputs:
%   - kps_1: [N_1 x 2] double, keypoints from the first image
%   - kps_2: [N_2 x 2] double, keypoints from the second image
%   - matches: [M x 2] double, keypoint matches
%
% Outputs:
%   - displacements: [M x 2] double, displacement vectors (u, v) for the
%   matching keypoints
%
% Uses:
%   - None
%
% Is Used:
%   - kp_orb

% Initialize displacements matrix
displacements = zeros(size(matches, 1), 2);

% Loop over matches

for i = 1:size(matches, 1)
    
    % Get keypoint indices
    idx_1 = matches(i, 1);
    idx_2 = matches(i, 2);
    
    % Get keypoint coordinates
    y_1 = kps_1(idx_1, 1);
    x_1 = kps_1(idx_1, 2);
    y_2 = kps_2(idx_2, 1);
    x_2 = kps_2(idx_2, 2);
    
    % Get displacements
    u = x_2 - x_1;
    v = y_2 - y_1;
    
    % Update displacements
    displacements(i, :) = [u, v];
    
end

end


