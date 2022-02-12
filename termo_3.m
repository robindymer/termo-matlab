radiation = importdata('Uppsala_stralning_2008_2018.txt');
temp = importdata('Uppsala_temperaturer_2008_2018.txt');

% Heat loss per month over all the years
heat_leak = zeros(12, 1);
% Days for each month over all the years
days = zeros(12, 1);
% Also save the heat_leak for each day
tot_heat_leak = zeros(length(temp.data), 1);

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
    tot_heat_leak(i, 1) = heat_loss;
    
    days(month, 1) = days(month, 1) + 1;
end

avg_heat_leak = heat_leak ./ days;
avg_heat_leak; % PRINT IT

% COP = 1 - Q_L/Q_H. Or Q_H/(Q_H-Q_L)
COP_tot = zeros(length(radiation.data), 1);
COP = zeros(12, 1);
for i=1:length(radiation.data)
    Tout = temp.data(i, 4);
    Trad = get_radiator_temp(Tout);
    
    month = temp.data(i, 2);
%     COP(month, 1) = COP(month, 1) + 1 - (10+273.15)/(Trad+273.15);
    % COP is zero if the radiator is turned off
    if Trad == 0
        COP(month, 1) = COP(month, 1) + 0;
        COP_tot(i, 1) = 0;
    else    
        COP(month, 1) = COP(month, 1) + 1 /(1-(10+273.15)/(Trad+273.15));
        COP_tot(i, 1) = 1 /(1-(10+273.15)/(Trad+273.15));
    end
end

avg_COP = COP ./ days;
avg_COP; % PRINT IT
% COP_tot

% Usage of energy
% Wnet_in = COP*Q_L
energy_consumption = zeros(12, 1);
tot_energy_consumption = zeros(length(radiation.data), 1);

for i=1:length(COP_tot)
    month = temp.data(i, 2);
%     disp(month)
    if COP_tot(i, 1) ~= 0
        % No energy consumption -> pass
        energy_consumption(month, 1) = energy_consumption(month, 1) + tot_heat_leak(i,1)/COP_tot(i, 1);
        tot_energy_consumption(i, 1) = tot_heat_leak(i,1)/COP_tot(i, 1);
    end
end

avg_energy_consumption = energy_consumption ./ days;
avg_energy_consumption; % PRINT IT

E_sol = zeros(length(radiation.data), 1);
for i=1:length(radiation.data)
    E_sol(i, 1) = 0.07 * radiation.data(i, 4) * 100;
end

saved_energy = tot_energy_consumption - E_sol;
t = linspace(1, length(tot_energy_consumption), length(tot_energy_consumption));
plot(t, saved_energy);
