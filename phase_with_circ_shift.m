% Parameters
fs = 1024;                % sampling frequency (arbitrary)
N  = 256;                 % signal length
t  = (0:N-1)/fs;          % time axis

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

% Number of circular shifts to show
numShifts = 4;
shiftVals = round(linspace(0, N/4, numShifts));  % different shift amounts

% FFT frequency axis
f = (0:N-1)*(fs/N);

% Plot
figure;
for i = 1:numShifts
    m = shiftVals(i);
    
    % Circular shift
    x_shift = circshift(x, m);
    
    % FFT
    X_shift = fft(x_shift);
    
    % Time-domain
    subplot(3, numShifts, i);
    plot(t, x_shift, 'k');
    title(['Time, shift = ' num2str(m)]);
    xlabel('Time (s)'); ylabel('Amplitude');
    xlim([0 t(end)]);
    
    % Magnitude spectrum
    subplot(3, numShifts, i+numShifts);
    plot(f, abs(X_shift), 'b');
    title('|X[k]|');
    xlabel('Frequency (Hz)'); ylabel('Magnitude');
    xlim([0 fs/2]);
    
    % Phase spectrum
    subplot(3, numShifts, i+2*numShifts);
    ph = angle(X_shift);
%     plot(f, unwrap(ph));
    %stem(f, ph, 'r');
    thresh = 0.2 * max(mag);
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

sgtitle('Circular Shift');
