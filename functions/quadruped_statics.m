function [torques, forces, angles] = quadruped_statics(...
    posture, geometry, inertial, knee_mechanism, number_of_legs)
%QUADRUPED_STATICS Calculate joint torques and ground forces
%   Calculate joint torques and forces at toes given posture,
%   geometrical and inertial properties. The parameter knee_mechanism 
%   should be 0 if the knees are actuated via a serial mechanism 
%   (knee actuator mounted on the upper leg segment), or 1 if 
%   they are actuated via a parallel 5 bar mechanism (knee actuator 
%   mounted on the body). The parameter number_of_legs should be 4 if all
%   four legs touch the ground and support equally the body weight, or 2
%   if only two legs (one fore and one hind) support the body weight while
%   the other two legs are on their swing phase.

% Calculate angles usigng the inverse kinematics
angles = inverse_kinematics(posture, geometry);

% Calculate x,y coordinates using the forward kinematics
coords = forward_kinematics(geometry, inertial, angles);

% Calculate gravitational forces 
g = 9.81;
% If 4 legs are on the ground, then 2 legs lift half of the body weight 
% and also their own weight
if number_of_legs == 4   
    Wb = inertial.mb*g/2;
    WF1 = inertial.mF1*g;
    WF2 = inertial.mF2*g;
    WH1 = inertial.mH1*g;
    WH2 = inertial.mH2*g;
% Else if 2 legs are on the ground, then these 2 legs lift the whole body
% weight, their own weight and also the weight of the other two legs.
elseif number_of_legs == 2  
    Wb = inertial.mb*g;
    WF1 = 2*inertial.mF1*g;
    WF2 = 2*inertial.mF2*g;
    WH1 = 2*inertial.mH1*g;
    WH2 = 2*inertial.mH2*g;
% Else the input is invalid.
else
    Wb = 0;
    WF1 = 0;
    WF2 = 0;
    WH1 = 0;
    WH2 = 0;
end

% Define the unknowns
syms NF NH tF1 tF2 tH1 tH2

% Equation 1
eqn1 = NF*(coords.xjF1 + coords.xtF) + NH*(coords.xjH1 + coords.xtH) == ... 
    WF1*(coords.xjF1 + coords.xF1) + WF2*(coords.xjF1 + coords.xF2) + ...
    WH1*(coords.xjH1 + coords.xH1) + WH2*(coords.xjH1 + coords.xH2);

% Equation 2
eqn2 = NF + NH == Wb + WF1 + WF2 + WH1 + WH2;

% Equation 3
eqn3 = NF*coords.xtF - tF1 == WF1*coords.xF1 + WF2*coords.xF2;

% Equation 4
eqn4 = NF*geometry.lF2*sin(angles.thF2_rad) - tF2 == ...
    WF2*inertial.dF2*sin(angles.thF2_rad);

% Equation 5
eqn5 = NH*coords.xtH - tH1 == WH1*coords.xH1 + WH2*coords.xH2;

% Equation 6
eqn6 = NH*geometry.lH2*sin(angles.thH2_rad) - tH2 == ...
    WH2*inertial.dH2*sin(angles.thH2_rad);

% Solve system of equations
sol = solve([eqn1, eqn2, eqn3, eqn4, eqn5, eqn6], ...
    [NF, NH, tF1, tF2, tH1, tH2]);

% Get solutions
s = structfun(@double, sol);
NFsol = s(1);
NHsol = s(2);
tF1sol = s(3);
tF2sol = s(4);
tH1sol = s(5);
tH2sol = s(6);

% Calculate final torques depending on the given knee actuation mechanism:
%   knee_mechanism = 0 -> the knees are actuated via a serial mechanism, 
%   i.e. the knee actuator is mounted on the upper leg segment,
%   or knee_mechanism = 1 -> the knees are actuated via a parallel 5 bar 
%   mechanism, i.e. the knee actuator is mounted on the main body.
if knee_mechanism == 0
    torqueF1 = tF1sol;
    torqueF2 = tF2sol;
    torqueH1 = tH1sol;
    torqueH2 = tH2sol;
elseif knee_mechanism == 1
    torqueF1 = tF1sol - tF2sol;
    torqueF2 = tF2sol;
    torqueH1 = tH1sol - tH2sol;
    torqueH2 = tH2sol;
else
    torqueF1 = 0;
    torqueF2 = 0;
    torqueH1 = 0;
    torqueH2 = 0;
end

% Pack results in structs
torques.tauF1 = torqueF1;
torques.tauF2 = torqueF2;
torques.tauH1 = torqueH1;
torques.tauH2 = torqueH2;
forces.NF = NFsol;
forces.NH = NHsol;

end

