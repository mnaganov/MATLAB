clear all;
in_Fs = 48000;
in_N = 2^16;
in_stopband = 2150;
in_kneeband = 1400;
in_gd = 85e-6;

bin_w = in_Fs/in_N;
round_to_bin = @(x) round(x / bin_w) * bin_w;
fhz = round_to_bin([1 10 30 in_kneeband in_stopband]);
fhz(1) = bin_w;
%time_res = 1 / in_Fs;
%gd = round(in_gd / time_res) * time_res; 
gd = in_gd;

gd_w = @(x) -gd * x; % fhz(3)..fhz(4)
syms x;
gd_knee_f = -gd * (cos(pi*((x - fhz(4))/(fhz(5)-fhz(4)))) + 1)/2;
gd_knee_w = int(gd_knee_f);

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
pb_a = (offset_3 - gd * (fhz(3) - fhz(1))) / (fhz(3) - fhz(1)) .^ 2;
pb_b = gd + 2 * pb_a * fhz(3);
pb_c = offset_3 + fhz(3) * (pb_a * fhz(3) - pb_b);
proj_w = @(x) -pb_a * x .^ 2 + pb_b * x + pb_c;
w(bin_i(1):bin_i(3)) = proj_w(linspace(fhz(1), fhz(3), bin_i(3)-bin_i(1)+1));

figure;
grid on;

% n = 1:bin_i(5)+100;
% plot(n, w(n));
% hold on;
% plot(bin_i(1), w(bin_i(1)), 'o', bin_i(2), w(bin_i(2)), '*', ...
%     bin_i(3), w(bin_i(3)), 'x', bin_i(4), w(bin_i(4)), 'square');
% hold off;

pulse_fd = exp(1i * 2*pi * w);
pulse_fd(in_N/2+2:in_N) = conj(flip(pulse_fd(2:in_N/2)));
pulse_fd(1) = 1;
pulse_fd(in_N/2+1) = 1;
freqs = linspace(0, in_Fs, in_N);
gd_res = -diff(unwrap(angle(pulse_fd))) / (bin_w * 2*pi);
yyaxis left;
%semilogx(freqs, unwrap(angle(pulse_fd)));
plot(freqs, unwrap(angle(pulse_fd)));
yyaxis right;
%semilogx(freqs, [gd_res(1) gd_res] * 1e6);
plot(freqs, [gd_res(1) gd_res] * 1e6);

pulse_td = ifft(pulse_fd);
[pmax, pidx] = max(pulse_td);
lp_pulse_td = circshift(pulse_td, in_N/2-pidx+1);

% pulse_fft = fft(pulse_td);
% gd_res_fft = -diff(unwrap(angle(pulse_fft))) / (bin_w * 2*pi);
% hold on;
% semilogx(freqs, [gd_res_fft(1) gd_res_fft] * 1e6);
% hold off;

filename = sprintf('itd_%dus_%dHz_%dk_%d.wav', ...
    fix(in_gd * 1e6), in_stopband, in_N / 1024, in_Fs / 1000);
audiowrite(filename, lp_pulse_td, in_Fs, 'BitsPerSample', 64);
