% Pick your root directory
path = uigetdir();
files = dir(path);

% ignore files and ./..
dirflags = [files.isdir];
subjects = files(dirflags);
subjects(ismember( {subjects.name}, {'.', '..'})) = [];

sides = {'L', 'R'};

for i = 1:length(subjects)
    fprintf('Running Sholl analysis on %s\n', subjects(i).name);
    
    subj_path = fullfile(subjects(i).folder, subjects(i).name, 'SHOLL');
    
    for j = 1:length(sides)
        side = sides{j};
        fprintf('Running on %s\n', side);
        side_path = fullfile(subj_path, side);

        % read seed voxel xyz coordinates here
        seed_path = fopen(fullfile(side_path, 'seed.txt'));
        seed = cell2mat(textscan(seed_path, '%f %f %f'));
        
        % Read in image using FSL's MATLAB bindings
        nifti_path = fullfile(side_path, 'fdt_paths.nii.gz');
        info = niftiinfo(nifti_path);
        image = niftiread(nifti_path);
        [dists, conns] = sholl_analysis(image, info, seed);
        
        % save outputs in folder
        output_path = fullfile(side_path, 'sholl_output.mat');
        save(output_path, 'dists', 'conns', 'seed');
    end
    
end