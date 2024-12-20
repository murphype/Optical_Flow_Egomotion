function [kps_nms, scores_nms] = kp_nms(kps, scores, max_dist)
% kp_nms applies non-maximal suppression of the given keypoints using the
% given scores and maximum distance
%
% [kps_nms, scores_nms] = kpnms(kps, scores, max_dist)
%
% Inputs:
%   - kps: [N x 2] double, keypoint coordinates
%   - scores: [N x 1] double, keypoint scores
%   - max_dist: positive double, maximum distance for suppression
%
% Outputs:
%   - kps_nms: [M x 2] double, keypoints after NMS
%   - scores_nms: [M x 1] double, keypoint scores after NMS
%
% Uses:
%   - None
%
% Is Used:
%   - kp_orb

% Get number of keypoints
num_kps = size(kps, 1);

% Check if no keypoints
if num_kps == 0
    
    kps_nms = [];
    scores_nms = [];
    
    return;
    
end

% Get keypoints sorted by descending score
[~, idx] = sort(scores, 'descend');
kps = kps(idx, :);
scores = scores(idx);

% Initialize keypoint selection state
is_selected = false(num_kps);
selected_kps = [];

% Loop over keypoints

for i = 1:num_kps
    
    % Get keypoint coordinates
    kp_coords = kps(i, :);

    % Check if no selected keypoints
    
    if isempty(selected_kps)
        
        % Update selected keypoints
        is_selected(i) = true;
        selected_kps = kp_coords;
        
    else
        
        % Get distances to all selected keypoints
        dists = sqrt(sum((selected_kps - kp_coords) .^ 2, 2));
        
        % Check if all keypoints are distant enough

        if all(dists > max_dist)
            
            % Update selected keypoints
            is_selected(i) = true;
            selected_kps = [selected_kps; kp_coords];
            
        end
    
    end
    
end

kps_nms = kps(is_selected, :);
scores_nms = scores(is_selected);

end


