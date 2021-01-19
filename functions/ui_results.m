function ui_results(parent_panel)
%UI_RESULTS Run a GUI for live update of the results

% Create panel inside the parent panel (used to improve appearance)
psize = [0.9, 0.9];
panelp = uipanel(parent_panel, 'Visible', 'off', 'Title', 'Results', ...
    'ForegroundColor', 'b', 'BorderType', 'none', ...
    'Position', [(1-psize(1))/2, (1-psize(2))/2, psize(1), psize(2)]);

% Create 3 fixed strings
for i=1:3
    column_text(i) = uicontrol(panelp, 'Style', 'text', 'FontSize', 8, ...
        'Units', 'normalized', 'HorizontalAlignment', 'left', ...
        'BackgroundColor', [0.98, 0.98, 0.98], ...
        'Position', [0.075+(i-1)*0.3, 0.05, 0.28, 0.9]);
end

% Make panel visible
panelp.Visible = 'on';

end