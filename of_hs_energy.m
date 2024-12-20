function of_hs_energy(I_1, I_2, of, sigma, alpha)
% of_hs_energy Computes and prints brightness, smoothness, and total energies.
%
% of_energy_hs(I1, I2, of, alpha)
%
% Inputs:
%   - I_1, I_2: double grayscale images [H x W]
%   - of: double optical flow field [H x W x 2]
%   - alpha: positive double, smoothness weight
%
% Outputs:
%   - None (prints out energy values to the command window)
%
% Uses:
%   - None
%
% Is Used:
%   - of_hs
%   - of_hs_kp

% Get averaged image
I_avg = (I_1 + I_2) / 2;

% Get smoothed image using Gaussian blurring
I_gauss = conv2(gkern(sigma)', gkern(sigma), I_avg, 'same');

% Get image gradients
[I_x, I_y] = gradient(I_gauss);
I_t = I_2 - I_1;

% Get optical flow
u = of(:, :, 1);
v = of(:, :, 2);

% Get optical flow gradients
[u_x, u_y] = gradient(u);
[v_x, v_y] = gradient(v);

% Compute brightness term energy
E_bright = sum((I_x .* u + I_y .* v + I_t) .^ 2, 'all');

% Compute smoothness term energy
E_smooth = sum(u_x .^ 2 + u_y .^ 2 + v_x .^ 2 + v_y .^ 2, 'all');

% Compute total energy
E_total = E_bright + alpha * E_smooth;

% Print out energy values to the command window
fprintf('E_hs = %.3f, E_bright = %.3f, E_smooth = %.3f\n', E_total, E_bright, E_smooth);

end