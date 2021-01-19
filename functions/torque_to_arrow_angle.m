function arrow_angle = torque_to_arrow_angle(tau)
%ARROW_ANGLE Calculate arrow angle given a torque value, used for plotting
%   If torque is less than 1Nm make arrow angle 0, else if start with a
%   minimum arrow angle (100 degrees) for appearance purposes and increase
%   linearly with the torque given. For angles larger than 359 degrees,
%   saturate the result at 359 degrees.

if abs(tau) < 1
    arrow_angle = 0.001;
else
    arrow_angle = 100 + abs(tau);
    if arrow_angle > 359
        arrow_angle = 359;
    end
end

end

