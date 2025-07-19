%% MATLAB Code for Stereo Uncorrelated Pink Noise and Ideal Center Extraction

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

% Generate the Right channel.
fprintf('Generating Right Channel...\n');
right_channel = generate_pink_noise_channel(N, fs);

% Combine the two mono channels into a single stereo matrix (M x 2).
stereo_pink_noise = [left_channel, right_channel];

fprintf('Stereo signal generated successfully.\n');

% =========================================================================
% == 3. Construct the Ideal Center Channel
% =========================================================================

% The ideal center channel is the normalized sum of the left and right channels.
% This represents the "Mid" signal in a perfect M/S decomposition.
fprintf('Constructing ideal center channel...\n');
center_channel_ideal = (stereo_pink_noise(:, 1) + stereo_pink_noise(:, 2)) / 2;

% Optional: Normalize the center channel for playback
center_channel_ideal = center_channel_ideal / max(abs(center_channel_ideal));


% =========================================================================
% == 4. Verification and Output
% =========================================================================

% --- Play the generated center channel ---
fprintf('Playing the ideal center channel... 🎤\n');
sound(center_channel_ideal, fs);
% To play the stereo signal again:
% sound(stereo_pink_noise, fs);

% --- Verify the Power Spectral Density (PSD) ---
figure('Name', 'Ideal Center Channel Verification');
M = 2 * N;

% Calculate PSD for Left, Right, and Center channels
[Pxx_L, F] = pwelch(stereo_pink_noise(:, 1), hann(M/8), [], M, fs);
[Pxx_R, ~] = pwelch(stereo_pink_noise(:, 2), hann(M/8), [], M, fs);
[Pxx_C, ~] = pwelch(center_channel_ideal, hann(M/8), [], M, fs);

% Plot all PSDs on a log-log scale
loglog(F(2:end), Pxx_L(2:end), 'b', 'DisplayName', 'Left Channel');
hold on;
loglog(F(2:end), Pxx_R(2:end), 'g', 'DisplayName', 'Right Channel');
loglog(F(2:end), Pxx_C(2:end), 'k', 'LineWidth', 1.5, 'DisplayName', 'Ideal Center');

% Add the ideal 1/f reference line
f_ref = 1000;
[~, idx] = min(abs(F - f_ref));
P_ref = Pxx_L(idx); % Use Left channel as power reference
C = P_ref * f_ref;
x_line = [F(2), fs/2];
y_line = C ./ x_line;
plot(x_line, y_line, 'r--', 'LineWidth', 2, 'DisplayName', 'Ideal 1/f Slope');

grid on;
hold off;
title('Power Spectral Density Comparison');
xlabel('Frequency (Hz)');
ylabel('Power / Frequency');
legend('Location', 'southwest');
axis tight;


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
