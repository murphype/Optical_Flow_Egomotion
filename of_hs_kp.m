function of = of_hs_kp(I_1, I_2, varargin)
% of_hs_kp computes optical flow for the given two images using Horn-Schunck
% algorithm and keypoint initialization.
%
% of = of_hs(I_1, I_2, ...)
%
% Inputs:
%   - I_1, I_2: double grayscale images
%
% Outputs:
%   - of: double optical flow field [H x W x 2]
%
% Uses:
%   - scale_pyr
%   - of_energy_hs
%   - kp_orb_adv
%
% Is Used:
%   - None

% Parse parameters
p = inputParser;
addParameter(p, 'NumIterations', 100);
addParameter(p, 'Alpha', 9);
addParameter(p, 'Sigma', 1);
addParameter(p, 'PyrHeight', 4);
addParameter(p, 'PyrScale', 0.5);
parse(p, varargin{:});

% Initialize parameters
num_iterations = p.Results.NumIterations;
alpha = p.Results.Alpha;
sigma = p.Results.Sigma;
pyr_height = p.Results.PyrHeight;
pyr_scale = p.Results.PyrScale;

% Initialize averaging kernel
kern = [0 1 0; 1 0 1; 0 1 0] / 4;

% Get image size
[rows, cols] = size(I_1);

% Initialize optical flow
of = zeros(rows, cols, 2);

% Get keypoints, matches, confidences, and displacements using advanced ORB
[kps_1, kps_2, matches, confidences, displacements] = kp_orb_adv(I_1, I_2);

% Loop over matches

for i = 1:size(matches, 1)
    
    % Get keypoint coordinates
    x_1 = kps_1(matches(i, 1), 1);
    y_1 = kps_1(matches(i, 1), 2);
    
    % Initialize optical flow with keypoint confidences and displacements
    of(y_1, x_1, 1) = confidences(i) * displacements(i, 1);
    of(y_1, x_1, 2) = confidences(i) * displacements(i, 2);

end

% Build scale pyramids
pyr_1 = scale_pyr(I_1, pyr_height, pyr_scale);
pyr_2 = scale_pyr(I_2, pyr_height, pyr_scale);

% Loop over pyramid layers

for layer = pyr_height:-1:1
    
    % Get scaled images
    layer_I_1 = pyr_1{layer};
    layer_I_2 = pyr_2{layer};
    layer_scale = 1 * (pyr_scale ^ (layer - 1)); 
    
    % Get scaled optical flow
    layer_of = imresize(of, [size(layer_I_1, 1), size(layer_I_2, 2)]) * (1 / layer_scale);
    u = layer_of(:, :, 1);
    v = layer_of(:, :, 2);
    
    % Get averaged image
    I_avg = (layer_I_1 + layer_I_2) / 2;
    
    % Get smoothed image using Gaussian blurring
    I_gauss = conv2(gkern(sigma)', gkern(sigma), I_avg, 'same');
    
    % Get image gradients
    [I_x, I_y] = gradient(I_gauss);
    I_t = layer_I_2 - layer_I_1;

    % Perform iterative updates

    for iter = 1:num_iterations

        u_avg = conv2(u, kern, 'same');
        v_avg = conv2(v, kern, 'same');

        u = u_avg - I_x .* (I_x .* u_avg + I_y .* v_avg + I_t) ./ (I_x .^ 2 + I_y .^ 2 + alpha);
        v = v_avg - I_y .* (I_x .* u_avg + I_y .* v_avg + I_t) ./ (I_x .^ 2 + I_y .^ 2 + alpha);

        layer_of(:, :, 1) = u;
        layer_of(:, :, 2) = v;
        
        % Print out energy values
        fprintf("Iter %d: ", iter);
        of_hs_energy(layer_I_1, layer_I_2, layer_of, sigma, alpha);

    end
    
    % Get scaled optical flow
    of = imresize(layer_of, [rows, cols]) * layer_scale; 

end
    
end