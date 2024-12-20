function p_coords = bresenham_3(pos, c_coords)
% bresenham_3 computes pixel coordinates at the given position in the
% Bresenham circle of radius 3 with the given center coordinates
%
% p_coords = bresenham_3(pos, c_coords)
%
% Inputs:
%   - pos: integer (1-16), position index
%   - c_coords: [1 x 2] double, center coordinates
%
% Outputs:
%   - p_coords: [1 x 2] double, pixel coordinates
%
% Uses:
%   - None
%
% Is used in:
%   - kp_fast_12

% Initialize circle coordinates matrix
circle_coords = [
    0, -3;     % pos 1
    1, -3;     % pos 2
    2, -2;     % pos 3
    3, -1;     % pos 4
    3, 0;      % pos 5
    3, 1;      % pos 6
    2, 2;      % pos 7
    1, 3;      % pos 8
    0, 3;      % pos 9
    -1, 3;     % pos 10
    -2, 2;     % pos 11
    -3, 1;     % pos 12
    -3, 0;     % pos 13
    -3, -1;    % pos 14
    -2, -2;    % pos 15
    -1, -3;    % pos 16
];

% Get pixel coordinates
p_coords = c_coords + circle_coords(pos, :);

end