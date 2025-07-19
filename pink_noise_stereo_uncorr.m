%% MATLAB Code for Stereo Uncorrelated Pink Noise Synthesis

clear;
clc;

% =========================================================================
% == 1. Parameters
% =========================================================================

N = 32768;      % Number of sinusoids (defines frequency resolution)
fs = 44100;     % Sampling frequency in Hz

% =========================================================================
% == 2. Generate Independent Channels
% =========================================================================

% Generate the Left channel by calling our synthesis function.
fprintf('Generating Left Channel...\n');
left_channel = generate_pink_noise_channel(N, fs);

% Generate the Right channel. Calling the function again ensures a new,
% independent set of random phases is used, making it uncorrelated.
fprintf('Generating Right Channel...\n');
right_channel = generate_pink_noise_channel(N, fs);

% Combine the two mono channels into a single stereo matrix (M x 2).
stereo_pink_noise = [left_channel, right_channel];

fprintf('Stereo signal generated successfully.\n');

% =========================================================================
% == 3. Verification and Output
% =========================================================================

% --- Play the generated stereo noise ---
fprintf('Playing the stereo pink noise... 🎧\n');
sound(stereo_pink_noise, fs);

% --- Verify the Power Spectral Density (PSD) of the Left channel ---
% (Verifying one is sufficient as both are made with the same process)
figure('Name', 'Stereo Pink Noise Verification');
M = 2 * N;
[Pxx, F] = pwelch(stereo_pink_noise(:, 1), hann(M/8), [], M, fs);

loglog(F(2:end), Pxx(2:end), 'b', 'DisplayName', 'Left Channel PSD');
grid on;
hold on;

% Add the ideal 1/f reference line
f_ref = 1000;
[~, idx] = min(abs(F - f_ref));
P_ref = Pxx(idx);
C = P_ref * f_ref;
x_line = [F(2), fs/2];
y_line = C ./ x_line;
plot(x_line, y_line, 'r--', 'LineWidth', 2, 'DisplayName', 'Ideal 1/f Slope');

hold off;
title('Power Spectral Density of Synthesized Pink Noise');
xlabel('Frequency (Hz)');
ylabel('Power / Frequency');
legend;
axis tight;

% --- Verify that the channels are uncorrelated ---
correlation_matrix = corrcoef(stereo_pink_noise);
fprintf('\nCorrelation matrix of the two channels:\n');
disp(correlation_matrix);
fprintf('The off-diagonal values should be close to 0, confirming the channels are uncorrelated.\n');


%% ========================================================================
% == HELPER FUNCTION for generating a single channel of pink noise
% =========================================================================
function mono_noise = generate_pink_noise_channel(N, fs)
    % Generates one channel of pink noise using the IFFT method.

    M = 2 * N; % Total samples from FFT size

    % Create the full complex spectrum
    X = zeros(1, M);

    % Generate positive frequency components (excluding DC and Nyquist)
    pos_freq_indices = 2:N;
    frequencies = (pos_freq_indices - 1) * fs / M;
    amplitudes = 1 ./ sqrt(frequencies);
    % THIS IS THE KEY: rand() is called here, generating unique phases each time.
    phases = 2 * pi * rand(1, N - 1);
    X(pos_freq_indices) = amplitudes .* exp(1i * phases);

    % Generate the Nyquist frequency component
    f_nyquist = (N) * fs / M;
    amp_nyquist = 1 / sqrt(f_nyquist);
    X(N + 1) = amp_nyquist; % Real component (phase = 0)

    % Enforce conjugate symmetry for a real-valued output signal
    X((N + 2):M) = conj(fliplr(X(2:N)));

    % Perform IFFT and normalize
    mono_noise_raw = real(ifft(X));
    % Return as a column vector, normalized to peak amplitude 1
    mono_noise = mono_noise_raw(:) / max(abs(mono_noise_raw));
end
