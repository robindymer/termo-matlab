function [Trad] = get_radiator_temp(Tout)
%GET_RADIATOR_TEMP Summary of this function goes here
%   Detailed explanation goes here
if Tout < -4
    Trad = 36.44 - 0.64*Tout;
elseif -4 <= Tout && Tout <= 4
    Trad = 39.0;
elseif 4 < Tout && Tout <= 21
    Trad = 43.26 - 1.06*Tout;
elseif 21 < Tout
    Trad = 0;
end
end

