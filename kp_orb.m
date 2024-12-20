function [kps_1, kps_2, matches, confidences] = kp_orb(I_1, I_2, varargin)
% kp_orb computes ORB keypoints, matches, and confidences for two given
% images
%
% [kps1, kps2, matches] = kp_orb(I_1, I_2, ...)
%
% Inputs:
%   - I_1, I_2: grayscale double images
%
% Outputs:
%   - kps1: [N_1 x 2] double, keypoint coordinates in the first image
%   - kps2: [N_2 x 2] double, keypoint coordinates in the second image
%   - matches: [M x 2] double, matched keypoint indices
%   - confidences: [M x 1] double, matches confidences
%
% Uses:
%   - scale_pyr
%   - kp_fast_12
%   - kp_harris
%   - kp_nms
%   - kp_brief
%   - kp_match_hamm
%
% Is Used:
%   - kp_orb_adv

% Parse parameters
p = inputParser;
addParameter(p, 'PyrHeight', 4);
addParameter(p, 'PyrScale', 0.8);
addParameter(p, 'FASTThreshold', 0.12);
addParameter(p, 'HarrisK', 0.05);
addParameter(p, 'MaxKeypoints', 500);
addParameter(p, 'NMSMaxDistance', 10);
addParameter(p, 'HammingMaxDistance', 64);
addParameter(p, 'LoweRatio', 0.8);
parse(p, varargin{:});

% Initialize parameters
pyr_height = p.Results.PyrHeight;
pyr_scale = p.Results.PyrScale;
fast_thresh = p.Results.FASTThreshold;
harris_k = p.Results.HarrisK;
max_kps = p.Results.MaxKeypoints;
nms_max_dist = p.Results.NMSMaxDistance;
hamm_max_dist = p.Results.HammingMaxDistance;
lowe_ratio = p.Results.LoweRatio;

% Build scale pyramids
[pyr_1] = scale_pyr(I_1, pyr_height, pyr_scale);
[pyr_2] = scale_pyr(I_2, pyr_height, pyr_scale);

% Detect FAST keypoints at all scales
kps_1_all = [];
for layer = 1:pyr_height
    kps = kp_fast_12(pyr_1{layer}, fast_thresh);
    kps = round(kps / pyr_scale ^ (layer - 1));
    kps_1_all = [kps_1_all; kps];
end
kps_2_all = [];
for layer = 1:pyr_height
    kps = kp_fast_12(pyr_2{layer}, fast_thresh);
    kps = round(kps / pyr_scale ^ (layer - 1));
    kps_2_all = [kps_2_all; kps];
end

% Harris scoring
scores_1 = kp_harris(I_1, kps_1_all, harris_k);
scores_2 = kp_harris(I_2, kps_2_all, harris_k);

% Non-maximal suppression
[kps_1_nms, scores_1_nms] = kp_nms(kps_1_all, scores_1, nms_max_dist);
[kps_2_nms, scores_2_nms] = kp_nms(kps_2_all, scores_2, nms_max_dist);

% Limit to max keypoints
if size(kps_1_nms, 1) > max_kps
    [~, idx] = sort(scores_1_nms, 'descend');
    kps_1_nms = kps_1_nms(idx(1:max_kps), :);
end
if size(kps_2_nms, 1) > max_kps
    [~, idx] = sort(scores_2_nms, 'descend');
    kps_2_nms = kps_2_nms(idx(1:max_kps), :);
end

% Compute BRIEF descriptors
[descs_1, kps_1] = kp_brief(I_1, kps_1_nms);
[descs_2, kps_2] = kp_brief(I_2, kps_2_nms);

% Match BRIEF descriptors
[matches, confidences] = kp_match_hamm(descs_1, descs_2, hamm_max_dist, lowe_ratio);

end

