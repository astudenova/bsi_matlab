# bsi_matlab
Functions for computation of Baseline shift Index (BSI)

*bsi_pipeline* - is a pipeline for BSI computation

*ssd_extended* - Spatio-Spectral Decomposition with additional processing

*power_ratio* - takes in power spectral density and signal and noise band edges and computed power ratio

*compute_bsi* - computes baseline-shift index from amplitude envelope of oscillatory activity and corresponding low-frequency signal (baseline shifts)

The method for computing BSI is adapted from 
Nikulin, V. V., Linkenkaer-Hansen, K., Nolte, G., & Curio, G. (2010). 
Non-zero mean and asymmetry of neuronal oscillations have different implications for evoked responses. Clinical Neurophysiology, 121(2), 186–193. 
https://doi.org/10.1016/j.clinph.2009.09.028
Nikulin, V. V., Linkenkaer-Hansen, K., Nolte, G., Lemm, S., M?ller, K. R., Ilmoniemi, R. J., & Curio, G. (2007). 
A novel mechanism for evoked responses in the human brain. European Journal of Neuroscience, 25(10), 3146–3154. 
https://doi.org/10.1111/j.1460-9568.2007.05553.x
