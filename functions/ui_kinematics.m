function ui_kinematics(parent_panel, plot_panel, results_panel)
%UI_KINEMATICS Run a gui controlling the model kinematics in a given panel

% Global scope
global posture geometry inertial
global knee_mechanism number_of_legs

% Create panel inside the parent panel (used to improve appearance)
psize = [0.9, 0.9];
panel = uipanel(parent_panel, 'Visible', 'off', 'Title', 'Kinematics', ...
    'ForegroundColor', 'b', 'BorderType', 'none', ...
    'Position', [(1-psize(1))/2, (1-psize(2))/2, psize(1), psize(2)]);

% Position and size parameters
size_text = [0.5, 0.2];             % Text field relative size
size_edit = [0.25, 0.2];            % Edit field relative size
size_button = [0.125, 0.2];         % Button relative size
pos_text = [0, 1];                  % Text field relative position
pos_edit = [0.5, 1];                % Edit field relative position
pos_buttons = [0.75, 1];            % Button relative position
text_size = 8;                      % Text size

% Number of first 4 ui rows. 5 rows in total. First 4 rows are identical;
% Each one includes 1 text field, 1 edit field, and 2 buttons
ui_rows_number = 4;

% Add text (use "edit" to achieve vert allignement not supported in 'text')
for k = 1:ui_rows_number
    text_field(k) = uicontrol(panel, 'Style', 'edit', 'Enable', 'off', ...
        'FontSize', text_size, 'Units', 'normalized', ...
        'Position', [pos_text(1), pos_text(2)-k*size_text(2), ...
        size_text(1), size_text(2)]);
end

% Add strings
text_field(1).String = 'Fore Toe x [m] wrt hip';
text_field(2).String = 'Fore Toe y [m] wrt hip';
text_field(3).String = 'Hind Toe x [m] wrt hip';
text_field(4).String = 'Hind Toe y [m] wrt hip';

% Add edit fields in panel
for k = 1:ui_rows_number
    edit_field(k) = uicontrol(panel, 'Style', 'edit', ...
        'FontSize', text_size, 'Units', 'normalized', ...
        'Position', [pos_edit(1), pos_edit(2)-k*size_edit(2), ...
        size_edit(1), size_edit(2)]);
end

% Fill edit fields with defaults
edit_field(1).String = posture.xdesF;
edit_field(2).String = posture.ydesF;
edit_field(3).String = posture.xdesH;
edit_field(4).String = posture.ydesH;

% Define edit field callbacks
edit_field(1).Callback = @edit_xdesF;
edit_field(2).Callback = @edit_ydesF;
edit_field(3).Callback = @edit_xdesH;
edit_field(4).Callback = @edit_ydesH;

% Add buttons in the first column
for k = 1:ui_rows_number
    button(k) = uicontrol(panel, 'Style', 'pushbutton', ...
        'FontSize', text_size, 'Units', 'normalized', ...
        'Position', [pos_buttons(1), ...
        (pos_buttons(2)-k*size_button(2)), ...
        size_button(1), size_button(2)]);
end

% Add buttons in the second column
for k = (ui_rows_number+1):(2*ui_rows_number)
    button(k) = uicontrol(panel, 'Style', 'pushbutton', ...
        'FontSize', text_size, 'Units', 'normalized', ...
        'Position', [pos_buttons(1)+size_button(1), ...
        (pos_buttons(2)-(k-ui_rows_number)*size_button(2)), ...
        size_button(1), size_button(2)]);
end

% Define button names
button(1).String = '-';
button(5).String = '+';
button(2).String = '-';
button(6).String = '+';
button(3).String = '-';
button(7).String = '+';
button(4).String = '-';
button(8).String = '+';

% Define button callbacks
button(1).Callback = @decrease_xdesF;
button(5).Callback = @increase_xdesF;
button(2).Callback = @decrease_ydesF;
button(6).Callback = @increase_ydesF;
button(3).Callback = @decrease_xdesH;
button(7).Callback = @increase_xdesH;
button(4).Callback = @decrease_ydesH;
button(8).Callback = @increase_ydesH;

% Define step (in mm) the toe moves in x and y after a button press
toe_move_step = 0.01;

% Create radio button group (Hind Knee Configuration)
rb_group_1 = uibuttongroup(panel, 'Visible', 'on', ...
    'BorderType', 'line', 'HighlightColor', [0.8, 0.8, 0.8], ...
    'Position', [0, 0, 0.5, size_button(2)], ...
    'SelectionChangedFcn', @select_kneeH_conf);

% Create radio buttons in the button group
rb1_gr1 = uicontrol(rb_group_1, 'Style', 'togglebutton', ...
    'String', 'Hind Knee BW', 'Units', 'normalized', ...
    'Position', [0, 0, 0.5, 1], 'HandleVisibility', 'on');

rb2_gr1 = uicontrol(rb_group_1, 'Style', 'togglebutton', ...
    'String', 'Hind Knee FW', 'Units', 'normalized', ...
    'Position', [0.5, 0, 0.5, 1], 'HandleVisibility', 'on');

% Create radio button group (Fore Knee Configuration)
rb_group_2 = uibuttongroup(panel, 'Visible', 'on', ...
    'BorderType', 'line', 'HighlightColor', [0.8, 0.8, 0.8], ...
    'Position', [0.5, 0, 0.5, size_button(2)], ...
    'SelectionChangedFcn', @select_kneeF_conf);

% Create radio buttons in the button group
rb1_gr2 = uicontrol(rb_group_2, 'Style', 'togglebutton', ...
    'String', 'Fore Knee BW', 'Units', 'normalized', ...
    'Position', [0, 0, 0.5, 1], 'HandleVisibility', 'on');

rb2_gr2 = uicontrol(rb_group_2, 'Style', 'togglebutton', ...
    'String', 'Fore Knee FW', 'Units', 'normalized', ...
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

    % Edit field callback
    function edit_xdesF(hObj,~)
        posture_temp = posture;
        posture_temp.xdesF = str2double(hObj.String);
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            edit_field(1).String = posture.xdesF;
            errordlg('Error');
        end
    end

    % Edit field callback
    function edit_ydesF(hObj,~)        
        posture_temp = posture;
        posture_temp.ydesF = str2double(hObj.String);
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            edit_field(2).String = posture.ydesF;
            errordlg('Error');
        end
    end

    % Edit field callback
    function edit_xdesH(hObj,~)
        posture_temp = posture;
        posture_temp.xdesH = str2double(hObj.String);
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            edit_field(3).String = posture.xdesH;
            errordlg('Error');
        end
    end

    % Edit field callback
    function edit_ydesH(hObj,~)
        posture_temp = posture;
        posture_temp.ydesH = str2double(hObj.String);
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            edit_field(4).String = posture.ydesH;
            errordlg('Error');
        end
    end

    % Button callback
    function increase_xdesF(~,~)       
        posture_temp = posture;
        posture_temp.xdesF = posture_temp.xdesF + toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(1).String = posture.xdesF;
    end

    % Button callback
    function decrease_xdesF(~,~)
        posture_temp = posture;
        posture_temp.xdesF = posture_temp.xdesF - toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(1).String = posture.xdesF;
    end

    % Button callback
    function increase_ydesF(~,~)
        posture_temp = posture;
        posture_temp.ydesF = posture_temp.ydesF - toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(2).String = posture.ydesF;
    end

    % Button callback
    function decrease_ydesF(~,~)
        posture_temp = posture;
        posture_temp.ydesF = posture_temp.ydesF + toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(2).String = posture.ydesF;
    end

    % Button callback
    function increase_xdesH(~,~)
        posture_temp = posture;
        posture_temp.xdesH = posture_temp.xdesH + toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(3).String = posture.xdesH;
    end

    % Button callback
    function decrease_xdesH(~,~)
        posture_temp = posture;
        posture_temp.xdesH = posture_temp.xdesH - toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(3).String = posture.xdesH;
    end

    % Button callback
    function increase_ydesH(~,~)
        posture_temp = posture;
        posture_temp.ydesH = posture_temp.ydesH - toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(4).String = posture.ydesH;
    end

    % Button callback
    function decrease_ydesH(~,~)
        posture_temp = posture;
        posture_temp.ydesH = posture_temp.ydesH + toe_move_step;
        if is_paramset_valid(posture_temp, geometry, inertial)
            posture = posture_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(4).String = posture.ydesH;
    end

    % Radio button clb (Hind Knee Configuration)
    function select_kneeH_conf(~, event)
        if event.NewValue.String == 'Hind Knee FW'
            posture.kneeFWH = 1;
        elseif event.NewValue.String == 'Hind Knee BW'
            posture.kneeFWH = -1;
        end
        update_results();
    end

    % Radio button clb (Fore Knee Configuration)
    function select_kneeF_conf(~, event)
        if event.NewValue.String == 'Fore Knee FW'
            posture.kneeFWF = 1;
        elseif event.NewValue.String == 'Fore Knee BW'
            posture.kneeFWF = -1;
        end
        update_results();
    end

end