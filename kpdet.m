function kpdet_logical = kpdet(image)
%KPDET returns a logical matrix representing detected features of input
%image (grayscale double matrix)
%   We create vertical and horizontal partial derivatives of the input
%   image and the generate the corresponding 3 entries for our matrix:
%   horizontal partial squared, vertical partial squared, vertical times
%   horizontal partial. After blurring these matrices, we compute the
%   determinant and trace from their respective formulas. Lastly, we find
%   the ratio between the determinant and the trace, and then find the
%   thresholded (values greater than 4e-3) areas and maxima. Note the sigma
%   for our Gauss for the partial derivatives is 1, and for blurring in the
%   later stage is 1.5.

    % calculate Gaussian kernals
    sigma = 1;
    gauss = gkern(sigma);
    dgauss = gkern(sigma, 1);
    larger_sigma = 1.5;
    larger_gauss = gkern(larger_sigma);

    % calculate image partial derivatives
    I_x = conv2(gauss, dgauss, image, 'same');
    I_y = conv2(dgauss, gauss, image, 'same');

    % calculate values required for the determinant and trace
    I_xx = I_x .^ 2;
    I_yy = I_y .^ 2;
    I_xy = I_x .* I_y;

    % blur values required for the determinant and trace
    I_xx_blurred = conv2(I_xx, larger_gauss, 'same');
    I_yy_blurred = conv2(I_yy, larger_gauss, 'same');
    I_xy_blurred = conv2(I_xy, larger_gauss, 'same');
    
    % determinant calculation (as per Jerod Weinman's instructions)
    image_det = (I_xx_blurred .* I_yy_blurred) - (I_xy_blurred .^ 2);
    % trace calculation (as per Jerod Weinman's instructions)
    image_trace = I_xx_blurred + I_yy_blurred;
    % ratio calculation (as per Jerod Weinman's instructions)
    image_ratio = image_det ./ image_trace;
    
    % threshold and max, chosen threshold based on cameraman image
    threshold = 4e-3;
    threshold_areas = image_ratio > threshold;
    max_areas = maxima(image_ratio);
    
    % thresholded logical matrix
    kpdet_logical = threshold_areas .* max_areas;
    
end

