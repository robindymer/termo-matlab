disp("Termo fun")
radiation = importdata('Uppsala_stralning_2008_2018.txt');
temp = importdata('Uppsala_temperaturer_2008_2018.txt');

% Heat loss per month over all the years
heat_leak = zeros(12, 1);
% Days for each month over all the years
days = zeros(12, 1);

% Get the heat_leak 
for i=1:length(temp.data)
    Tout = temp.data(i, 4);
    month = temp.data(i, 2);
    heat_loss = 0;
    if Tout < 21
        % 24 because 2 is per hour
        heat_loss = 2e6*24*(21-Tout);
    end
    
    heat_leak(month, 1) = heat_leak(month, 1) + heat_loss;
    days(month, 1) = days(month, 1) + 1;
end

avg_heat_leak = heat_leak ./ days;

% COP = 1 - Q_L/Q_H. Or Q_H/(Q_H-Q_L)
COP = zeros(12, 1);
for i=1:length(radiation.data)
    Tout = temp.data(i, 4);
    Trad = get_radiator_temp(Tout);
    
    month = temp.data(i, 2);
    COP(month, 1) = COP(month, 1) + 1 - (10+273.15)/(Trad+273.15);
end

avg_COP = COP ./ days;

% Usage of energy
for i=1:length(COP)
    
    