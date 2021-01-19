function coords = forward_kinematics(geometry, inertial, angles)
%FORWARD_KINEMATICS Calculate the forward kinematics of the model

% Fore hip coords wrt the body CoM
coords.xjF1 = inertial.db*cos(angles.thb_rad);
coords.yjF1 = inertial.db*sin(angles.thb_rad);

% Hind hip coords wrt the body CoM
coords.xjH1 = -(geometry.lb-inertial.db)*cos(angles.thb_rad);
coords.yjH1 = -(geometry.lb-inertial.db)*sin(angles.thb_rad);

% Fore knee coords wrt the fore hip
coords.xjF2 = geometry.lF1*sin(angles.thF1_rad);
coords.yjF2 = -geometry.lF1*cos(angles.thF1_rad);

% Hind knee coords wrt the hind hip
coords.xjH2 = geometry.lH1*sin(angles.thH1_rad);
coords.yjH2 = -geometry.lH1*cos(angles.thH1_rad);

% Fore toe coords wrt the fore hip
coords.xtF = coords.xjF2 + geometry.lF2*sin(angles.thF2_rad);
coords.ytF = coords.yjF2 - geometry.lF2*cos(angles.thF2_rad);

% Hind toe coords wrt the hind hip
coords.xtH = coords.xjH2 + geometry.lH2*sin(angles.thH2_rad);
coords.ytH = coords.yjH2 - geometry.lH2*cos(angles.thH2_rad);

% Fore leg segments' CoM coords wrt the fore hip
coords.xF1 = inertial.dF1*sin(angles.thF1_rad);
coords.yF1 = -inertial.dF1*cos(angles.thF1_rad);
coords.xF2 = coords.xjF2 + inertial.dF2*sin(angles.thF2_rad);
coords.yF2 = coords.yjF2 - inertial.dF2*cos(angles.thF2_rad);

% Hind leg segments' CoM coords wrt the hind hip
coords.xH1 = inertial.dH1*sin(angles.thH1_rad);
coords.yH1 = -inertial.dH1*cos(angles.thH1_rad);
coords.xH2 = coords.xjH2 + inertial.dH2*sin(angles.thH2_rad);
coords.yH2 = coords.yjH2 - inertial.dH2*cos(angles.thH2_rad);

end

