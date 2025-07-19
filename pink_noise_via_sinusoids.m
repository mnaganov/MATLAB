%% MATLAB Code for Pink Noise Synthesis (Time-Domain)
% This script generates pink noise by directly summing sinusoids in a loop.
% This method is computationally intensive but makes the role of each
% component and its phase explicit at every time sample.

clear;
clc;

% =========================================================================
% == 1. Parameters (Identical to the IFFT method)
% =========================================================================

N = 1024; % Number of sinusoids
M = 2 * N; % Total number of samples in the signal
fs = 44100; % Sampling frequency in Hz

% =========================================================================
% == 2. Define Sinusoid Components
% =========================================================================

% --- Frequencies ---
% We will sum N sinusoids, corresponding to the N positive frequencies
% from 1*fs/M up to the Nyquist frequency N*fs/M.
frequencies = (1:N) * fs / M;

% --- Amplitudes ---
% Amplitudes follow a 1/sqrt(f) law for pink noise.
amplitudes = 1 ./ sqrt(frequencies);

% --- Initial Phases ---
% Random initial phases (at t=0) for each sinusoid.
initial_phases = 2 * pi * rand(1, N);

% =========================================================================
% == 3. Time-Domain Synthesis via Direct Summation
% =========================================================================

fprintf('Starting time-domain synthesis. This will take some time...\n');

% Create the time vector for the signal duration.
t = (0:M-1) / fs;

% Pre-allocate arrays for efficiency.
pink_noise = zeros(1, M); % The final output signal
instantaneous_phases = zeros(N, M); % To store phase data

% Start the timer to measure performance.
tic;

% The main loop: iterate through each sinusoid.
for k = 1:N
    % Calculate the instantaneous phase for the k-th sinusoid at all time points.
    % Formula: Phi(t) = 2*pi*f*t + initial_phase
    phase_k = 2 * pi * frequencies(k) * t + initial_phases(k);

    % Calculate the k-th sinusoid itself.
    % Formula: s(t) = A * cos(Phi(t))
    sinusoid_k = amplitudes(k) * cos(phase_k);

    % Add this sinusoid to the total signal.
    pink_noise = pink_noise + sinusoid_k;

    % Store the calculated instantaneous phases for this component.
    instantaneous_phases(k, :) = phase_k;
    
    % Optional: Display progress
    if mod(k, 1000) == 0
        fprintf('Processed %d of %d sinusoids...\n', k, N);
    end
end

% Stop the timer.
elapsed_time = toc;
fprintf('Synthesis complete! Time elapsed: %.2f seconds.\n', elapsed_time);

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

%% Example: Accessing Phase Information
% You can now access the phase of any component at any time.
% For example, let's get the phase of the 100th sinusoid at sample 5000.
component_index = 100;
sample_index = 128;
phase_value = instantaneous_phases(component_index, sample_index);
fprintf('\nPhase of component %d at sample %d is %.4f radians.\n', ...
        component_index, sample_index, phase_value);
    