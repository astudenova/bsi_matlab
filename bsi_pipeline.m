function [bsi, pow_alpha, pow_lf] = bsi_pipeline(X, alpha_pk, fs, numcomp)

% Pipeline

% This function is a pipeline for BSI computation.

% For the operation 4 other functions are needed:
% ssd - from BBCI Toolbox
% ssd_extended
% power_ratio
% compute_bsi

% Inputs:
% X - raw data, matrix
% alpha_pk - peak frequency in the band of interest in Hz
% fs - sampling frequency in Hz
% numcomp - number of components to return from SSD spatial filter

% Outputs:
% bsi - Baseline-shift index,- a measure of correspondence between
% amplitude modulation and shifts in lower frequency signal
% pow_alpha - power ratio in the band of interest
% pow_lf - power ratio in the low-frequency band


% alpha band
band_of_int = [8 13];
% for zero padding
padwin = 50000;

% SSD
[X_ssd, ~] = ssd_extended(X, alpha_pk, fs, numcomp);

% filter the band
X_passband = [];
X_low = [];
pow_alpha = [];
pow_lf = [];
% filter settings for low-frequency signal
lowfreq = 3;
[b_low, a_low] = butter(4, lowfreq / (fs/2), 'low');
% loop over components
for ci=1:numcomp
    % find peak frequency
    [sp,f] = pwelch(X_ssd(:,ci),10*fs,5*fs,10*fs,fs);
    [~,locs]=findpeaks(sp,'MinPeakProminence',0.7);
    f_pk = f(locs);
    alpha_pk_comp = f_pk(f_pk>=band_of_int(1) & f_pk<=band_of_int(2));
    % if multiple peaks in alpha band take mean
    if length(alpha_pk_comp)>1
        alpha_pk_comp = mean(alpha_pk_comp);
    end
    % if no peaks are detected, take global peak value
    if isempty(alpha_pk_comp)
        alpha_pk_comp = alpha_pk;
    end
    
    % settings for alpha band
    adj_band = [alpha_pk_comp-2 alpha_pk_comp+2];
    [b10, a10] = butter(2,adj_band/(fs/2));
    
    % filter in low-frequency band and in the alpha band
    X_ssd_pad = [X_ssd(padwin:-1:1,ci);X_ssd(:,ci);X_ssd(end:-1:end-padwin+1,ci)];
    X_passband(:,ci) = filtfilt(b10, a10, X_ssd_pad);    
    X_low(:,ci) = filtfilt(b_low, a_low, X_ssd_pad);
    
    % find power ratio in alpha
    pow_alpha(ci) = power_ratio(sp,f,[alpha_pk_comp-1, alpha_pk_comp+1],...
        [alpha_pk_comp-3, alpha_pk_comp-2  alpha_pk_comp+2, alpha_pk_comp+3]);    
    % find power ratio in low-frequency
    pow_lf(ci) = power_ratio(sp,f,[0.1, 3],[0.1,7]);
    
end
% cut zero padding
X_passband = X_passband(padwin+1:end-padwin,:);
X_low = X_low(padwin+1:end-padwin,:);

% extract amplitude with the Hilbert transform
X_hilbert = hilbert(X_passband);
X_ampl = abs(X_hilbert);

% compute bsi
[bsi,~,~] = compute_bsi(X_ampl, X_low);

