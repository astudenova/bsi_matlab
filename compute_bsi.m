function [bsi, Valpha, Vbs] = compute_bsi(X_ampl, X_low)

% Baseline-shift index

% [bsi, Valpha, Vbs] = compute_bsi(X_ampl, X_low)

% This function computes baseline-shift index from amplitude envelope of
% oscillatory activity and corresponding low-frequency signal (baseline
% shifts)

% Inputs:
% X_ampl - amplitude envelope of oscillatory signal - a signal that is
% obtained with the Hilbert transform of narrow-band filtered oscillations, can
% be a matrix timepoints x channels
% X_low - baseline shifts - a narrow-band signal in the lower frequency range, can 
% be a matrix timepoints x channels
% Dimensions of X_ampl and X_low should be the same.

% Outputs:
% bsi - baseline-shift index - a measure of correspondence between
% amplitude modulation and shifts in lower frequency signal, a vector if
% X_ampl is a matrix, otherwise a number
% Valpha - values in the bins for higher frequency signal, a matrix if
% X_ampl is a matrix, otherwise a vector
% Vbs - values in the bins for lower frequency signal, a matrix if
% X_ampl is a matrix, otherwise a vector


% The method for computing BSI is adapted from 
% Nikulin, V. V., Linkenkaer-Hansen, K., Nolte, G., & Curio, G. (2010). 
% Non-zero mean and asymmetry of neuronal oscillations have different 
% implications for evoked responses. Clinical Neurophysiology, 121(2), 
% 186–193. 
% https://doi.org/10.1016/j.clinph.2009.09.028
% Nikulin, V. V., Linkenkaer-Hansen, K., Nolte, G., Lemm, S., M?ller, K. R., 
% Ilmoniemi, R. J., & Curio, G. (2007). A novel mechanism for evoked 
% responses in the human brain. European Journal of Neuroscience, 25(10), 
% 3146–3154. 
% https://doi.org/10.1111/j.1460-9568.2007.05553.x

nbins = 20;
nch = size(X_ampl,2);
% allocate space for bsi
bsi = zeros(nch,1);
% vector or matrix of indices that are used for binning 
binned_idx = zeros(size(X_ampl));
% vector or matrix of binned amplitudes
[Valpha, Vbs] = deal(zeros(nbins,nch));

% if X_ampl is a matrix, loop over channels
for ci=1:nch
    
    % bin data
    binborders = prctile(sort(X_ampl(:,ci))',0:5:100,2);
    for ai=1:nbins
        binned_idx(:,ci) = binned_idx(:,ci)...
            + ai*(X_ampl(:,ci)>=binborders(ai) & X_ampl(:,ci)<=binborders(ai+1));
    end
    
    % fill arrays with mean values from the bins
    for bi=1:nbins
        Valpha(bi,ci) = mean(X_ampl(binned_idx(:,ci) == bi,ci));
        Vbs(bi,ci) = mean(X_low(binned_idx(:,ci) == bi,ci));
    end
    
    % calculate bsi
    % compute linear regression
    bsi_tmp = [ones(nbins,1) Valpha(:,ci)]\Vbs(:,ci);
    % transform to the Pearson coefficient
    bsi(ci) = bsi_tmp(2)*( std(Valpha(:,ci)) / std(Vbs(:,ci)) );
end
