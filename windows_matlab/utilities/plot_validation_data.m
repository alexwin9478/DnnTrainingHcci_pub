function plot_validation_data(InputDataMatrix, OutputDataMatrix, numInputs, numOutputs, savename)
% ToDo: Font Sizes, Interpreter Latex everywhere
% InputDataMatrix.Data

% ploting training and validation
gcf = figure;
% set(gcf, 'Position', [100*1, 100*1, 800*1.3*1, 800*1]);
gcf.WindowState = 'maximized';
set(gcf,'color','w');

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
      plot(OutputDataMatrix.DataTest(1:end, ii), '--', 'linewidth', 2)
    legend({'measurement', 'model'})  
    
     ax2(ii) = gca;
end
linkaxes([ax,ax2], 'x' );

hold off;
title(savename, 'interpreter', 'none');


saveas(gcf, ['model\', savename(1:(end-4)),'_validation'], 'fig');