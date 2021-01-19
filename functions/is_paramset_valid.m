function is_valid = is_paramset_valid(posture, geometry, inertial)
%IS_PARAMSET_VALID Return 1 if the parameters inserted are valid

% Workspace limits
max_F = geometry.lF1 + geometry.lF2;
max_H = geometry.lH1 + geometry.lH2;
min_F = abs(geometry.lF1 - geometry.lF2);
min_H = abs(geometry.lH1 - geometry.lH2);

% Virtual leg lengths
virtual_length_F = (posture.xdesF^2 + posture.ydesF^2)^0.5;
virtual_length_H = (posture.xdesH^2 + posture.ydesH^2)^0.5;

% Check if x,y for hind and fore legs are inside the reachable workspace
if (...
        (virtual_length_F < max_F) && ...
        (virtual_length_F > min_F) && ...
        (virtual_length_H < max_H) && ...
        (virtual_length_H > min_H) && ...
        (inertial.mb >= 0) && ...
        (inertial.mF1 >= 0) && ...
        (inertial.mF2 >= 0) && ...
        (inertial.mH1 >= 0) && ...
        (inertial.mH2 >= 0))
    is_valid = 1;
else
    is_valid = 0;
end

end