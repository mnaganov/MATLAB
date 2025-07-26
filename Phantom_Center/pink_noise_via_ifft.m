%% MATLAB Code for Pink Noise Synthesis
% This script generates pink noise by constructing its frequency spectrum
% and then transforming it to the time domain using an IFFT.

clear;
clc;

% =========================================================================
% == 1. Parameters
% =========================================================================

% Number of sinusoids to sum, as per the user request.
% This defines the number of positive frequency components.
N = 32768;

% Total number of samples in the output signal.
% An FFT of size M gives N = M/2 positive frequency bins.
M = 2 * N;

% Sampling frequency in Hz.
fs = 44100; % Standard audio sampling rate

% =========================================================================
% == 2. Frequency Domain Synthesis
% =========================================================================

% Create an empty array for the full complex spectrum.
X = zeros(1, M);

% --- Generate positive frequency components (excluding DC and Nyquist) ---
% Indices for these components in the full spectrum array.
pos_freq_indices = 2:N;
% Corresponding frequencies in Hz.
frequencies = (pos_freq_indices - 1) * fs / M;

% Amplitudes follow a 1/sqrt(f) law for pink noise.
% This results in a power spectral density (PSD) proportional to 1/f.
amplitudes = 1 ./ sqrt(frequencies);

% Random phases uniformly distributed between 0 and 2*pi.
phases = 2 * pi * rand(1, N - 1);

% Combine amplitudes and phases into complex numbers.
X(pos_freq_indices) = amplitudes .* exp(1i * phases);

% --- Generate the Nyquist frequency component ---
% The Nyquist frequency is at index N + 1.
f_nyquist = (N) * fs / M;
amp_nyquist = 1 / sqrt(f_nyquist);
% The phase of the Nyquist component must be 0 or pi to ensure a real signal.
% We set it to 0, making the component real.
X(N + 1) = amp_nyquist;

% --- Enforce conjugate symmetry for a real-valued output signal ---
% The negative frequency components must be the complex conjugate of the
% positive frequency components.
% X(k) = conj(X(M - k + 2))
X( (N + 2):M ) = conj( fliplr( X(2:N) ) );

% =========================================================================
% == 3. Time Domain Synthesis
% =========================================================================

% Perform the Inverse FFT to transform the spectrum to the time domain.
% The 'real' function removes negligible imaginary parts from numerical error.
pink_noise = real(ifft(X));

% Normalize the signal to a peak amplitude of +/- 1.
pink_noise = pink_noise / max(abs(pink_noise));

% =========================================================================
% == 4. Verification and Output (CORRECTED PLOTTING)
% =========================================================================

% --- Play the generated noise ---
fprintf('Playing the synthesized pink noise... 🔊\n');
sound(pink_noise, fs);

% --- Plot the Power Spectral Density (PSD) to verify ---
figure('Name', 'Pink Noise Verification (IFFT)');

% 1. Calculate PSD using pwelch, getting data instead of plotting directly.
[Pxx, F] = pwelch(pink_noise, hann(M/8), [], M, fs);

% 2. Plot the calculated PSD on a log-log scale.
%    We plot F(2:end) to ignore the DC component (F=0), as log(0) is undefined.
loglog(F(2:end), Pxx(2:end), 'b', 'DisplayName', 'Synthesized Noise');
grid on;
hold on; % Prepare to add the reference line

% 3. Add a robust reference line showing the ideal 1/f slope.
%    This line is now calculated based on the actual data power level.
f_ref = 1000; % Reference frequency in Hz
[~, idx] = min(abs(F - f_ref)); % Find index closest to f_ref
P_ref = Pxx(idx); % Power at the reference frequency
C = P_ref * f_ref; % Calculate the constant C for the P = C/f law
x_line = [F(2), fs/2]; % Define frequency range for the line
y_line = C ./ x_line; % Calculate the corresponding power values
plot(x_line, y_line, 'r--', 'LineWidth', 2, 'DisplayName', 'Ideal 1/f Slope');

% Final plot formatting
hold off;
title('Power Spectral Density of Synthesized Pink Noise');
xlabel('Frequency (Hz)');
ylabel('Power / Frequency');
legend;
axis tight; % Adjust axes to fit the data snugly

% The slope of a log-log plot of power vs. frequency for pink noise
% should be -1, which corresponds to -10 dB per decade.
