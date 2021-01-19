function update_plot(res_panel, posture, geometry, inertial, ...
    torques, forces, angles)
%UPDATE_PLOT Update the plot given the most recent parameters

% Calculate coordinates using forward kinematics
coords = forward_kinematics(geometry, inertial, angles);

% Get panel children
ax1 = get(res_panel, 'Children');

% Hold off
hold off

% Plot ground
fill(ax1, [-10, -10, 10, 10], [-3, 0, 0, -3], 'k', 'EdgeColor', 'k');
alpha(0.1);

% Hold on
hold on;

% Plot body
plot([coords.xjF1, coords.xjH1], ...
    [coords.yjF1 - (coords.yjF1 + coords.ytF), ...
    coords.yjH1 - (coords.yjF1 + coords.ytF)], ...
    'LineWidth', 2, 'color', 'k')

% Plot fore leg segments
plot([coords.xjF1, ...
    coords.xjF1 + coords.xjF2, ...
    coords.xjF1 + coords.xtF], ...
    [coords.yjF1 - (coords.yjF1 + coords.ytF), ...
    coords.yjF1 + coords.yjF2 - (coords.yjF1 + coords.ytF), ...
    coords.yjF1 + coords.ytF - (coords.yjF1 + coords.ytF)], 'k');

% Plot hind leg segments
plot([coords.xjH1, ...
    coords.xjH1 + coords.xjH2, ...
    coords.xjH1 + coords.xtH], ...
    [coords.yjH1 - (coords.yjF1 + coords.ytF), ...
    coords.yjH1 + coords.yjH2 - (coords.yjF1 + coords.ytF), ...
    coords.yjH1 + coords.ytH - (coords.yjF1 + coords.ytF)], 'k');

% Plot fore leg joints
plot(coords.xjF1, coords.yjF1 - (coords.yjF1 + coords.ytF), 'ko');
plot(coords.xjF1 + coords.xjF2, coords.yjF1 + coords.yjF2 - ...
    (coords.yjF1 + coords.ytF), 'ko');
plot(coords.xjF1 + coords.xtF, ...
    coords.yjF1 + coords.ytF - (coords.yjF1 + coords.ytF), 'ko');

% Plot hind leg joints
plot(coords.xjH1, coords.yjH1 - (coords.yjF1 + coords.ytF), 'ko');
plot(coords.xjH1 + coords.xjH2, ...
    coords.yjH1 + coords.yjH2 - (coords.yjF1 + coords.ytF), 'ko');
plot(coords.xjH1 + coords.xtH, ...
    coords.yjH1 + coords.ytH - (coords.yjF1 + coords.ytF), 'ko');

% Plot body CoM
plot_com(0, -(coords.yjF1 + coords.ytF), inertial.mb * 0.004);

% Plot fore segments' CoM
plot_com(coords.xjF1 + coords.xF1, ...
    coords.yjF1 + coords.yF1 - (coords.yjF1 + coords.ytF), ...
    inertial.mF1 * 0.04);
plot_com(coords.xjF1 + coords.xF2, ...
    coords.yjF1 + coords.yF2 - (coords.yjF1 + coords.ytF), ...
    inertial.mF2 * 0.04);

% Plot hind segments' CoM
plot_com(coords.xjH1 + coords.xH1, ...
    coords.yjH1 + coords.yH1 - (coords.yjF1 + coords.ytF), ...
    inertial.mH1 * 0.04);
plot_com(coords.xjH1 + coords.xH2, ...
    coords.yjH1 + coords.yH2 - (coords.yjF1 + coords.ytF), ...
    inertial.mH2 * 0.04);

% Plot fore leg torques
circular_arrow(gcf, 0.15, ...
    [coords.xjF1, coords.yjF1 - (coords.yjF1 + coords.ytF)], ...
    0, torque_to_arrow_angle(torques.tauF1), sign(torques.tauF1), 'r', 5);
circular_arrow(gcf, 0.15, ...
    [coords.xjF1 + coords.xjF2, ...
    coords.yjF1 + coords.yjF2 - (coords.yjF1 + coords.ytF)], ...
    0, torque_to_arrow_angle(torques.tauF2), sign(torques.tauF2), 'r', 5);

% Plot hind leg torques
circular_arrow(gcf, 0.15, ...
    [coords.xjH1, coords.yjH1 - (coords.yjF1 + coords.ytF)], ...
    0, torque_to_arrow_angle(torques.tauH1), sign(torques.tauH1), 'r', 5);
circular_arrow(gcf, 0.15, ...
    [coords.xjH1 + coords.xjH2, ...
    coords.yjH1 + coords.yjH2 - (coords.yjF1 + coords.ytF)], ...
    0, torque_to_arrow_angle(torques.tauH2), sign(torques.tauH2), 'r', 5);

% Plot ground forces
force_scale = 300;
quiver(coords.xjF1 + coords.xtF, ...
    coords.yjF1 + coords.ytF - (coords.yjF1 + coords.ytF), ...
    0, forces.NF/force_scale,'r');
quiver(coords.xjH1 + coords.xtH, ...
    coords.yjH1 + coords.ytH - (coords.yjF1 + coords.ytF), ...
    0, forces.NH/(force_scale),'r')

% Axes properties
axis(ax1, 'equal')
ax1.XLim = [-1.3*(geometry.lb - inertial.db + ...
    geometry.lH1 + geometry.lH2), ...
    1.3*(inertial.db + geometry.lF1 + geometry.lF2)];
% ax1.XLim = [-5, 5];
ax1.YLim = [-0.6, 3];

end

