clc;
clear all;
close all;

[orig, Fs_orig] = audioread('/Users/mikhail/Sounds/MeasSweep_44100_20_20000_L-Mono.wav');
[filt, Fs_filt] = audioread('/Users/mikhail/Sounds/bs2b-MeasSweep_44100_20_20000_L-Right.wav');

fft_orig = fft(orig);
fft_filt = fft(filt);

L = length(orig);
L2 = round(L/2);
% We have L/2 buckets that correspond to frequencies from 0 to Fs_orig / 2
freqs = (0:L2-1)' * (Fs_orig / L);
% Crop to 20-20000 Hz
pos20 = find(freqs >= 20, 1);
pos20k = find(freqs >= 20000, 1);
freqs20_20k = freqs(pos20:pos20k);

figure;

fa_orig = abs(fft_orig(pos20:pos20k));
fa_filt = abs(fft_filt(pos20:pos20k));
subplot(3, 1, 1);
semilogx(freqs20_20k, 20 * log10(fa_orig), 'b', freqs20_20k, 20 * log10(fa_filt), 'r');
grid on;
ylabel('dB');
xlim([20, 20000]);
title('Spectrum of original (blue) and filtered (red) signals');

fft_filter = fft_filt ./ fft_orig;
fa_filt_freq_resp = abs(fft_filter(pos20:pos20k));
phase_filter = angle(fft_filter(pos20:pos20k));
subplot(3, 1, 2);
filter_graph = plotyy(freqs20_20k, 20 * log10(fa_filt_freq_resp), freqs20_20k, phase_filter .* (180 / pi), @semilogx);
ylabel(filter_graph(1), 'dB');
ylabel(filter_graph(2), 'deg');
grid on;
title('Freq. resp. and phase of the filter');

sm_phase_filter = unwrap(angle(fft_filter));
smooth_steps = 1000;
for i = 1:smooth_steps
    sm_phase_filter = conv(sm_phase_filter, [1, 2, 1] / 4, 'same');
end;

grpdelay_filter = -diff(sm_phase_filter) / (freqs(2) - freqs(1));
subplot(3, 1, 3);
%pos5k = find(freqs >= 5000, 1);
%freqs20_5k = freqs(pos20:pos5k);
semilogx(freqs20_20k(2:end), grpdelay_filter(pos20:pos20k - 1) * 1000000);
grid on;
ylabel('us');
xlim([20, 20000]);
title('Group delay of the filter');