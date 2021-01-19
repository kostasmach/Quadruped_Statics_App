%% This is an example of how to use the circular_arrow function
% Run this script to demonstrate the use of the circular_arrow function
% Set values desired for first arrow
radius = 1; % Height from top to bottom
centre = [0 0];
arrow_angle = 0; % Desired orientation angle in degrees
angle = 170; % Anglebetween start and end of arrow
direction = 1; % for CW enter 1, for CCW enter 0
colour = 'k'; % Colour of arrow
head_size = 10; % Arrow head size
% Create a basic plot
x = 0:1:10;
y = x;
plot(x,y);
figHandle = figure(1); % Needs a handle
axis equal;
title('Example of using the circular_arrow function');
xl = xlim;
xlim([xl(1)-3, xl(2)+3]);
hold on;    % needs hold on 
% call function
circular_arrow(figHandle, radius, centre, arrow_angle, angle, direction, colour, head_size);
% draw another green arrow with two bigger heads and CCW
circular_arrow(figHandle, 2, [5 5], 90, 300, 2, 'g', 10);
% draw another arrow without suppling the optional arguments
circular_arrow(figHandle, 1, [8 1], 45, 110, 1);
% draw another pink arrow with an alternative head head
circular_arrow(figHandle, 3, [9 9], 135, 45, 1, [1 0.4 0.6], 20, 'rose');
