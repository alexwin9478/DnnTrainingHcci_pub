function generate_plots_loss_iteration(model_infor, options_tr, savename)
% plot loss-iteration and training results / validation


% get losses over epochs
train_loss = model_infor.TrainingLoss;
val_loss = model_infor.ValidationLoss;
train_rmse = model_infor.TrainingRMSE;
val_rmse = model_infor.ValidationRMSE;
% from training script
maxEpochs = options_tr.MaxEpochs;
% miniBatchSize = 2048;
% sequence_length = 8192; -> 7 batches in total
datasize = length(train_loss);
iterations_per_epoch = datasize / maxEpochs;

warning('off','MATLAB:colon:nonIntegerIndex') % ToDo: Fix warnings, bug
% average over epochs
n = iterations_per_epoch; 
train_loss_ep = arrayfun(@(i) mean(train_loss(i:i+n-1)),1:n:length(train_loss)-n+1); % the averaged vector
train_rmse_ep = arrayfun(@(i) mean(train_rmse(i:i+n-1)),1:n:length(train_rmse)-n+1); % the averaged vector
% val_loss_ep = arrayfun(@(i) mean(val_loss(i:i+n-1)),1:n:length(val_loss)-n+1); % the averaged vector
warning('on','MATLAB:colon:nonIntegerIndex')

% val, get rid of NaN
val_loss_x = [1: datasize ];
val_loss_xs = val_loss_x(~isnan(val_loss));
val_loss_ys = val_loss(~isnan(val_loss));
val_loss_ep = interp1(val_loss_xs, val_loss_ys, [1:length(train_loss_ep)], 'Linear');
val_rmse_x = [1: datasize ];
val_rmse_xs = val_rmse_x(~isnan(val_rmse));
val_rmse_ys = val_rmse(~isnan(val_rmse));
val_rmse_ep = interp1(val_rmse_xs, val_rmse_ys, [1:length(train_rmse_ep)], 'Linear');


% % average over epochs
% n = 9; 
% train_loss_smooth = movmean(train_loss, n); % the averaged vector


%% ploting outputs 
gcf = figure;
set(gcf, 'Position', [100*1, 100*1, 800*1.3*1, 800*1]);
set(gcf,'color','w');

%--------------------------------------------------
plot(train_loss_ep ,'LineWidth',1.5)
hold on;
plot(val_loss_ep, 'LineWidth',1.5)
hold on;
% plot(train_rmse_ep, 'LineWidth',1.5)
% hold on;
% plot(val_rmse_ep, 'LineWidth',1.5)
% hold off;
% ylabel({'Loss / RMSE [-]'},'Interpreter','latex')
ylabel({'Loss [-]'},'Interpreter','latex')
xlabel({'Iteration [-]'},'Interpreter','latex')
% xlim([0,65024])
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','latex')
lgnd = legend('Train','Validation');
set(lgnd, 'FontSize', 14);
set(lgnd, 'Interpreter','latex');
% ax = gca;
% ax.XRuler.Exponent = 0;
set(gcf,'PaperType','A3')
% print(gcf,'filename','-dpdf')

hold off;

title(savename, 'interpreter', 'none');

saveas(gcf, ['model\', savename(1:(end-4)),'_loss'], 'fig');