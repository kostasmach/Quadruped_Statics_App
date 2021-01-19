function [theta1, theta2] = inverse_kinematics_leg(...
    xdes, ydes, l1, l2, kneeFW)
%INVERSE_KINEMATICS Calculate a leg's inverse kinematics (kneeFW = 1/-1)

c_invk = (ydes^2+xdes^2 - l1^2 - l2^2)/(2*l1*l2);
s_invk = kneeFW*sqrt(1-c_invk^2);
k1_invk = l2 + l1 * c_invk;
k2_invk = l1 * s_invk;
theta2 = atan2(ydes,xdes) - atan2(k2_invk,k1_invk) + pi/2;
theta1 = theta2 + atan2(s_invk,c_invk);

end

