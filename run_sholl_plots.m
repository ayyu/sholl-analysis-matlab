% Pick your root directory
path = uigetdir();
files = dir(path);

% pick your bin size in mm
bin_input = inputdlg('Enter your bin size (mm):');
bin_size = str2num(bin_input{1});

% ignore files and ./..
dirflags = [files.isdir];
subjects = files(dirflags);
subjects(ismember( {subjects.name}, {'.', '..'})) = [];

sides = {'L', 'R'};

for i = 1:length(subjects)
    fprintf('Generating Sholl plots for %s\n', subjects(i).name);
    
    subj_path = fullfile(subjects(i).folder, subjects(i).name, 'SHOLL');
    
    for j = 1:length(sides)
        side = sides{j};
        fprintf('Generating for %s\n', side);
        side_path = fullfile(subj_path, side);
        
        mat_path = fullfile(side_path, 'sholl_output.mat');
        load(mat_path);
        
        [sholl_figure, bins, conns_bins] = plot_sholl(dists, conns, bin_size);
        
        % save outputs in folder
        figure_path = fullfile(side_path, 'sholl.fig');
        savefig(sholl_figure, figure_path);
        close(sholl_figure);
        
        output_path = fullfile(side_path, 'bin_output.mat');
        save(output_path, 'bins', 'conns_bins');
    end
    
end