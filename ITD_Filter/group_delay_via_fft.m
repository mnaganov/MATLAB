clear all;
A = 1;
Fs = 96000;
% N = 65536;
N = 16384;
inputGD = -95e-6;
stopband = 1400;
% 0 .1. -kneef | [0 pi] .2. kneef | [-pi 0] .3. -gd * x .4. kneef | [0 pi] .5. 0
fhz = [Fs/N 20 30 1000 stopband];
gd = inputGD * (fhz(5) - fhz(4)) * (N / (Fs * 2));
kneef = @(x) -gd * (x + sin(x) - pi) / 2;
fnorm = fhz ./ Fs;
binidx = round(fnorm .* N);
w = zeros(1, N);
w(binidx(4):binidx(5)) = kneef(linspace(0, pi, binidx(5) - binidx(4) + 1));
linef = @(x) -gd * x + w(binidx(4));
seglenratio54to43 = (binidx(5) - binidx(4) + 1) / (binidx(4) - binidx(3) + 1);
w(binidx(3):binidx(4)) = linef(linspace(-pi / seglenratio54to43, 0, binidx(4) - binidx(3) + 1));
seglenratio54to32 = (binidx(5) - binidx(4) + 1) / (binidx(3) - binidx(2) + 1);
w(binidx(2):binidx(3)) = (kneef(linspace(-pi, 0, binidx(3) - binidx(2) + 1)) - kneef(0)) ...
   / seglenratio54to32 + w(binidx(3));
w(binidx(1):binidx(2)) = (-(kneef(linspace(0, pi, binidx(2) - binidx(1) + 1))-kneef(0))/kneef(0)) * w(binidx(2));

% n = 1:binidx(5)+1;
% plot(n, w(n));
% hold on;
% plot(binidx(1), w(binidx(1)), 'o', binidx(2), w(binidx(2)), '*', ...
%     binidx(3), w(binidx(3)), 'x', binidx(4), w(binidx(4)), 'square');
% hold off;

pulsefft = exp(1i * 2 * pi * w);
pulsefft(N/2+2:N) = conj(flip(pulsefft(2:N/2)));
pulsefft(N/2+1) = 1;
gd = -diff(unwrap(angle(pulsefft))) / ((Fs / N) * 2 * pi);
% freqs = linspace(0, Fs, N);
% figure;
% grid on;
% yyaxis left;
% semilogx(freqs, unwrap(angle(pulsefft)));
% yyaxis right;
% semilogx(freqs, [0 gd] * 1e6);

pulse = ifft(pulsefft);
[pmax, pidx] = max(pulse);
filename = sprintf('filter_pulse_%dus_%dHz_%dk.wav', fix(inputGD * 1e6), stopband, N / 1024);
audiowrite(filename, circshift(pulse, N/2-pidx+1), Fs, 'BitsPerSample', 64);
%audiowrite(filename, pulse, Fs, 'BitsPerSample', 64);
