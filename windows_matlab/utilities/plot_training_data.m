function plot_training_data(InputDataMatrix, OutputDataMatrix, numInputs, numOutputs)
% ToDo: Font Sizes, Interpreter Latex everywhere
% InputDataMatrix.Data

% ploting training and validation
gce = figure;
% set(gcf, 'Position', [100*1, 100*1, 800*1.3*1, 800*1]);
gce.WindowState = 'maximized';
set(gce,'color','w');

n_rows = 5;
n_cols = 2;
for ii = 1 : numInputs
    subplot(n_rows, n_cols, 1 + (ii - 1) * n_cols)
    grid on; hold on; box on
    plot(InputDataMatrix.Data(1:end, ii), '-')
    ylabel({[InputDataMatrix.Titles{ii}, ' in ', ...
        InputDataMatrix.Units{ii}]})
    xlabel({'Engine Cycle in -'})
    ax(ii) = gca;
end

for ii = 1 : numOutputs
    subplot(n_rows, n_cols, 2 + (ii - 1) * n_cols)
    grid on; hold on; box on
    plot(OutputDataMatrix.Data(1:end, ii), '-')
    ylabel({[OutputDataMatrix.Titles{ii}, ' in ', ...
        OutputDataMatrix.Units{ii}]})
    xlabel({'Engine Cycle in -'}) 
    ax2(ii) = gca;
end
linkaxes([ax,ax2], 'x' );
hold off;


%% Histogram - See the data distribution
gcf = figure; % comparing mylstmstatefun with matlab prediction - this should be the same!
% set(gcf, 'Position', [100, 100, 900, 1200]);
% set(gcf, 'Position', [100*0.1, 100*0.1, 800*1.6*1, 800*1]);
set(gcf,'color','w');

n_rows = numOutputs;
n_cols = 1;
for ii = 1 : numOutputs
    subplot(n_rows, n_cols, 1 + (ii - 1) * n_cols)
    grid on; hold on; box on
    histogram(OutputDataMatrix.Data(1:end, ii))
    xlabel({[OutputDataMatrix.Titles{ii}, ' in ', ...
        OutputDataMatrix.Units{ii}]})
    ylabel({'Count in -'}) 
end

