disp("Termo fun")
radiation = importdata('Uppsala_stralning_2008_2018.txt');
temp = importdata('Uppsala_temperaturer_2008_2018.txt');
% disp(radiation.data(1,:))

for i=1:length(radiation.data)
    disp(radiation.data(i, :))
end