function [matches, confidences] = kp_match_hamm(descs_1, descs_2, max_dist, lowe_ratio)
% kpmatch_hamming matches descriptors from the given descs_1 to the given
% descs_2 using Hamming distance with the given maximum distance and
% applies the given Lowe's ratio test.
%
% [matches, confidences] = kp_match_hamm(descs_1, descs_2, max_dist, lowe_ratio)
%
% Inputs:
%   - descs_1: [N_1 x 256] logical, binary descriptors for keypoints from the
%   first image
%   - descs_2: [N_2 x 246] logical, binary descriptors for keypoints from the
%   second image
%   - max_dist: double (0-256), maximum Hamming distance for matching
%   - lowe_ratio: double (0-1), Lowe's ratio threshold value for matching
%
% Outputs:
%   - matches: [M x 2] double, matching descriptor indices
%   - confidences: [M x 1] double, confidence scores for matches
%
% Uses:
%   - None
%
% Is Used:
%   - kp_orb

% Initialize mtaches and confidences
matches = [];
confidences = [];

% Get number of descriptors in descs_1 and descs_2
num_descs_1 = size(descs_1, 1);
num_descs_2 = size(descs_2, 1);

% Loop over descriptors in descs_1

for i = 1:num_descs_1
    
    % Get descriptor from descs_1
    desc_1 = descs_1(i, :);
    
    % Get Hamming distances to all descriptors in descs_2
    dists = sum(xor(desc_1, descs_2), 2);
    
    % Get distances sorted in ascending order
    [dists, idx] = sort(dists, 'ascend');
    
    % Get nearest neighbor distance and index in descs_2
    nn_dist = dists(1);
    nn_idx = idx(1);
    
    % Initialize second-nearest neighbor
    snn_dist = Inf;
    
    % Check if second-nearest neighbor exists

    if num_descs_2 > 1
        
        % Get second-nearest neighbor distance
        snn_dist = dists(2);
        
    end
    
    % Check if nearest neighbor distance is below the maximum
    
    if nn_dist > max_dist
        continue;
    end
    
    % Check if second nearest neighbor distance is below the ratio
    
    if nn_dist < lowe_ratio * snn_dist
        
        % Update matches
        matches = [matches; i, nn_idx];
        
        % Get confidence score
        confidence = (1 - nn_dist / max_dist) * (1 - lowe_ratio);
        
        % Update confidences
        confidences = [confidences; confidence];
    
    end
    
end

end


