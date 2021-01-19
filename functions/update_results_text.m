function update_results_text(res_panel, torques, forces, angles)
%UPDATE_RESULTS_TEXT Update the results

% Get panel children
panel_children = get(res_panel, 'Children');
column_text = get(panel_children, 'Children');

% Update text in column 1
str_title1 = 'Angles [deg]';
str_title2 = '---------------';
str_gap = ' ';
str1 = sprintf('thb:  %4.2f', angles.thb_deg);
str2 = sprintf('thF1:  %4.2f', angles.thF1_deg);
str3 = sprintf('thF2:  %4.2f', angles.thF2_deg);
str4 = sprintf('thH1:  %4.2f', angles.thH1_deg);
str5 = sprintf('thH2:  %4.2f', angles.thH2_deg);
column_text(3).String = {str_gap, str_title1, str_title2, str_gap, ...
    str1, str2, str3, str4, str5};

% Update text in column 2
str_title1 = 'Torques [Nm]';
str_title2 = '----------------';
str_gap = ' ';
str1 = sprintf('tauF1:  %4.2f', torques.tauF1);
str2 = sprintf('tauF2:  %4.2f', torques.tauF2);
str3 = sprintf('tauH1:  %4.2f', torques.tauH1);
str4 = sprintf('tauH2:  %4.2f', torques.tauH2);
column_text(2).String = {str_gap, str_title1, str_title2, str_gap, ...
    str1, str2, str3, str4};

% Update text in column 3
str_title1 = 'Forces [N]';
str_title2 = '-------------';
str_gap = ' ';
str1 = sprintf('NF:  %4.2f', forces.NF);
str2 = sprintf('NH:  %4.2f', forces.NH);
column_text(1).String = {str_gap, str_title1, str_title2, str_gap, ...
    str1, str2};

end

