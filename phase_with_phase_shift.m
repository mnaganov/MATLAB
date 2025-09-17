% Parameters
fs = 1024;
N  = 256;
n  = 0:N-1;
t  = n/fs;

% Parameters
fs = 1024;
N  = 256;
n  = 0:N-1;
t  = n/fs;

% --- Create a percussive burst (decaying cosine), asymmetrically windowed ---
f0  = 128;            % center frequency (Hz)
tau = 0.01;           % decay time (s)

% Core burst: decaying exponential cosine
burst = exp(-t/tau) .* cos(2*pi*f0*t);

% Asymmetric window:
fadeInLen = round(N/32);     % quick attack length
fadeIn  = hann(2*fadeInLen)'; 
fadeIn  = fadeIn(1:fadeInLen);   % take only rising half
sustain = ones(1, N - fadeInLen);
asymWin = [fadeIn sustain];      % total length = N

% Apply asymmetric window
x = burst .* asymWin;
x = -circshift(x, 76);

% FFT
X = fft(x);
f = (0:N-1)*(fs/N);

% Phase steps
numSteps = 4;
phiVals = linspace(0, pi/2, numSteps);

% Precompute index ranges for positive/negative freqs (N is even)
kDC = 1;                    % MATLAB index for k=0
kNyq = N/2 + 1;             % MATLAB index for k = N/2 (if N even)
posIdx = 2:(N/2);           % positive freq bins (k = 1 .. N/2-1)
negIdx = N:-1:(N/2+2);      % corresponding negative freq bins (conjugates)

%figure('Position',[100 100 1200 700]);
for i = 1:numSteps
    phi = phiVals(i);
    
    % Start from original X and create a shifted copy
    Xs = X; 
    
    % Apply +phi to positive freqs and -phi to their conjugates
    Xs(posIdx) = X(posIdx) * exp(1j*phi);         % positive freqs
    Xs(negIdx) = X(negIdx) * exp(-1j*phi);        % negative freqs (conjugates)
    % Leave DC (Xs(kDC)) and Nyquist (Xs(kNyq)) unchanged to preserve reality
    
    % Inverse FFT (should be real within numerical tolerance)
    x_shift = ifft(Xs);
    
    % Check Hermitian symmetry (debug, optional)
    %err_sym = max(abs(Xs(negIdx) - conj(Xs(posIdx))));
    
    % Plots
    subplot(3, numSteps, i);
    plot(t, x_shift, 'k');
    title(sprintf('Time, phi = %.2f rad', phi));
    xlabel('Time (s)'); ylabel('Amplitude');
    xlim([0 t(end)]);
    
    subplot(3, numSteps, i+numSteps);
    mag = abs(Xs);                  % magnitude spectrum    
    plot(f, mag); xlim([0 fs/2]);
    title('|X[k]|');
    xlabel('Frequency (Hz)'); ylabel('Magnitude'); grid on;
    
    subplot(3, numSteps, i+2*numSteps);
    % Only show 0..fs/2 for clarity
    ph = angle(Xs);
    thresh = 0.2 * max(mag);
    %plot(f, ph);
    %stem(f, ph, 'r');
    hold on;
    for k = 1:N
        if mag(k) > thresh
            % Strong color for significant bins
            stem(f(k), ph(k), 'r');
        else
            % Muted color for insignificant bins
            stem(f(k), ph(k), 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5);
        end
    end
    hold off;
    xlim([0 fs/2]);
    title('Phase');
    xlabel('Frequency (Hz)'); ylabel('Phase (rad)'); grid on;
end

sgtitle('Antisymmetric Phase Shift');

% Small numeric sanity print (not required)
fprintf('Max imag part across all outputs (should be ~1e-15): %.3e\n', max(abs(imag(ifft( X .* exp(1j*phiVals(end)) )))));
