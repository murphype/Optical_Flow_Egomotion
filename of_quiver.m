function of_quiver(I, of, step, scale, title_text)
% of_quiver visualizes the given optical flow field over the given image
% using quiver with the given step and scale.
%
% of_quiver(I, of, step, scale)
%
% Inputs:
%   - I: double grayscale image [H x W]
%   - of: double optical flow field [H x W x 2]
%   - step: positive integer, step for quiver
%   - scale: positive double, scale for quiver
%   - title_text: string, text for title
%
% Outputs:
%   - None
%
% Uses:
%   - None
%
% Is Used:
%   - None

% Get image size and grid coordinates
[rows, cols] = size(I);
[X, Y] = meshgrid(1:cols, 1:rows);

% Downsample grid for quiver visualization
X_sample = X(1:step:end, 1:step:end);
Y_sample = Y(1:step:end, 1:step:end);

% Downsample optical flow components
U_sample = of(1:step:end, 1:step:end, 1);
V_sample = of(1:step:end, 1:step:end, 2);

% Display image
figure();
imshow(I);
hold on;

% Overlay optical flow quiver
quiver(X_sample, Y_sample, U_sample, V_sample, scale);

% Add title
title(title_text);

hold off;

end
