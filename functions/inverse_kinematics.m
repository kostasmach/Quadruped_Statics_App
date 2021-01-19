function angles = inverse_kinematics(posture, geometry)
%INVERSE_KINEMATICS Calculate the inverse kinematics of the model

% Calculate fore leg angles
[thF1, thF2] = inverse_kinematics_leg(posture.xdesF, posture.ydesF, ...
    geometry.lF1, geometry.lF2, posture.kneeFWF);

% Calculate hind leg angles
[thH1, thH2] = inverse_kinematics_leg(posture.xdesH, posture.ydesH, ...
    geometry.lH1, geometry.lH2, posture.kneeFWH);

% Calculate the body body angle
%   coords.yjH1 - coords.yjF1 = level_diff =>
%   -(lb-db)*sin(thb) - db*sin(thb) = level_diff =>
%   sin(thb)*(db-lb-db) = level_diff =>
%   sin(thb) = -level_diff/lb =>
%   thb = asin(-level_diff/lb)
level_diff = posture.ydesH - posture.ydesF;
thb = asin(level_diff/geometry.lb);

% Pack angle results in a struct
angles.thb_rad = thb;
angles.thF1_rad = thF1;
angles.thF2_rad = thF2;
angles.thH1_rad = thH1;
angles.thH2_rad = thH2;
angles.thb_deg = rad2deg(thb);
angles.thF1_deg = rad2deg(thF1);
angles.thF2_deg = rad2deg(thF2);
angles.thH1_deg = rad2deg(thH1);
angles.thH2_deg = rad2deg(thH2);

end

