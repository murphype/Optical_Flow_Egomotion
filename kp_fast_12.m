function kps = kp_fast_12(I, thresh)
% kp_fast_12 detects keypoints using FAST with 12 contiguous pixels and the
% given threshold
%
% kps = kp_fast_12(I, thresh)
%
% Inputs:
%   - I: double greyscale image
%   - thresh: positive double, threshold value for detection
%
% Outputs:
%   - kps: [N x 2] double, keypoints coordinates
%
% Uses:
%   - bresenham_3
%
% Is used in:
%   - kp_orb

% Get image size
[rows, cols] = size(I);

% Initialize keypoints map
kps_map = zeros(rows, cols);

% Initialize high-speed test positions
test_pos = [1, 5, 9, 13];

% Loop over in-bounds pixels

for y = 4:(rows - 3)

    for x = 4:(cols - 3)

        % Get center pixel intensity
        I_c = I(y, x);

        % Initialize test pixels intensities
        I_test = zeros(4, 1);
        
        % Loop over test positions

        for i = 1:4

            pos = test_pos(i);

            % Get pixel coordinate at test position
            p_coords = bresenham_3(pos, [x, y]);

            % Get test pixel intensity
            I_test(pos) = I(p_coords(2), p_coords(1));

        end

        % Count how many are significantly brighter or darker
        brighter = sum(I_test > I_c + thresh);
        darker = sum(I_test < I_c - thresh);

        % Check if at least three are significantly brighter or darker
        
        if brighter >= 3 || darker >= 3

            % Initialize circle pixels intensities
            I_circle = zeros(16, 1);

            % Loop over circle positions
            
            for pos = 1:16

                % Get pixel coordinate at circle position
                p_coords = bresenham_3(pos, [x, y]);

                % Get circle pixel intensity
                I_circle(pos) = I(p_coords(2), p_coords(1));

            end

            % Initialize extended circle pixels intensities
            I_circle_ext = [I_circle; I_circle(1:11)];

            % Count contiguous brighter and darker pixels
            brighter = 0;
            darker = 0;
            
            % Loop over extended circle positions
            
            for pos = 1:27

                % Check if significantly brighter
                
                if I_circle_ext(pos) > I_c + thresh
                    
                    % Update brighter count
                    brighter = brighter + 1;
                    
                    % Check if at least twelve contiguous are signficantly
                    % brighter
                    if brighter >= 12
                        
                        % Update keypoints map                   
                        kps_map(y, x) = 1;
                        
                        break;
                        
                    end

                else
                    
                    % Reset brighter count
                    brighter = 0;
                    
                end
                
                % Check if significantly darker

                if I_circle_ext(pos) < I_c - thresh  
                    
                    % Update darker count
                    darker = darker + 1;
                    
                    % Check if at least twelve contiguous are signficantly
                    % darker
                    if darker >= 12
                        
                        % Update keypoints map                   
                        kps_map(y, x) = 1;
                        
                        break;
                        
                    end

                else
                    
                    % Reset darker count
                    darker = 0;
                    
                end
                
            end

        end

    end

end

% Extract keypoints coordinates from keypoints map
[cols, rows] = find(kps_map);
kps = [rows, cols];

end


