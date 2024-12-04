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
        % Get the intensity of the center pixel p
        center_point = image(y, x);
        
        % Important: this is the initial to check to throw away non-detections which is good for performance
        I1  = image(y + circle_offsets(1,2), x + circle_offsets(1,1));  %Up
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
            % Initialize an array to hold the result for each of the 16
            % circumference pixels
            result = zeros(16,1);
            
            %Consider the sum of the brightness, used to calculate mean as
            %strength
            sum_brightnesses = 0;
            for k = 1:16
                % Get indices of circumference
                dx = circle_offsets(k,1);
                dy = circle_offsets(k,2);
                % Get value of current circumference pixel
                circum_point = image(y + dy, x + dx);
                % Add the points value to the iterative sum
                sum_brightnesses = sum_brightnesses + circum_point;
                % Check if circum_point is brighter than center_point and thresh
                if circum_point > center_point + t
                    result(k) = 1;  % Brighter
                elseif circum_point < center_point - t
                    result(k) = -1; % Darker
                else
                    result(k) = 0;  % with the thresh
                end
            end
            
            %We now compute the avg brightness and take the absolute value
            %since both brighter and darker are valid
            avg_brightness = sum_brightnesses/16;
            avg_distance_positive = abs(avg_brightness - center_point);
            
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
                        %Instead notive we put the avg_distance as our
                        %strenght value instead of 1
                        corners(y, x) = avg_distance_positive;
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
                            %Instead notive we put the avg_distance as our
                            %strenght value instead of 1
                            corners(y, x) = avg_distance_positive;
                            break;
                        end
                    else
                        dark_count = 0;
                    end
                end
            end
        end
        % Else, p is not a corner (corners(y, x) remains 0)
    end
end
%We now perform our nms algorithm using the strenght values in our corner
%matrix
radius = 3;
[x_detections, y_detections] = find(corners);
%Iterate through all our detections
for i = 1:length(x_detections)
    x_index_1 = x_detections(i);
    y_index_1 = y_detections(i);
    first_point_value = corners(x_index_1,y_index_1);
    max_val = first_point_value;
    
    %Iterate to find other points
    for j = 1:length(x_detections)
        if i ~= j  % Avoid point itself
            x_index_2 = x_detections(j);
            y_index_2 = y_detections(j);
            
            % Calculate the Euclidean distance between current and other
            % point
            distance = sqrt((x_index_2 - x_index_1)^2 + (y_index_2 - y_index_1)^2);
            
            % Check if the distance is within the radius we defined at the
            % beginning of the nms block
            if distance <= radius
                %If we are within the radius we are very close to the
                %current target point, we thus get the strength value
                second_point_value = corners(x_index_2,y_index_2);
                if second_point_value > max_val;
                    %If this strength is greater then max, it is a better
                    %detection than another point that is close to it
                    %Set the other point to 0 since its not strong enough
                    corners(x_index_1,y_index_1) = 0;
                    %Save the current point in case it gets 'overpowered'
                    %and replaced again
                    x_index_1 = x_index_2;
                    y_index_1 = y_index_2;
                    max_val = second_point_value;
                end
            end
        end
    end
end
%Convert strength values back to 1 so we can display and use the detection
%points
corners(corners ~= 0) = 1;
%Return detection matrix

end


