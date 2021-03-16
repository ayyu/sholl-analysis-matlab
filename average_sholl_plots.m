% Pick your root directory
path = uigetdir();
files = dir(path);

% ignore files and ./..
dirflags = [files.isdir];
subjects = files(dirflags);
subjects(ismember( {subjects.name}, {'.', '..'})) = [];

sides = {'L', 'R'};

% per group
for j = 1:length(sides)
    
    % store averages
    conns_bins_sum = [];
    bins_max = [];
    total_subjects = 0;

    side = sides{j};
    
    fprintf('Working on %s\n', side);
    
    for i = 1:length(subjects)
        
        total_subjects = total_subjects + 1;
        
        fprintf('Summing plots for %s\n', subjects(i).name);

        subj_path = fullfile(subjects(i).folder, subjects(i).name, 'SHOLL');
        side_path = fullfile(subj_path, side);
        bin_path = fullfile(side_path, 'bin_output.mat');
        load(bin_path, 'bins', 'conns_bins');
        
        if (length(bins) > length(bins_max))
            bins_max = bins;
        end
        
        for k = 1:length(conns_bins)
            if (k > length(conns_bins_sum))
                conns_bins_sum(k) = 0;
            end
            conns_bins_sum(k) = conns_bins_sum(k) + conns_bins(k);
        end
    end
    
    conns_bins_avg = conns_bins_sum/total_subjects;
    
    sholl_figure = figure;
    plot(bins_max, conns_bins_avg);
    xlabel('radius from seed (mm)');
    ylabel('total connections at radius');
    title(['Sholl profile average ' side]);
    
    % save outputs in folder
    figure_path = fullfile(path, ['avg_' side '.fig']);
    savefig(sholl_figure, figure_path);
    close(sholl_figure);
    
    output_path = fullfile(path, ['avg_' side '.mat']);
    save(output_path, 'conns_bins_avg', 'conns_bins_sum',...
        'total_subjects', 'bins_max');
end

% across groups
% store averages
conns_bins_sum = [];
for j = 1:length(sides)
    avg_path = fullfile(path, ['avg_' side '.mat']);
    load(avg_path, 'conns_bins_avg');
    for k = 1:length(conns_bins_avg)
        if (k > length(conns_bins_sum))
            conns_bins_sum(k) = 0;
        end
        conns_bins_sum(k) = conns_bins_sum(k) + conns_bins_avg(k);
    end
end
conns_bins_avg2 = conns_bins_sum/2;

sholl_figure = figure;
plot(bins_max, conns_bins_avg);
xlabel('radius from seed (mm)');
ylabel('total connections at radius');
title('Sholl profile total average');

% save outputs in folder
figure_path = fullfile(path, 'avg_total.fig');
savefig(sholl_figure, figure_path);
close(sholl_figure);

output_path = fullfile(path, 'avg_total.mat');
save(output_path, 'conns_bins_avg2', 'bins_max');