function ui_inertial_2(parent_panel, plot_panel, results_panel)
%UI_INERTIAL_2 Run a gui controlling the model inertial properties

% Global scope
global posture geometry inertial
global knee_mechanism number_of_legs

% Create panel inside the parent panel (used to improve appearance)
panel_rel_size = [0.8 0.9]; 
panel = uipanel(parent_panel, 'Visible', 'on', ...
    'Title', 'CoM Positions', ...
    'ForegroundColor','b','BorderType', 'none', ...
    'Position',[(1-panel_rel_size(1))/2 (1-panel_rel_size(2))/2 ...
    panel_rel_size(1) panel_rel_size(2)]);

% Position and size parameters
size_text = [0.5, 0.2];             % Text field relative size
size_edit = [0.25, 0.2];            % Edit field relative size
size_button = [0.125, 0.2];         % Button relative size
pos_text = [0, 1];                  % Text field relative position
pos_edit = [0.5, 1];                % Edit field relative position
pos_buttons = [0.75, 1];            % Button relative position
text_size = 8;                      % Text size

% Number of ui rows. 5 ui rows in total.  
% Each one includes 1 text field, 1 edit field, 2 buttons
ui_rows_number = 5;

% Add text (use "edit" to achieve vert allignement not supported in 'text')
for k = 1:ui_rows_number
    text_field(k) = uicontrol(panel, 'Style', 'edit', 'Enable', 'off', ...
        'FontSize', text_size, 'Units', 'normalized', ...
        'Position', [pos_text(1), pos_text(2)-k*size_text(2), ...
        size_text(1), size_text(2)]);
end

% Add strings
text_field(1).String = 'db [m]';
text_field(2).String = 'dF1 [m]';
text_field(3).String = 'dF2 [m]';
text_field(4).String = 'dH1 [m]';
text_field(5).String = 'dH2 [m]';

% Add edit fields in panel
for k = 1:ui_rows_number
    edit_field(k) = uicontrol(panel, 'Style', 'edit', ...
        'FontSize', text_size, 'Units', 'normalized', ...
        'Position', [pos_edit(1), pos_edit(2)-k*size_edit(2), ...
        size_edit(1), size_edit(2)]);
end

% Fill edit fields with defaults
edit_field(1).String = inertial.db;
edit_field(2).String = inertial.dF1;
edit_field(3).String = inertial.dF2;
edit_field(4).String = inertial.dH1;
edit_field(5).String = inertial.dH2;

% Define edit field callbacks
edit_field(1).Callback = @edit_db;
edit_field(2).Callback = @edit_dF1;
edit_field(3).Callback = @edit_dF2;
edit_field(4).Callback = @edit_dH1;
edit_field(5).Callback = @edit_dH2;

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
button(6).String = '+';
button(2).String = '-';
button(7).String = '+';
button(3).String = '-';
button(8).String = '+';
button(4).String = '-';
button(9).String = '+';
button(5).String = '-';
button(10).String = '+';

% Define button callbacks
button(1).Callback = @decrease_db;
button(6).Callback = @increase_db;
button(2).Callback = @decrease_dF1;
button(7).Callback = @increase_dF1;
button(3).Callback = @decrease_dF2;
button(8).Callback = @increase_dF2;
button(4).Callback = @decrease_dH1;
button(9).Callback = @increase_dH1;
button(5).Callback = @decrease_dH2;
button(10).Callback = @increase_dH2;

% Define increase/decrease step (in mm) after a button press
increase_step = 0.05;

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
    function edit_db(hObj,~)
        inertial_temp = inertial;
        inertial_temp.db = str2double(hObj.String);
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            edit_field(1).String = inertial.db;
            errordlg('Error');
        end
    end

    % Edit field callback
    function edit_dF1(hObj,~)
        inertial_temp = inertial;
        inertial_temp.dF1 = str2double(hObj.String);
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            edit_field(2).String = inertial.dF1;
            errordlg('Error');
        end
    end

    % Edit field callback
    function edit_dF2(hObj,~)        
        inertial_temp = inertial;
        inertial_temp.dF2 = str2double(hObj.String);
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            edit_field(3).String = inertial.dF2;
            errordlg('Error');
        end
    end

    % Edit field callback
    function edit_dH1(hObj,~)
        inertial_temp = inertial;
        inertial_temp.dH1 = str2double(hObj.String);
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            edit_field(4).String = inertial.dH1;
            errordlg('Error');
        end
    end

    % Edit field callback
    function edit_dH2(hObj,~)
        inertial_temp = inertial;
        inertial_temp.dH2 = str2double(hObj.String);
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            edit_field(5).String = inertial.dH2;
            errordlg('Error');
        end
    end

    % Button callback
    function increase_db(~,~)
        inertial_temp = inertial;
        inertial_temp.db = inertial_temp.db + increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(1).String = inertial.db;
    end

    % Button callback
    function decrease_db(~,~)
        inertial_temp = inertial;
        inertial_temp.db = inertial_temp.db - increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(1).String = inertial.db;
    end

    % Button callback
    function increase_dF1(~,~)       
        inertial_temp = inertial;
        inertial_temp.dF1 = inertial_temp.dF1 + increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(2).String = inertial.dF1;
    end

    % Button callback
    function decrease_dF1(~,~)
        inertial_temp = inertial;
        inertial_temp.dF1 = inertial_temp.dF1 - increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(2).String = inertial.dF1;
    end

    % Button callback
    function increase_dF2(~,~)
        inertial_temp = inertial;
        inertial_temp.dF2 = inertial_temp.dF2 + increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(3).String = inertial.dF2;
    end

    % Button callback
    function decrease_dF2(~,~)
        inertial_temp = inertial;
        inertial_temp.dF2 = inertial_temp.dF2 - increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(3).String = inertial.dF2;
    end

    % Button callback
    function increase_dH1(~,~)
        inertial_temp = inertial;
        inertial_temp.dH1 = inertial_temp.dH1 + increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(4).String = inertial.dH1;
    end

    % Button callback
    function decrease_dH1(~,~)
        inertial_temp = inertial;
        inertial_temp.dH1 = inertial_temp.dH1 - increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(4).String = inertial.dH1;
    end

    % Button callback
    function increase_dH2(~,~)
        inertial_temp = inertial;
        inertial_temp.dH2 = inertial_temp.dH2 + increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(5).String = inertial.dH2;
    end

    % Button callback
    function decrease_dH2(~,~)
        inertial_temp = inertial;
        inertial_temp.dH2 = inertial_temp.dH2 - increase_step;
        if is_paramset_valid(posture, geometry, inertial_temp)
            inertial = inertial_temp;
            update_results();
        else
            errordlg('Error');
        end
        edit_field(5).String = inertial.dH2;
    end
    
end

