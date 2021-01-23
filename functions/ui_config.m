function ui_config(parent_panel, plot_panel, results_panel)
%UI_CONFIG Run a gui controlling the model configuration in a given panel

% Global scope
global posture geometry inertial
global knee_mechanism number_of_legs

% Create panel inside the parent panel (used to improve appearance)
psize = [0.9, 0.9];
panel = uipanel(parent_panel, 'Visible', 'off', 'Title', 'Options', ...
    'ForegroundColor', 'b', 'BorderType', 'none', ...
    'Position', [(1-psize(1))/2, (1-psize(2))/2, psize(1), psize(2)]);

% Position and size parameters
size_button = [0.125, 0.8];         % Button relative size
pos_buttons = [0.75, 1];            % Button relative position

% Create radio button group (knee actuation)
rb_group_1 = uibuttongroup(panel, 'Visible', 'on', ...
    'BorderType', 'line', 'HighlightColor', [0.8, 0.8, 0.8], ...
    'Position', [0, 0.15, 0.5, size_button(2)], ...
    'SelectionChangedFcn', @select_knee_act);

% Create radio buttons in the button group
rb1_gr1 = uicontrol(rb_group_1, 'Style', 'togglebutton', ...
    'String', 'Serial Knee Actuation', 'Units', 'normalized', ...
    'Position', [0, 0, 0.5, 1], 'HandleVisibility', 'on');

rb2_gr1 = uicontrol(rb_group_1, 'Style', 'togglebutton', ...
    'String', '5-Bar Knee Actuation', 'Units', 'normalized', ...
    'Position', [0.5, 0, 0.5, 1], 'HandleVisibility', 'on');

% Create radio button group (number of legs on the ground)
rb_group_2 = uibuttongroup(panel, 'Visible', 'on', ...
    'BorderType', 'line', 'HighlightColor', [0.8, 0.8, 0.8], ...
    'Position', [0.5, 0.15, 0.5, size_button(2)], ...
    'SelectionChangedFcn', @select_no_of_legs);

% Create radio buttons in the button group
rb1_gr2 = uicontrol(rb_group_2, 'Style', 'togglebutton', ...
    'String', '4 Legs on Ground', 'Units', 'normalized', ...
    'Position', [0, 0, 0.5, 1], 'HandleVisibility', 'on');

rb2_gr2 = uicontrol(rb_group_2, 'Style', 'togglebutton', ...
    'String', '2 Legs on Ground', 'Units', 'normalized', ...
    'Position', [0.5, 0, 0.5, 1], 'HandleVisibility', 'on');

% Make panel visible
panel.Visible = 'on';

%-------------------------------------------------------------------------%
% Functions
%-------------------------------------------------------------------------%
    % Run statics and update results
    function update_results()
        % Run statics
        [torques, forces, angles] = quadruped_statics(...
            posture, geometry, inertial, knee_mechanism, number_of_legs);
        
        % Update results
        update_results_text(results_panel, torques, forces, angles);
        
        % Update plot in plot panel
        update_plot(plot_panel, ...
            posture, geometry, inertial, ...
            torques, forces, angles);
    end

    % Radio button clb (knee actuation)
    function select_knee_act(~, event)
        if  strcmp(event.NewValue.String, 'Serial Knee Actuation')
            knee_mechanism = 0;
        elseif strcmp(event.NewValue.String, '5-Bar Knee Actuation')
            knee_mechanism = 1;
        end
        update_results();
    end

    % Radio button clb (number of legs on the ground)
    function select_no_of_legs(~, event)
        if event.NewValue.String == '4 Legs on Ground'
            number_of_legs = 4;
        elseif event.NewValue.String == '2 Legs on Ground'
            number_of_legs = 2;
        end
        update_results();
    end

end