% Pick your file
[file, path] = uigetfile({'*.nii';'*.nii.gz';'*.hdr'},...
    'Select 3D image file');

% define seed voxel xyz coordinates here
% we can change this later to either read seed coordinates from a file or
% prompt the user
seed_str = inputdlg('Enter XYZ seed voxel coordinates');
seed = str2num(seed_str{1});

% Read in image using FSL's MATLAB bindings
% May require some configuration
% See https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation/MacOsX#Using_FSL_MATLAB_libraries
[image, dims, scales, bpp, endian] = read_avw([path file]);
% image  = 3D/4D MATLAB matrix of your voxels
% dims   = voxel dimensions of your image
% scales = size of each voxel? can't remember

% hash map to store # of connections at different distances
dist_conn = containers.Map('KeyType','double','ValueType','double');

% Loop through each voxel's coordinates
for x = 1:dims(1)
    for y = 1:dims(2)
        for z = 1:dims(3)
            % get the of connections at that voxel from the image
            connections = image(x,y,z);
            % calculate Euclidean distance between current and seed voxel
            distance = sqrt(...
                (x - seed(1))^2 + ...
                (y - seed(2))^2 + ...
                (z - seed(3))^2);

            if (~isKey(dist_conn, distance))
                dist_conn(distance) = 0;
            end
            % add the number of connections to the hash map
            dist_conn(distance) = dist_conn(distance) + connections;
        end
    end
end

distances = cell2mat(keys(dist_conn));
connections = cell2mat(values(dist_conn));

% save filename without extension
[~, filename, ext] = fileparts(file);

% save outputs in folder
save([path filename],...
    'distances', 'connections', 'seed',...
    'scales', 'dims');

% do some MATLAB plotting here, or output/save DC to a file
% example plot code is show below
% figure
% xlabel('radius from seed (voxels)')
% ylabel('total intersections at distance')
% title('Sholl profile')
% hold on
% plot(distances, connections)
% hold off