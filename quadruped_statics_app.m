function quadruped_statics_app()
%QUADRUPED_STATICS_APP Launch the quadruped statics app
%	Author:         Konstantinos Machairas
%	Date:           2020
%   Description:    An application that calculates the statics of a
%                   quadruped depending on the geometrical, inertial and
%                   kinematic parameters inserted by the user. The app
%                   outputs the ground forces and the joint torques
%                   required for the given configuration and animates the
%                   result.                  

% Clear memory, close open windows, and clear the command window
clear all; close all; clc;

% Global scope
global posture geometry inertial
global knee_mechanism number_of_legs

% Add path
addpath('./functions')

% Initialize mass of all bodies. Each member of the inertial struct 
% contains the mass of a single body (i.e. a leg segment or the main body).
inertial.mb = 40;
inertial.mF1 = 1;
inertial.mF2 = 1;
inertial.mH1 = 1;
inertial.mH2 = 1;

% Initialize CoM positions
inertial.db = 1;
inertial.dF1 = 0.5;
inertial.dF2 = 0.5;
inertial.dH1 = 0.5;
inertial.dH2 = 0.5;

% Initialize Posture
posture.xdesF = 0;
posture.ydesF = -1;
posture.kneeFWF = -1;
posture.xdesH = 0;
posture.ydesH = -1;
posture.kneeFWH = -1;

% Initialize Geometry
geometry.lb = 2;
geometry.lF1 = 1;
geometry.lF2 = 1;
geometry.lH1 = 1;
geometry.lH2 = 1;

% Initialize configuration
knee_mechanism = 0;
number_of_legs = 4;

% Initialize figure
fig = figure(1);
fig.Visible = 'on';
fig.Units = 'normalized';
fig.OuterPosition = [0.15 0.15 0.7 0.7];
fig.Name = 'Quadruped Statics';
fig.NumberTitle = 'off';

% Print text
uicontrol(fig, 'Style', 'text', ...
    'String', 'Quadruped Statics App', ...
    'ForegroundColor','k', ...
    'FontSize', 20, ...
    'Units', 'normalized', ...
    'Position', [0.375 0.4 0.25 0.2]);

% Hit a key or Wait to continue
pause(0.2);

% Create panels in figure
for i = 1:7
    panel(i) = uipanel(fig, 'Visible', 'off', ...
        'BorderType', 'line', 'HighlightColor', [0.99, 0.99, 0.99]);
end

% Position the panels in figure
psize = [0.4, 0.3];             
panel(1).Position = [0, 0, psize(1), 0.1];
panel(2).Position = [0, psize(2)*2 + 0.1, psize(1)/2, psize(2)];
panel(3).Position = [psize(1)/2, psize(2)*2 + 0.1, psize(1)/2, psize(2)];
panel(4).Position = [0, psize(2)*1 + 0.1, psize(1), psize(2)];
panel(5).Position = [0, 0.1, psize(1), psize(2)];
panel(6).Position = [psize(1), 0.3, (1-psize(1)), 0.7];
panel(7).Position = [psize(1), 0, (1-psize(1)), 0.3];

% Create axes in panel 6
axes(panel(6));

% Run UIs in panels
ui_config(panel(1), panel(6), panel(7));
ui_kinematics(panel(5), panel(6), panel(7));
ui_inertial_1(panel(2), panel(6), panel(7));
ui_inertial_2(panel(3), panel(6), panel(7));
ui_geometry(panel(4), panel(6), panel(7));
ui_results(panel(7));

% Run statics once given the initial set of parameters
[torques, forces, angles] = quadruped_statics(...
    posture, geometry, inertial, knee_mechanism, number_of_legs);

% Update plot in panel 6
update_plot(panel(6), ...
    posture, geometry, inertial, ...
    torques, forces, angles);

% Update results in panel 7
update_results_text(panel(7), torques, forces, angles)

% Make panels visible
pause(0.5);
for i = 1:7
    panel(i).Visible = 'on';
end

end

