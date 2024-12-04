function corners = kpfast(image, t, n)



% FAST_detector We detect corner points from a given image using the FAST
% algorithm
%
% Our inputs are an image which is a grayscale double matrix/image. We also
% have threshold t which determines how much greater/smaller of a pixel
% brightness value we need to have compared to the center point. Lastly n
% is the number of contiguous pixels we need to have in a row to be
% considered a valid match.
%
% Our outputs is 2d matrix of 0s and 1s correspoding to whether the pixel
% is a detection

% Get image dimensions
[rows, cols] = size(image);

% Set the detection matrix
corners = zeros(rows, cols);

% Instead of defining a square region and ignoring certain values... we
% directly have a set of offsets to only iterate over the necessary
% circumference points.
circle_offsets = [
    0, -3;  
    1, -3;  
    2, -2;  
    3, -1;  
    3, 0;   
    3, 1;   
    2, 2;   
    1, 3;   
    0, 3;   
    -1, 3;  
    -2, 2;  
    -3, 1;  
    -3, 0;  
    -3, -1; 
    -2, -2; 
    -1, -3  
];

% Loop over image pixels, avoiding border pixels
for y = 4 : rows - 3  % Start from 4 to avoid going out of bounds
    for x = 4 : cols - 3
        % Get brightness value of the center pixel p
        center_point = image(y, x);
        
        % Important: this is the initial to check to throw away non-detections which is good for performance
        I1  = image(y + circle_offsets(1,2), x + circle_offsets(1,1));  % Up
        I5  = image(y + circle_offsets(5,2), x + circle_offsets(5,1));  % Right
        I9  = image(y + circle_offsets(9,2), x + circle_offsets(9,1));  % Down
        I13 = image(y + circle_offsets(13,2), x + circle_offsets(13,1)); % Left
        
        % How many points brighter than center
        brighter = (I1 > center_point + t) + (I5 > center_point + t) + (I9 > center_point + t) + (I13 > center_point + t);
        % How many points darker than center
        darker = (I1 < center_point - t) + (I5 < center_point - t) + (I9 < center_point - t) + (I13 < center_point - t);
        
        % Check if at least three are brighter or darker
        if brighter >= 3 || darker >= 3
            % We now do the full competition since the initial check is
            % valid
            % Initialize an array to hold the result for each of the 16 circumference pixels
            result = zeros(16,1);
            
            for k = 1:16
                % Get indices of circumference
                dx = circle_offsets(k,1);
                dy = circle_offsets(k,2);
                % Get value of current circumference pixel
                circum_point = image(y + dy, x + dx);
                % Check if circum_point is brighter than center_point and thresh
                if circum_point > center_point + t
                    result(k) = 1;  % brighter
                elseif circum_point < center_point - t
                    result(k) = -1; % darker
                else
                    result(k) = 0;  % within the thresh
                end
            end
            
            % Now check for n contiguous pixels that are all 1 or all -1
            % Deal with loop around the circle
            extended_result = [result; result(1:n-1)];
            
            % Check for contiguous brighter pixels
            bright_count = 0;
            for k = 1:length(extended_result)
                if extended_result(k) == 1
                    bright_count = bright_count + 1;
                    if bright_count >= n
                        % Found n contiguous brighter pixels
                        corners(y, x) = 1;
                        break;
                    end
                else
                    bright_count = 0;
                end
            end
            
            % If not found, check for contiguous darker pixels
            if corners(y, x) == 0
                dark_count = 0;
                for k = 1:length(extended_result)
                    if extended_result(k) == -1
                        dark_count = dark_count + 1;
                        if dark_count >= n
                            % Found n contiguous darker pixels
                            corners(y, x) = 1;
                            break;
                        end
                    else
                        dark_count = 0;
                    end
                end
            end
        end
        % Else, p is not a corner and we leave 0 in the matrix
    end
end

% Corners returned as a matrix

end
