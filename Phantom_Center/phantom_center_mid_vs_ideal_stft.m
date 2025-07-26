%% MATLAB Code for Ideal Correlated Center Extraction

clear;
clc;

% =========================================================================
% == 1. Parameters
% =========================================================================
N = 32768;
fs = 44100;
M = 2 * N;

% =========================================================================
% == 2. Generate Independent Channels and Their Spectra
% =========================================================================
fprintf('Generating Left Channel and its Spectrum...\n');
[left_channel, X_L] = generate_pink_noise_channel(N, fs);

fprintf('Generating Right Channel and its Spectrum...\n');
[right_channel, X_R] = generate_pink_noise_channel(N, fs);

% =========================================================================
% == 3. Construct Center Channels (Mid vs. Correlated)
% =========================================================================

% --- Reference 1: The simple "Mid" channel (L+R) ---
mid_channel = (left_channel + right_channel) / 2;

% --- Reference 2: The "Ideal Correlated Center" using perfect knowledge ---
fprintf('Constructing ideal correlated center channel...\n');

% Pre-allocate the spectrum for the new channel
X_C_corr = zeros(1, M);

% Process each positive frequency bin
for k = 2:(N + 1) % Includes DC (k=1) and Nyquist (k=N+1)
    % Get complex values for this frequency from L and R spectra
    xl_k = X_L(k);
    xr_k = X_R(k);

    % 1. Calculate the correlation based on phase difference
    phase_diff = angle(xl_k) - angle(xr_k);
    correlation_coeff = cos(phase_diff);

    % 2. Calculate the new correlated magnitude
    avg_magnitude = (abs(xl_k) + abs(xr_k)) / 2;
    correlated_magnitude = avg_magnitude * abs(correlation_coeff);

    % 3. Calculate the new correlated phase (average phase)
    correlated_phase = angle(xl_k + xr_k);

    % 4. Construct the new complex spectral component
    X_C_corr(k) = correlated_magnitude * exp(1i * correlated_phase);
end

% Enforce conjugate symmetry for a real-valued output signal
X_C_corr((N + 2):M) = conj(fliplr(X_C_corr(2:N)));

% Perform IFFT to get the time-domain signal
correlated_center_channel = real(ifft(X_C_corr));

% Normalize both center channels for fair comparison
%mid_channel = mid_channel / max(abs(mid_channel));
%correlated_center_channel = correlated_center_channel / max(abs(correlated_center_channel));

% =========================================================================
% == 4. Verification and Output
% =========================================================================

fprintf('\n--- Power Analysis ---\n');

% Calculate RMS in dB for both signals
rms_mid_db = db(rms(mid_channel), "power");
rms_corr_db = db(rms(correlated_center_channel), "power");

fprintf('RMS Power of Mid Channel (L+R): %.2f dB\n', rms_mid_db);
fprintf('RMS Power of Correlated Center: %.2f dB\n', rms_corr_db);

fprintf('Playing the simple "Mid" (L+R) channel... (louder)\n');
sound(mid_channel, fs);
%pause(2); % Pause for 2 seconds
audiowrite("center_mid.wav", mid_channel,fs,'BitsPerSample',24);

fprintf('Playing the ideal "Correlated" center channel... (much quieter)\n');
sound(correlated_center_channel, fs);
audiowrite("center_corr.wav", correlated_center_channel, fs, 'BitsPerSample',24);

% --- Plot the Power Spectral Density (PSD) ---
figure('Name', 'Center Channel Extraction Comparison');

[Pxx_mid, F] = pwelch(mid_channel, hann(M/8), [], M, fs);
[Pxx_corr, ~] = pwelch(correlated_center_channel, hann(M/8), [], M, fs);

semilogy(F(2:end), Pxx_mid(2:end), 'k', 'LineWidth', 1.5, 'DisplayName', 'Mid Channel (L+R)');
hold on;
semilogy(F(2:end), Pxx_corr(2:end), 'r', 'LineWidth', 1.5, 'DisplayName', 'Correlated Center');

grid on;
hold off;
title('Power Spectral Density: Mid vs. Ideal Correlated Center');
xlabel('Frequency (Hz)');
ylabel('Power / Frequency');
legend('Location', 'southwest');
ylim([1e-15, 1e-3]); % Adjust y-axis to see the quiet signal

%% ========================================================================
% == HELPER FUNCTION (now returns spectrum)
% =========================================================================
function [mono_noise, X] = generate_pink_noise_channel(N, fs)
    M = 2 * N;
    X = zeros(1, M);
    pos_freq_indices = 2:N;
    frequencies = (pos_freq_indices - 1) * fs / M;
    amplitudes = 1 ./ sqrt(frequencies);
    phases = 2 * pi * rand(1, N - 1);
    X(pos_freq_indices) = amplitudes .* exp(1i * phases);
    f_nyquist = (N) * fs / M;
    amp_nyquist = 1 / sqrt(f_nyquist);
    X(N + 1) = amp_nyquist;
    X((N + 2):M) = conj(fliplr(X(2:N)));
    mono_noise_raw = real(ifft(X));
    mono_noise = mono_noise_raw(:) / max(abs(mono_noise_raw));
end
