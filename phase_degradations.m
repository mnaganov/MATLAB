% Parameters
fs = 1024;
N  = 256;
n  = 0:N-1;
t  = n/fs;
audio_out = zeros(1, N);

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

% Changes count
numChanges = 4;

% Precompute index ranges for positive/negative freqs (N is even)
kDC = 1;                    % MATLAB index for k=0
kNyq = N/2 + 1;             % MATLAB index for k = N/2 (if N even)
posIdx = 2:(N/2);           % positive freq bins (k = 1 .. N/2-1)
negIdx = N:-1:(N/2+2);      % corresponding negative freq bins (conjugates)

%figure('Position',[100 100 1200 700]);
for i = 1:numChanges
    % Start from original X and create a changed copy
    Xs = X; 
    
    if i == 3
        % Zero out phase information
        mag = abs(X);
        Xs(posIdx) = mag(posIdx);
        Xs(negIdx) = mag(negIdx);
        % Shift to bring to the middle
        Xs = fft(circshift(ifft(Xs), -round(N/2)));
    elseif i == 2
        % Random phase shifts
        for idx = 1:length(posIdx)
            % Apply +phi to positive freqs and -phi to their conjugates
            phi = (pi/2) * rand;
            Xs(posIdx(idx)) = X(posIdx(idx)) * exp(1j*phi);         % positive freqs
            Xs(negIdx(idx)) = X(negIdx(idx)) * exp(-1j*phi);        % negative freqs (conjugates)
            % Leave DC (Xs(kDC)) and Nyquist (Xs(kNyq)) unchanged to preserve reality
        end
    elseif i == 4
        % Minimum phase
        [~, x_min] = rceps(x);
        Xs = fft(x_min);
    end        
    
    % Inverse FFT (should be real within numerical tolerance)
    x_shift = ifft(Xs);
    audio_out = [audio_out x_shift zeros(1,N)];
    
    % Check Hermitian symmetry (debug, optional)
    %err_sym = max(abs(Xs(negIdx) - conj(Xs(posIdx))));
    
    % Plots
    subplot(3, numChanges, i);
    plot(t, x_shift, 'k');
    if i == 1
        title('Original');
    elseif i == 3
        title('Linear phase');
    elseif i == 2
        title('Random shift');
    elseif i == 4
        title('Minimum phase');
    end
    xlabel('Time (s)'); ylabel('Amplitude');
    xlim([0 t(end)]);
    ylim([-0.6 0.6]);
    
    subplot(3, numChanges, i+numChanges);
    mag = abs(Xs);                  % magnitude spectrum    
    plot(f, mag); xlim([0 fs/2]);
    title('|X[k]|');
    xlabel('Frequency (Hz)'); ylabel('Magnitude'); grid on;
    
    subplot(3, numChanges, i+2*numChanges);
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
    ylim([-4 4]);
    title('Phase');
    xlabel('Frequency (Hz)'); ylabel('Phase (rad)'); grid on;
end

sgtitle('Various phase manipulations');

% Small numeric sanity print (not required)
%fprintf('Max imag part across all outputs (should be ~1e-15): %.3e\n', max(abs(imag(ifft( X .* exp(1j*phiVals(end)) )))));
out_fs = 8000;
[p, q] = rat(out_fs / fs);

normFc = .98 / max(p,q);
order = 256 * max(p,q);
beta = 12;

lpFilt = firls(order, [0 normFc normFc 1],[1 1 0 0]);
lpFilt = lpFilt .* kaiser(order+1,beta)';
lpFilt = lpFilt / sum(lpFilt);

% multiply by p
lpFilt = p * lpFilt;
audiowrite('phase_degradations.wav', resample(audio_out, p, q, lpFilt), out_fs, 'BitsPerSample', 32);
