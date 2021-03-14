# Sholl analysis in MATLAB

Run this after you have your `fdt_paths.nii.gz` files

## Usage

### Directory structure

Make sure your directory structure matches this:

```
(root)
└───(subject)
│   └───SHOLL
│       └───L
│           └───fdt_paths.nii.gz
│       └───R
│           └───fdt_paths.nii.gz
└───(subject)
│   └───(same as above)
└───(subject)
│   └───(same as above)
...
```

It doesn't matter what naming scheme you choose for the individual `(subject)` directory, as long as they are all in the same root directory, both have a `L` and `R` subdirectory (for left and right side), and have `fdt_paths.nii.gz` in each `L` and `R` directory. You can also name your `(root)` directory whatever you want.

Create a `seed.txt` in the same directory as each `fdt_paths.nii.gz` containing the desired xyz seed coordinates separated by spaces, e.g. if your desired origin for the Sholl analysis was the voxel at (20, 40, 3), your seed file would look like:

#### **`seed.txt`**
``` 
20 40 3
```

Such that your directory structure is now:

```
(root)
└───(subject)
│   └───SHOLL
│       └───L
│           └───fdt_paths.nii.gz
│           └───seed.txt
│       └───R
│           └───fdt_paths.nii.gz
│           └───seed.txt
└───(subject)
│   └───(same as above)
└───(subject)
│   └───(same as above)
...
```

### Sholl analysis

Place all MATLAB `.m` script files in the same directory. Then run `run_sholl_analysis.m`, choosing your `(root)` directory when prompted.

This will generate `sholl_output.mat` in each `L` and `R` directory containing the results of the Sholl analysis for each tractography image. The variables in the `sholl_output.mat` file are `dists` and `conns`, representing an array of distances in mm and the number of connections at that distance, respectively.

### Binning and plotting

Once you've finished the previous step and have your `sholl_output.mat` files in each folder, run `run_sholl_plots.m`, choosing your `(root)` directory and desired `bin size` (in millimeters) when prompted. A common choice for bin size is 2.

This will generate `bin_output.mat` in each `L` and `R` directory containing the binned Sholl outputs `bins`, `conns_bins`, representing an array of the bin endpoints and connections in each bin, respectively. It will also generate a `sholl.fig` figure in each `L` and `R` directory based on these binned outputs.

## Contributing

Right now `sholl_analysis.m` uses a hashmap to tally connections per distance. This seems to experience loss of precision in the calculated Euclidean distance despite all of the values being multiples of 0.5. This is mostly a non-issue due to the binning performed before generating the plots but if anyone knows a more sane way of mapping Euclidean distance to sum of connections in MATLAB please let me know.

## Citations

This script uses [Paul's textprogressbar](https://www.mathworks.com/matlabcentral/fileexchange/28067-text-progress-bar) in order to display progress during `sholl_analysis.m`.