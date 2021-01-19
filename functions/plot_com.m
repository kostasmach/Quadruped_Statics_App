function plot_com(x_cntr, y_cntr, R)
%PLOT_COM Plot the symbol of the CoM for the desired position and size

% Angle
angle = 0:0.01:pi/2;

% 4 Circular paths
x_circle = R*cos(angle);
y_circle = R*sin(angle);
x1 = x_cntr + x_circle;
y1 = y_cntr + y_circle;
x2 = x_cntr - x_circle;
y2 = y_cntr - y_circle;
x3 = x_cntr - x_circle;
y3 = y_cntr + y_circle;
x4 = x_cntr + x_circle;
y4 = y_cntr - y_circle;

% 4 Circular sectors
x1 = [x_cntr, x1, x_cntr];
y1 = [y_cntr, y1, y_cntr];
x2 = [x_cntr, x2, x_cntr];
y2 = [y_cntr, y2, y_cntr];
x3 = [x_cntr, x3, x_cntr];
y3 = [y_cntr, y3, y_cntr];
x4 = [x_cntr, x4, x_cntr];
y4 = [y_cntr, y4, y_cntr];

% Plot
hold on
fill(x1, y1,'k')
fill(x2, y2,'k')
fill(x3, y3,'w')
fill(x4, y4,'w')
%hold off
%axis equal

end

