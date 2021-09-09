function pow = power_ratio(sp,f,sig_band,noise_band)

% Power ratio

% pow = power_ratio(sp,f,sig_band,noise_band)

% This function takes in power spectral density, signal and noise band
% edges, computes power ratio

% Inputs:
% sp - spectral power computed with Welches method, a vector
% or a matrix
% f - associated frequency vector in Hz
% sig_band - range of the signal in Hz, a vector of 2 values
% noise_band - range for the noise in Hz, a vector
% If noise band is 2 number vector, the power ratio is computed as Psig /
% Pnoise. 
% If noise band is 4 component vector, the power ratio is computed
% as Psig / 0.5*(Pnoise1 + Pnoise2)

% Output:
% pow - power ratio in a given band, a number or a vector

% signal power
sig_pow = mean(sp(dsearchn(f,sig_band(1)):dsearchn(f,sig_band(2)),:));
% noise power
if length(noise_band) == 2
    noise_pow = mean(sp(dsearchn(f,noise_band(1)):dsearchn(f,noise_band(2)),:));
elseif length(noise_band) == 4
    noise_pow = mean(sp([dsearchn(f,noise_band(1)):dsearchn(f,noise_band(2)),...
        dsearchn(f,noise_band(3)):dsearchn(f,noise_band(4))],:) );
end

% power ratio
pow = sig_pow ./ noise_pow;
