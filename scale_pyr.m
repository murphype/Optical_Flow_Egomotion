function I_pyr = scale_pyr(I, height, scale)
% scalepyr produces a scale pyramid of the given image with the given
% height and scale
%
% img_pyr = scalepyr(I, height, scale)
%
% Inputs:
%   - I: double grayscale image
%   - height: positive integer, pyramid height
%   - scale: positive double, pyramid scale
%
% Outputs:
%   - I_pyr: cell of double matrices, array of grayscale images
%
% Uses:
%   - None
%
% Is Used:
%   - kp_orb
%   - of_hs
%   - of_hs_adv

% Initialize the cell for the pyramid
I_pyr = cell(height, 1);

% Loop over the layers
for layer = 1:height
    
    % Resize the image using bilinear interpolation for performance
    I_pyr{layer} = imresize(I, scale ^ (layer - 1), 'bilinear');
    
end

end