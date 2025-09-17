% Demo: percussive burst decomposition, horizontal sinusoid panel
clear; close all;

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
mag = abs(X);
phase = angle(X);
f = (0:N-1)*(fs/N);

% Positive-frequency bins (exclude DC and Nyquist if even length)
if mod(N,2)==0
    posBins = 2:(N/2);
else
    posBins = 2:ceil(N/2);
end

% Pick top K bins by magnitude
K = 9;
[~, orderPos] = sort(mag(posBins), 'descend');
keepPos = sort(posBins(orderPos(1:K)));  % sorted by frequency

% Build reconstruction spectrum (Hermitian)
X_recon = zeros(size(X));
for kk = 1:K
    k = keepPos(kk);
    conjIdx = mod(N - (k-1), N) + 1;
    X_recon(k)       = X(k);
    X_recon(conjIdx) = conj(X(k));
end
x_recon = real(ifft(X_recon));

% Individual components
components = zeros(K, N);
for kk = 1:K
    k = keepPos(kk);
    conjIdx = mod(N - (k-1), N) + 1;
    X_single = zeros(size(X));
    X_single(k)       = X(k);
    X_single(conjIdx) = conj(X(k));
    components(kk,:)  = real(ifft(X_single));
end

% Cloaking threshold
thresh = 0.05 * max(mag);

% Shared y-axis limit
yL = 1.05 * max(abs(x));

% Short time vector for component display (0.02 s)
t_short = t(t <= 0.02);
Nshort = numel(t_short);

% Figure
%figure('Position',[120 120 1400 900]);
figure;

% --- Top-left: original vs reconstruction ---
subplot(2,2,1);
plot(t, x, 'k', 'LineWidth', 1.2); hold on;
plot(t, x_recon, 'r:', 'LineWidth', 1.4);
title(sprintf('Original burst vs Top-%d Reconstruction', K));
xlabel('Time (s)'); ylabel('Amplitude');
legend('Original',sprintf('Top-%d recon',K),'Location','best');
grid on; xlim([0 max(t)]); ylim([-yL yL]);

% --- Top-right: magnitude spectrum (cloaked) ---
subplot(2,2,2); hold on;
for k = 1:N
    if mag(k) > thresh
        stem(f(k), mag(k), 'b');
    else
        stem(f(k), mag(k), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
    end
end
title('Magnitude Spectrum');
xlabel('Frequency (Hz)'); ylabel('|X[k]|');
xlim([0 fs/2]); grid on;

% --- Bottom-left: horizontal panel of sinusoid components ---
ax_container = subplot(2,2,3);
pos = get(ax_container, 'Position'); delete(ax_container);

% Divide horizontally into K tiles
w_each = pos(3) / K;
colors = lines(K);

for kk = 1:K
    x0 = pos(1) + (kk-1)*w_each;
    ax_comp = axes('Position', [x0 pos(2) w_each*0.95 pos(4)]);
    plot(t_short, components(kk,1:Nshort), 'Color', colors(kk,:), 'LineWidth', 1.2);
    ylim([-yL yL]); xlim([0 max(t_short)]);
    grid on;
    % Label only the first subplot’s y-axis
    if kk > 1
        set(ax_comp, 'YTickLabel', []);
        ylabel('');
    else
        ylabel('Amplitude');
    end
    % Hide x-ticks (too crowded), only show for the first
    if kk > 1
        set(ax_comp, 'XTickLabel', []);
    else
        xlabel('Time (s)');
    end
    title_handle = title(sprintf('%.1f Hz', f(keepPos(kk))));
    ax_comp.Title.Rotation = 90;
    current_pos = get(title_handle, 'Position');
    new_pos = [current_pos(1), -yL, current_pos(3)];
    set(title_handle, 'Position', new_pos);
    set(title_handle, 'HorizontalAlignment', 'left');
    set(title_handle, 'VerticalAlignment', 'top');
end
annotation('textbox',[pos(1) pos(2)+pos(4)+0.01 pos(3) 0.03], ...
    'String', sprintf('Top-%d Sinusoidal Components (0–0.02 s)',K), ...
    'EdgeColor','none','HorizontalAlignment','center');

% --- Bottom-right: phase spectrum (raw) with cloaking ---
subplot(2,2,4); hold on;
for k = 1:N
    if mag(k) > thresh
        stem(f(k), phase(k), 'r');
    else
        stem(f(k), phase(k), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
    end
end
title('Phase Spectrum');
xlabel('Frequency (Hz)'); ylabel('Phase (rad)');
xlim([0 fs/2]); grid on;

sgtitle(sprintf('Percussive Burst → Top-%d Sinusoidal Components, Magnitude, and Phase', K));
