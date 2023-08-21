# You Are Here: Geolocation by Embedding Images and Maps 

In this repository, we provide metadata and code for the localisation algorithm described in our paper [You Are Here: Geolocation by Embedding Maps and Images](https://arxiv.org/abs/1911.08797 "You Are Here: Geolocation by Embedding Maps and Images").

![Alt text](diagram.png?raw=true "Geolocalisation process diagram")

Currently, we provide:
- Metadata for each of the three testing areas (latitude, longitude, yaw, neighbors) 
- Embedded descriptors for each location in the testing areas. (./features/ES)
- Binary Semantic Descriptors ([BSD](https://arxiv.org/abs/1803.00788 "BSD")) for each location in the testing areas. (./features/BSD)
- Testing routes used for the results reported in the paper. (./test_routes)
- Localisation algorithm implemented in Matlab. 

### Prerequisites
- Matlab
- Tested on Mac and Linux

### Instructions to run an experiment

1. Define parameters in the corresponding configuration file depending on the type of features to use.  ESParams.m for embedded descriptors and BSDParams.m for the case of BSDs.
2. Run Localisation.m. Results are stored in an array called "ranking.mat" which contains the summary of the position of the groud truth route among all possible candidates. Only the top-k positions are considered (defined in the configuration file). A zero rank means the ground truth route is not in the top-k.
Also, a struct with the top-5 best-estimated routes is saved.
3. Results will be automatically saved in ./results directory with a path depending on the parameters selected.
4. Plot results using calculate_accuracy.m script.
5. To generate your own testing routes, please run "generate_random_routes.m". To use extra turn information, please run "generate_turns.m".
6. Plot figures presented in the paper, please refer to "bar.m", "culling_plot.m" and "mse_plot.m". All figures in '.eps' format are saved in ./figures directory. 

### Disclaimer

We make no claims about the stability or usability of the code provided in this repository.
We provide no warranty of any kind, and accept no liability for damages of any kind that result from the use of this code.

### Citation
```latex
@InProceedings{noe2020eccv,
author = {N. Samano, M Zhou, A. Calway},
title = {{ You Are Here: Geolocation by Embedding Maps and Images}},
booktitle =  In Proc. of the European Conference on Computer Vision (ECCV),
year = {2020},
}
```
