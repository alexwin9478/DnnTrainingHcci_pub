%% Define function- we can use it later for MPC
% We have 4 hidden states and 4 cell states
unit_size = LSTMStateNum;
% Use aliases for network parameters

% Fully connected layers- 1
WFc1 =  model.Layers(2, 1).Weights;
bFc1 =  model.Layers(2, 1).Bias;

% Fully connected layers- 2
WFc2 =  model.Layers(4, 1).Weights;
bFc2 =  model.Layers(4, 1).Bias;

% Fully connected layers- 3
WFc3 =  model.Layers(6, 1).Weights;
bFc3 =  model.Layers(6, 1).Bias;


% Recurrent weights
Ri =  model.Layers(8, 1).RecurrentWeights(1:unit_size, :);
Rf =  model.Layers(8, 1).RecurrentWeights(unit_size+1:2*unit_size, :);
Rg =  model.Layers(8, 1).RecurrentWeights(2*unit_size+1:3*unit_size, :);
Ro =  model.Layers(8, 1).RecurrentWeights(3*unit_size+1:end, :);

% Input weights
wi =  model.Layers(8, 1).InputWeights(1:unit_size, :);
wf =  model.Layers(8, 1).InputWeights(unit_size+1:2*unit_size, :);
wg =  model.Layers(8, 1).InputWeights(2*unit_size+1:3*unit_size, :);
wo =  model.Layers(8, 1).InputWeights(3*unit_size+1:end, :);

% Bias weights
bi =  model.Layers(8, 1).Bias(1:unit_size, :);
bf =  model.Layers(8, 1).Bias(unit_size+1:2*unit_size, :);
bg =  model.Layers(8, 1).Bias(2*unit_size+1:3*unit_size, :);
bo =  model.Layers(8, 1).Bias(3*unit_size+1:end, :);

% Fully connected layers- 4
WFc4 =  model.Layers(9, 1).Weights;
bFc4 =  model.Layers(9, 1).Bias;

% Fully connected layers- 5
WFc5 =  model.Layers(11, 1).Weights;
bFc5 =  model.Layers(11, 1).Bias;

% Fully connected layers- 6
WFc6 =  model.Layers(13, 1).Weights;
bFc6 =  model.Layers(13, 1).Bias;


%% Assigining parameters to a structure
% needed for implementation in NMPC. Cannot change!
Par.Ri = double(Ri);
Par.Rf = double(Rf);
Par.Rg = double(Rg);
Par.Ro = double(Ro);
Par.wi = double(wi);
Par.wf = double(wf);
Par.wg = double(wg);
Par.wo = double(wo);
Par.bi = double(bi);
Par.bf = double(bf);
Par.bg = double(bg);
Par.bo = double(bo);
Par.WFc1 = double(WFc1);
Par.bFc1 = double(bFc1);
Par.WFc2 = double(WFc2);
Par.bFc2 = double(bFc2);
Par.WFc3 = double(WFc3);
Par.bFc3 = double(bFc3);
Par.WFc4 = double(WFc4);
Par.bFc4 = double(bFc4);
Par.WFc5 = double(WFc5);
Par.bFc5 = double(bFc5);
Par.WFc6 = double(WFc6);
Par.bFc6 = double(bFc6);
Par.nCellStates = unit_size;
Par.nHiddenStates = unit_size;
Par.nStates = Par.nCellStates + Par.nHiddenStates;
Par.nActions = numInputs;
Par.nOutputs = numOutputs; 

save(['Par_',savename],"Par")
