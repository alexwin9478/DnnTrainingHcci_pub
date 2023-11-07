function [data_n] = dataTrainStandardizedBack(data, mu, sig)

data_n = data * sig + mu;


% mu = min(data);
% sig = max(data);
% data_n = ((data - mu) / (sig-mu));
end

