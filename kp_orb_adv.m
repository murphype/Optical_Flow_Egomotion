function [kps_1, kps_2, matches, confidences, displacements] = kp_orb_adv(I_1, I_2, varargin)
% kp_orb_adv computes ORB keypoints, matches, confidences, and
% displacements for two given images
%
% [kps_1, kps_2, matches, confidences, displacements] = kp_orb_adv(I1, I2,
% ...)
%
% Inputs:
%   - I1, I2: grayscale double images
%
% Outputs:
%   - kps1: [N_1 x 2] double, keypoint coordinates in the first image
%   - kps2: [N_2 x 2] double, keypoint coordinates in the second image
%   - matches: [M x 2] double, matchied keypoint indices
%   - confidences: [M x 1] double, matches confidences
%   - displacements: [M x 2] double, [u, v], matches displacements
%
% Uses:
%   - kp_orb
%   - kp_disp
%
% Is Used:
%   - of_hs_kp

% Get matches and keypoints using ORB
[kps_1, kps_2, matches, confidences] = kp_orb(I_1, I_2, varargin{:});

% Get matches displacements
displacements = kp_disp(kps_1, kps_2, matches);

end