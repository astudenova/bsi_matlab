function [X_ssd, patterns] = ssd_extended(X, alpha_pk, fs, ncomp)

% SSD - Spatio-Spectral Decomposition with additional processing

% This function requires ssd function that can be downloaded as a part of 
% BBCI Toolbox

% Inputs:
% X - data matrix to decompose
% alpha_pk - the central value of band of interest in Hz
% fs - sampling frequency in Hz
% numcomp - number SSD components to return

% Outputs:
% X_ssd - matrix of SSD components' time courses, timepoints x components
% patterns - corresponding spatial patterns (if plotting is needed)

% create band for ssd function
% signal band: +/- 1Hz from alpha peak
% noise band: -3:-2 U +2:+3 from alpha peak
bands = [alpha_pk-1, alpha_pk+1; alpha_pk-3, alpha_pk+3;  alpha_pk-2, alpha_pk+2];
% perform ssd
[~, A, ~, ~, X_ssd_all] = ssd(X, bands, fs,2,[]);

% flip the sign of spatial pattern if necessary, so that the maximum value
% would be always positive
[max_A, idx_max_A] = max(abs(A(:,1:ncomp)));
compsign = zeros(1,ncomp);
for i=1:ncomp
    compsign(i) = sign(A(idx_max_A(i),i));
end

% extract patterns for later plotting
patterns = A(:,1:ncomp)./(max_A.*compsign);
% extract variability from the pattern and put it into the component
stdA = std(A(:,1:ncomp));
X_ssd = bsxfun(@times,X_ssd_all(:,1:ncomp),compsign.*stdA);