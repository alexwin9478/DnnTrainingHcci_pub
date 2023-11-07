function [data_n, mu, sig] = dataTrainStandardized(data)
mu = mean(data);
sig = std(data);

if sig == 0
    data_n = (data - mu);
else
    data_n = (data - mu) / sig;
end
% mu = min(data);
% sig = max(data);
% data_n = ((data - mu) / (sig-mu));
end

