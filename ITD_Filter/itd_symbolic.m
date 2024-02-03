clear all;
N = 2^16;
Fs = 96000;
stopband = 2150;
kneeband = 1400;
gd1 = 85e-6;
gd2 = 65e-6;
wN = 2^15;
lp_pulse_td1 = create_itd_filter(N, Fs, stopband, kneeband, gd1, wN);
lp_pulse_td2 = create_itd_filter(N, Fs, stopband, kneeband, gd2, wN);
filename = sprintf('itd_%dusL_%dusR_%dHz_%dk_%d.wav', ...
    fix(gd1 * 1e6), fix(gd2 * 1e6), stopband, wN / 1024, Fs / 1000);
% audiowrite(filename, [lp_pulse_td1(:), lp_pulse_td2(:)], Fs, 'BitsPerSample', 64);

figure;
grid on;
plot_w_and_gd(N, Fs, lp_pulse_td1, 'log');

function lp_pulse_td = create_itd_filter(in_N, in_Fs, in_stopband, in_kneeband, in_gd, in_wN)
    bin_w = in_Fs / in_N;
    bin_i = round([1 18 25 in_kneeband in_stopband] ./ bin_w);
    bin_i(1) = 1;
    f_hz = bin_i .* bin_w;

    gd_w = @(x) -in_gd * x; % f_hz(3)..f_hz(4)
    syms x;
    gd_knee_f = -in_gd * (cos(pi*((x - f_hz(4))/(f_hz(5)-f_hz(4)))) + 1)/2;
    gd_knee_w = int(gd_knee_f);
    gd_rev_knee_f = -in_gd * cos(pi/2*((x - f_hz(3))/(f_hz(3)-f_hz(2))));
    gd_rev_knee_w = int(gd_rev_knee_f);

    w = zeros(1, in_N);
    w(bin_i(4):bin_i(5)) = subs(gd_knee_w, x, linspace(f_hz(4), f_hz(5), bin_i(5)-bin_i(4)+1)) - ...
        subs(gd_knee_w, x, f_hz(5));
    offset_4 = w(bin_i(4));
    w(bin_i(3):bin_i(4)) = gd_w(linspace(f_hz(3), f_hz(4), bin_i(4)-bin_i(3)+1)) - ...
        gd_w(f_hz(4)) + offset_4;
    offset_3 = w(bin_i(3));
    w(bin_i(2):bin_i(3)) = subs(gd_rev_knee_w, x, linspace(f_hz(2), f_hz(3), bin_i(3)-bin_i(2)+1)) - ...
        subs(gd_rev_knee_w, x, f_hz(3)) + offset_3;
    offset_2 = w(bin_i(2));
    ramp_w = @(x) (x + sin(x)) / pi;
    w(bin_i(1):bin_i(2)) = offset_2 * ramp_w(linspace(0, pi, bin_i(2)-bin_i(1)+1));
    pulse_fd = exp(1i * 2*pi * w);
    pulse_fd(in_N/2+2:in_N) = conj(flip(pulse_fd(2:in_N/2)));
    pulse_fd(1) = 1;
    pulse_fd(in_N/2+1) = 1;
    pulse_td = ifft(pulse_fd);
    [pmax, pidx] = max(pulse_td);
    lp_pulse_td = circshift(pulse_td, in_N/2-pidx+1);
    cut_i = (in_N - in_wN) / 2;
    lp_pulse_td = lp_pulse_td(cut_i:cut_i+in_wN-1);
    lp_pulse_td = hann(in_wN)' .* lp_pulse_td;
end

function plot_w_and_gd(in_N, in_Fs, lp_pulse_td, xaxis)
    freqs = linspace(0, in_Fs, in_N);
    plen = length(lp_pulse_td);
    pad = zeros(1, ((in_N-plen)/2));
    p_td = [pad lp_pulse_td pad];
    [pmax, pidx] = max(p_td);
    p_td = circshift(p_td, -(pidx-1));
    %plot(p_td);
    p_fd = fft(p_td);
    p_am = 20*log10(abs(p_fd));
    p_w = unwrap(angle(p_fd));
    p_gd = -diff(p_w) / (in_Fs / in_N * 2*pi);
    yyaxis left;
%     if xaxis == 'log'
%         semilogx(freqs, p_am);
%     else
%         plot(freqs, p_am);
%     end
%     ylabel('dB');
%     yyaxis right;
    if xaxis == 'log'
        semilogx(freqs, p_w);
    else
        plot(freqs, p_w);
    end
    ylabel('rad');
    yyaxis right;
    if xaxis == 'log'
        semilogx(freqs, [p_gd(1) p_gd] * 1e6);
    else
        plot(freqs, [p_gd(1) p_gd] * 1e6);
    end
    ylabel('{\mu}s');
end

% n = 1:bin_i(5)+100;
% plot(n, w(n));
% hold on;
% plot(bin_i(1), w(bin_i(1)), 'o', bin_i(2), w(bin_i(2)), '*', ...
%     bin_i(3), w(bin_i(3)), 'x', bin_i(4), w(bin_i(4)), 'square');
% hold off;

