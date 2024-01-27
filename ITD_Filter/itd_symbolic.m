clear all;
in_Fs = 96000;
in_N = 2^16;
in_stopband = 2150;
in_kneeband = 1400;
in_gd = -140e-6;

fhz = [in_Fs/in_N 10 20 in_kneeband in_stopband];
ramp_gd = -in_gd * (fhz(5) - fhz(3)) / fhz(3);

ramp_w = @(x) -ramp_gd * x;
gd_w = @(x) -in_gd * x;
syms x;
r_gd_knee_f = abs(in_gd - ramp_gd) * (sin(pi*((x - fhz(2))/(fhz(3)-fhz(2)))-pi/2)+1)/2 - ramp_gd;
r_gd_knee_w = int(r_gd_knee_f);
gd_knee_f = -in_gd * (cos(pi*((x - fhz(4))/(fhz(5)-fhz(4)))) + 1)/2;
gd_knee_w = int(gd_knee_f);
% gd_f = piecewise(x <= fhz(1), ramp_gd, ...
%     (x > fhz(1)) & (x < fhz(2)), ramp_gd, ...
%     (x >= fhz(2)) & (x <= fhz(3)), abs(in_gd - ramp_gd) * (sin(pi*((x - fhz(2))/(fhz(3)-fhz(2)))-pi/2)+1)/2 + ramp_gd, ...
%     (x > fhz(3)) & (x < fhz(4)), in_gd, ...
%     (x >= fhz(4)) & (x <= fhz(5)), in_gd * (cos(pi*((x - fhz(4))/(fhz(5)-fhz(4)))) + 1)/2, ...
%      x > fhz(5), 0);
% w_f = int(gd_f);

fnorm = fhz ./ in_Fs;
bin_i = round(fnorm .* in_N);
%[ramp_i, r_gd_knee_i, gd_i, gd_knee_i, zero_i] = feval(@(x) x{:}, num2cell(binidx));
w = zeros(1, in_N);
w(bin_i(4):bin_i(5)) = subs(gd_knee_w, x, linspace(fhz(4), fhz(5), bin_i(5)-bin_i(4)+1)) - ...
    subs(gd_knee_w, x, fhz(5));
offset_4 = w(bin_i(4));
w(bin_i(3):bin_i(4)) = gd_w(linspace(fhz(3), fhz(4), bin_i(4)-bin_i(3)+1)) - ...
    gd_w(fhz(4)) + offset_4;
offset_3 = w(bin_i(3));
w(bin_i(2):bin_i(3)) = subs(r_gd_knee_w, x, linspace(fhz(2), fhz(3), bin_i(3)-bin_i(2)+1)) - ...
    subs(r_gd_knee_w, x, fhz(3)) + offset_3;
offset_2 = w(bin_i(2));
w((bin_i(1)+1):bin_i(2)) = ramp_w(linspace(fhz(1), fhz(2), bin_i(2)-bin_i(1))) - ...
    ramp_w(fhz(2)) + offset_2;

figure;
grid on;
% plot_freqs = linspace(0, in_stopband, fix((in_Fs / in_N) * in_stopband));
% semilogx(plot_freqs, subs(w_f, x, plot_freqs));
% n = 1:in_N/2;
% n = 1:bin_i(5)+100;
% plot(n, w(n));
% hold on;
% plot(bin_i(1), w(bin_i(1)), 'o', bin_i(2), w(bin_i(2)), '*', ...
%     bin_i(3), w(bin_i(3)), 'x', bin_i(4), w(bin_i(4)), 'square');
% hold off;

pulsefft = exp(1i * 2 * pi * w);
pulsefft(in_N/2+2:in_N) = conj(flip(pulsefft(2:in_N/2)));
pulsefft(in_N/2+1) = 1;
gd_res = -diff(unwrap(angle(pulsefft))) / ((in_Fs / in_N) * 2 * pi);
freqs = linspace(0, in_Fs, in_N);
yyaxis left;
semilogx(freqs, unwrap(angle(pulsefft)));
yyaxis right;
semilogx(freqs, [gd_res(1) gd_res] * 1e6);
