% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Example code showing LSTM modeling using Matlab deep learning toolbox
% % September 2023 % %
% % Armin Norouzi, David Gordon, Alexander Winkler % %  %
% % Mechatronics in mobile Propulsion, RWTH Aachen University
% % Department of Mechanical Engineering, University of Alberta
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear all; close all; 

%% Settings
do_training = true;
trainingrun = 001; % Set this "training run" value to distingush between differnt settings of LSTM model
plotinputs = true;

%% Load data 
datastruct = load('VSR40013_0014.mat');
storedvars = fieldnames(datastruct) ;
FirstVarName = storedvars{1};
RawMABX = datastruct.(FirstVarName);
MP = 40013014;

%% calling data
% Crop Data to remove when the valves failed at the end of measurement
start1 = 1;
end1 = 504718;

% Pull needed information from the MABX data file
DOI_main = RawMABX.Y(77).Data(start1:end1); % mtf_tiFuInj[1]
DOI_wat = RawMABX.Y(85).Data(start1:end1); % mtw_tiWatInj[1]
NVO = RawMABX.Y(59).Data(start1:end1); % 'mtv_agNvo'
NOx = RawMABX.Y(89).Data(start1:end1); % 'AII_uNOx'
HC = RawMABX.Y(88).Data(start1:end1); % 'AII_uHC'
IMEP = RawMABX.Y(9).Data(start1:end1); % 'fip_pImepHold'
CA50 = RawMABX.Y(122).Data(start1:end1); % 'lli_MFB50_dSPACEfixedIntervall'
MPRR = RawMABX.Y(7).Data(start1:end1); % 'fip_dpHold'
engine_deg = RawMABX.Y(4).Data(start1:end1); % 'fip_GE_CAD'
RNG_Active = RawMABX.Y(73).Data(start1:end1); % 'rsd_stepchange'

%% Converting data for cycle-based data (Data pulled at 360)
k = 1;
kk = 1;
for i  = 2:length(engine_deg)    
    if engine_deg(i)>360 && engine_deg(i-1)<360

        DOI_main_cycle(k) = DOI_main(i);
        DOI_wat_cycle(k) = DOI_wat(i);
        NVO_cycle(k) = NVO(i);
        NOx_cycle(k) = NOx(i);
        HC_cycle(k) = HC(i);
        IMEP_cycle(k) = IMEP(i);
        MPRR_cycle(k) = MPRR(i);
        CA50_cycle(k) = CA50(i);
        RNG_Active_cycle(k) = RNG_Active(i);
        
        k = k + 1;
    end     
end


%% Create previous cycle inputs - Shift outputs to match timing of inputs

IMEP_cycle = IMEP_cycle(2:end);
IMEP_old = IMEP_cycle(1);
IMEP_old(2:length(IMEP_cycle)) = IMEP_cycle(1:end-1);
CA50_cycle = CA50_cycle(2:end);
CA50_old = CA50_cycle(1);
CA50_old(2:length(CA50_cycle)) = CA50_cycle(1:end-1);

DOI_main_cycle = DOI_main_cycle(1:end-1);
DOI_wat_cycle = DOI_wat_cycle(1:end-1);
NVO_cycle = NVO_cycle(1:end-1);
NOx_cycle = NOx_cycle(2:end);
HC_cycle = HC_cycle(2:end);
MPRR_cycle = MPRR_cycle(2:end);

%% ploting inputs
if plotinputs

%------------------------------
figure
% set(gcf, 'Position', [100, 100, 1800, 1000]);
set(gcf,'color','w');

ax5 = subplot(4,1,1);
plot(DOI_wat_cycle*100, 'k','LineWidth',1.5)
ylabel({'H20 DOI', '[ms]'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

ax6 = subplot(4,1,2);
plot(100*DOI_main_cycle, 'k','LineWidth',2)
ylabel({'Main Inj. DOI', '[ms]'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

ax7 = subplot(4,1,3);
plot(NVO_cycle, 'k','LineWidth',1.5)
ylabel({'NVO', '[bTDC CAD]'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;


%% ploting outputs 
figure
% set(gcf, 'Position', [100, 100, 1800, 800]);
set(gcf,'color','w');

%--------------------------------------------------
ax1 = subplot(5,1,1);
plot(IMEP_cycle, 'k','LineWidth',1.5) ; hold on

ylabel({'IMEP'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;
%--------------------------------------------------
ax2 = subplot(5,1,2);
plot(NOx_cycle, 'k','LineWidth',1.5)
ylabel({'NO$_x$', '[ppm]'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;
%--------------------------------------------------
ax3 = subplot(5,1,3);
plot(HC_cycle, 'k','LineWidth',1.5)
ylabel({'soot',' [mg/m$^3$]'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;
%--------------------------------------------------
ax4 = subplot(5,1,4);
plot(MPRR_cycle, 'k','LineWidth',1.5)
ylabel({'MPRR_cycle',' [Pa]'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

%--------------------------------------------------
ax8 = subplot(5,1,5);
plot(CA50_cycle, 'k','LineWidth',1.5)
ylabel({'CA50',' []'},'Interpreter','latex')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

% This is handy to force all x-axis to lock together
linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8],'x');
%% Histogram - to determine spread of experimental data

figure
histogram(IMEP_cycle)
ylabel({'IMEP'},'Interpreter','latex')

figure
histogram(NOx_cycle) 
ylabel({'NOx'},'Interpreter','latex')

figure
histogram(MPRR_cycle)
ylabel({'MPRR'},'Interpreter','latex')

figure
histogram(HC_cycle)
ylabel({'HC'},'Interpreter','latex')

figure
histogram(CA50_cycle)
ylabel({'CA50'},'Interpreter','latex')

end

% Can have modeling run in a loop for a number of different cell and hidden
% state sizes. 
% numHiddenUnits  % Hidden usint size in fully connected layers - dealy change in 2^n
% LSTMStateNum    % number of hidden or cell states (they are the same) - idealy change in 2^n
for numHiddenUnits1 = [8] % [4,8]
for LSTMStateNum= [8] % [4,8]

%% Modeling

%% Normalizing data
[u1, u1_mu, u1_sig] = dataTrainStandardized(DOI_main_cycle');
[u2, u2_mu, u2_sig] = dataTrainStandardized(DOI_wat_cycle');
[u3, u3_mu, u3_sig] = dataTrainStandardized(NVO_cycle');
[u4, u4_mu, u4_sig] = dataTrainStandardized(CA50_old');
[u5, u5_mu, u5_sig] = dataTrainStandardized(IMEP_old');

% With normalizing output
[y1, y1_mu, y1_sig] = dataTrainStandardized(IMEP_cycle');
[y2, y2_mu, y2_sig] = dataTrainStandardized(NOx_cycle');
[y3, y3_mu, y3_sig] = dataTrainStandardized(MPRR_cycle');
[y4, y4_mu, y4_sig] = dataTrainStandardized(CA50_cycle');

%% Deep network model
% set 85% of data for training
indx_tr = floor(0.85*size(u1,1));

utrain_load = [u1(1:indx_tr)'; u2(1:indx_tr)'; u3(1:indx_tr)'; u4(1:indx_tr)'; u5(1:indx_tr)'];
ytrain_load = [y1(1:indx_tr)'; y2(1:indx_tr)'; y3(1:indx_tr)'; y4(1:indx_tr)'];

uval_load = [u1(indx_tr:end)'; u2(indx_tr:end)'; u3(indx_tr:end)'; u4(indx_tr:end)'; u5(indx_tr:end)'];
yval_load = [y1(indx_tr:end)'; y2(indx_tr:end)'; y3(indx_tr:end)'; y4(indx_tr:end)'];


%% Create and Train Network
numResponses = 4; % y1 y2 y3 y4
featureDimension = 5; % u1 u2 u3 

maxEpochs = 5000;
miniBatchSize = 512;

Networklayer_hcci = [...
    sequenceInputLayer(featureDimension)
    fullyConnectedLayer(4*numHiddenUnits1)
    reluLayer
    fullyConnectedLayer(4*numHiddenUnits1)
    reluLayer
    fullyConnectedLayer(8*numHiddenUnits1)
    reluLayer
    lstmLayer(LSTMStateNum,'OutputMode','sequence')
    fullyConnectedLayer(8*numHiddenUnits1)
    reluLayer
    fullyConnectedLayer(4*numHiddenUnits1)
    reluLayer
    fullyConnectedLayer(numResponses)
    regressionLayer];

options_tr = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'SequenceLength',8192,...
    'Shuffle','once', ...
    'Plots','training-progress',...
    'Verbose',1, ...
    'VerboseFrequency',1,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',1000,...
    'LearnRateDropFactor',0.5,...
    'L2Regularization',10,...
    'ValidationFrequency',64,...
    'InitialLearnRate', 0.001,...
    'ValidationData',[{uval_load} {yval_load}],...
    'OutputNetwork','best-validation-loss');

%% training and Saving model data

savename = [sprintf('%04d',MP),'_',sprintf('%04d',numHiddenUnits1),'_',sprintf('%04d',LSTMStateNum),'_',sprintf('%04d',trainingrun),'.mat'];

if do_training == true
    [hcci_model, hcci_model_infor] = trainNetwork(utrain_load,ytrain_load,Networklayer_hcci,options_tr);
    save(['model/','hcci_model_',savename],"hcci_model")
    save(['model/','hcci_model_info_',savename],"hcci_model_infor")
else
    load(['model/','hcci_model_',savename])
end



%% prediction

y_hat = predict(hcci_model,[u1'; u2'; u3'; u4'; u5']) ;

y1_hat = y_hat(1,:);
y2_hat = y_hat(2,:);
y3_hat = y_hat(3,:);
y4_hat = y_hat(4,:);

% ploting training and validation
figure
set(gcf, 'Position', [100, 100, 1200, 400]);
set(gcf,'color','w');

subplot(6,1,1)
plot(y1, 'r--')
hold on
plot(y1_hat)
ylabel('IMEP tr+validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

subplot(6,1,2)
plot(y2, 'r--')
hold on
plot(y2_hat)
ylabel('NOx tr+validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

subplot(6,1,3)
plot(y3, 'r--')
hold on
plot(y3_hat)
ylabel('MPRR tr+validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

subplot(6,1,4)
plot(y4, 'r--')
hold on
plot(y4_hat)
ylabel('CA50 tr+validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

title(['hcci_model_', savename])


%% Plotting on validation
% ploting training and validation

figure
set(gcf, 'Position', [100, 100, 1200, 400]);
set(gcf,'color','w');

subplot(6,1,1)
plot(y1(indx_tr:end), 'r--')
hold on
plot(y1_hat(indx_tr:end),'k-')
ylabel('IMEP validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

subplot(6,1,2)
set(gcf, 'Position', [100, 100, 1200, 400]);
set(gcf,'color','w');

plot(y2(indx_tr:end), 'r--')
hold on
plot(y2_hat(indx_tr:end),'k-')
ylabel('NOx validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

subplot(6,1,3)
plot(y3(indx_tr:end), 'r--')
hold on
plot(y3_hat(indx_tr:end),'k-')
ylabel('MPRR validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

subplot(6,1,4)
plot(y4(indx_tr:end), 'r--')
hold on
plot(y4_hat(indx_tr:end),'k-')
ylabel('CA50 validation','Interpreter','latex')
set(gca,'FontSize',14)
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.XRuler.Exponent = 0;

title(['hcci',savename])
end
end
